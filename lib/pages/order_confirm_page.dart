import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/screens.dart';
import '../models/cart_item.dart';
import '../services/pocketbase_client.dart';

class OrderConfirmPage extends StatefulWidget {
  static const routeName = '/order_confirm';
  const OrderConfirmPage({super.key});

  @override
  State<OrderConfirmPage> createState() => _OrderConfirmPageState();
}

class _OrderConfirmPageState extends State<OrderConfirmPage> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
    _addressController = TextEditingController();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    try {
      final pb = await getPocketbaseInstance();
      final userRecord = pb.authStore.record;
      if (userRecord != null) {
        setState(() {
          _nameController.text = userRecord.data['name'] ?? 'Unknown';
          _phoneController.text = userRecord.data['phone'] ?? 'N/A';
          _emailController.text = userRecord.data['email'] ?? 'N/A';
          _addressController.text = userRecord.data['address'] ?? '';
        });
      }
    } catch (e) {
      print("Error loading user info: $e");
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartManager = Provider.of<CartsManager>(context);
    final orderManager = Provider.of<OrdersManager>(context);
    final carts = cartManager.carts;
    double total =
        carts.fold(0, (sum, item) => sum + item.price * item.quantity);

    return Scaffold(
      appBar: AppBar(title: const Text('Xác nhận đơn hàng')),
      body: Column(
        children: [
          // Phần thông tin người dùng
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Thông tin giao hàng',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Họ tên'),
                  enabled: true,
                ),
                TextField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Số điện thoại'),
                  enabled: true,
                  keyboardType: TextInputType.phone,
                ),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  enabled: false, // Giữ email không chỉnh sửa
                ),
                TextField(
                  controller: _addressController,
                  decoration: const InputDecoration(labelText: 'Địa chỉ'),
                ),
              ],
            ),
          ),
          // Phần danh sách sản phẩm
          Expanded(
            child: ListView.builder(
              itemCount: carts.length,
              itemBuilder: (ctx, index) {
                final CartItem item = carts[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 60,
                          height: 60,
                          child: Image.network(
                            item.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.error),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text('Số lượng: ${item.quantity}'),
                            ],
                          ),
                        ),
                        Text(
                          '${item.price * item.quantity} đ',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Phần tổng tiền và nút xác nhận
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Tổng tiền: ${total.toInt()} đ',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    onPressed: () async {
                      final pb = await getPocketbaseInstance();
                      final userId = pb.authStore.record!.id;
                      // Cập nhật tất cả thông tin người dùng
                      await pb.collection('users').update(userId, body: {
                        'name': _nameController.text,
                        'phone': _phoneController.text,
                        'address': _addressController.text,
                      });

                      await orderManager.addOrder(carts, total.toInt());
                      cartManager.removeUserCart();
                      Navigator.of(context)
                          .pushReplacementNamed(OrdersPage.routeName);
                    },
                    child:
                        const Text('Xác nhận', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

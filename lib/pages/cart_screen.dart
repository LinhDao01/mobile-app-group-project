import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/screens.dart';
import '../models/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartManager = Provider.of<CartsManager>(context);
    final carts = cartManager.carts;
    for (var item in carts) {
      print(
          'CartItem: id=${item.id}, name=${item.name}, quantity=${item.quantity}, price=${item.price}');
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Giỏ Hàng của bạn'),
      ),
      body: cartManager.itemCount == 0
          ? Center(child: Text('Chưa có sản phẩm trong giỏ hàng'))
          : ListView.builder(
              itemCount: cartManager.itemCount,
              itemBuilder: (ctx, index) {
                final CartItem item = carts[index];
                return ListTile(
                  leading: SizedBox(
                    width: 50,
                    height: 50,
                    child: Image.network(item.imageUrl, fit: BoxFit.cover),
                  ),
                  title: Text(item.name),
                  subtitle: Text('Số lượng: ${item.quantity}'),
                  trailing: Text('${item.price * item.quantity} đ'),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Chuyển đến trang xác nhận đơn hàng
          Navigator.of(context).pushNamed(OrderConfirmPage.routeName);
        },
        label: const Text('Xác nhận đơn hàng'),
        icon: const Icon(Icons.check),
      ),
    );
  }
}

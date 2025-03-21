import 'package:ct312h_project/components/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/orders_manager.dart';
import '../components/app_drawer.dart';
import '../components/order_item_card.dart';

class OrdersPage extends StatefulWidget {
  static const routeName = '/orders';
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  late Future<void> _fetchOrdersFuture;

  @override
  void initState() {
    super.initState();
    _fetchOrdersFuture =
        Provider.of<OrdersManager>(context, listen: false).fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      drawer: const MyDrawer(),
      body: FutureBuilder(
        future: _fetchOrdersFuture,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Loading());
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Failed to load orders: ${snapshot.error}'));
          } else {
            return Consumer<OrdersManager>(
              builder: (ctx, ordersManager, child) {
                return ordersManager.orderCount == 0
                    ? const Center(child: Text('No orders found'))
                    : ListView.builder(
                        itemCount: ordersManager.orderCount,
                        itemBuilder: (ctx, i) =>
                            OrderItemCard(ordersManager.orders[i]),
                      );
              },
            );
          }
        },
      ),
    );
  }
}

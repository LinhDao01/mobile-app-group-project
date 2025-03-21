import 'package:flutter/foundation.dart';
// import 'package:pocketbase/pocketbase.dart';

import '../services/orders_service.dart';
import '../models/cart_item.dart';
import '../models/order.dart';

class OrdersManager with ChangeNotifier {
  final OrdersService _ordersService = OrdersService();
  final List<OrderDish> _orders = [];
  bool _isLoading = false;

  OrdersManager() {
    // initializeOrderList();
  }

  int get orderCount {
    return _orders.length;
  }

  List<OrderDish> get orders {
    return [..._orders];
  }

  Future<void> initializeOrderList() async {
    _orders.clear();
    final fetchedItems = await _ordersService.fetchOrders();
    _orders.addAll(fetchedItems);
    _sortOrdersByDate();
    notifyListeners();
  }

  // double _parseDouble(dynamic value, {double defaultValue = 0.0}) {
  //   if (value == null) return defaultValue;
  //   if (value is num) return value.toDouble();
  //   return double.tryParse(value.toString()) ?? defaultValue;
  // }

  // int _parseInt(dynamic value, {int defaultValue = 0}) {
  //   if (value == null) return defaultValue;
  //   if (value is num) return value.toInt();
  //   return int.tryParse(value.toString()) ?? defaultValue;
  // }

  Future<void> addOrder(List<CartItem> cartProducts, int total) async {
    final newOrder = OrderDish(
      total: total,
      dishes: cartProducts,
      dateTime: DateTime.now(),
    );

    final OrderDish? orderDish = await _ordersService.addOrder(newOrder);

    if (orderDish != null) {
      _orders.insert(0, orderDish);
      _sortOrdersByDate();
      notifyListeners();
    }
  }

  Future<void> fetchOrders() async {
    // _isLoading = true;
    // notifyListeners();

    try {
      final fetchedOrders = await _ordersService.fetchOrders();
      _orders.clear();
      _orders.addAll(fetchedOrders);
      _sortOrdersByDate();
      notifyListeners();
    } catch (e) {
      print("Error fetching orders: \$e");
      rethrow;
    }
  }

  void _sortOrdersByDate() {
    _orders.sort((a, b) => b.dateTime.compareTo(a.dateTime)); // Mới nhất -> cũ nhất
  }
}

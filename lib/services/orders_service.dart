import 'package:pocketbase/pocketbase.dart';

import '../models/cart_item.dart';
import '../models/order.dart';
import '../services/pocketbase_client.dart';

class OrdersService {
  final PocketBase pb = PocketBase('http://192.168.1.57:8090');

  Future<OrderDish?> addOrder(OrderDish orderDish) async {
    try {
      final pb = await getPocketbaseInstance();
      final userId = pb.authStore.record!.id;
      print("Current User ID when add: $userId");
      print(
          "Creating order with total: ${orderDish.total}, dishes: ${orderDish.dishes.length}");

      final orderModel = await pb.collection('orders').create(
        body: {
          'userId': userId,
          'total': orderDish.total,
          'dateTime': orderDish.dateTime.toIso8601String(),
        },
      );

      final orderId = orderModel.id;
      print("Created order with ID: $orderId");

      for (CartItem cartItem in orderDish.dishes) {
        print("Attempting to add item: ${cartItem.toJson()}");
        final itemResponse = await pb.collection('order_items').create(
          body: {
            'orderId': orderId,
            'dishId': cartItem.dishId,
            'quantity': cartItem.quantity,
            'name': cartItem.name,
            'price': cartItem.price,
            'imageUrl': cartItem.imageUrl,
          },
        );
        print(
            "Added order item with ID: ${itemResponse.id}, data: ${itemResponse.data}");
      }

      return OrderDish(
        id: orderId,
        total: orderDish.total,
        dishes: orderDish.dishes,
        dateTime: orderDish.dateTime,
      );
    } catch (e) {
      print("Error adding order: $e");
      return null;
    }
  }

  Future<List<OrderDish>> fetchOrders() async {
    final List<OrderDish> orders = [];
    try {
      final pb = await getPocketbaseInstance();
      final userId = pb.authStore.record!.id;
      print("Current User ID when init: $userId");

      final orderModels = await pb.collection('orders').getFullList(
            filter: "userId='$userId'",
          );

      for (final orderModel in orderModels) {
        print("Order data: ${orderModel.data}");
        final orderDishesModels =
            await pb.collection('order_items').getFullList(
                  filter: "orderId='${orderModel.id}'",
                );
        print(
            "Number of items in order ${orderModel.id}: ${orderDishesModels.length}");
        if (orderDishesModels.isEmpty) {
          print("No items found for order ${orderModel.id}");
        }

        final dishes = await Future.wait(orderDishesModels.map((item) async {
          print("Order item data: ${item.data}");
          final dishId = item.data['dishId'] as String;
          final dishModel = await pb.collection('dishes').getOne(dishId);
          print("Dish data: ${dishModel.data}");

          return CartItem(
            id: item.id,
            dishId: dishId,
            userId: userId,
            name: dishModel.data['name'] as String? ?? 'Unknown',
            imageUrl: dishModel.data['imageUrl'] as String? ?? '',
            quantity: item.data['quantity'] as int? ?? 0,
            price: dishModel.data['price'] as int? ?? 0,
          );
        }).toList());

        orders.add(OrderDish(
          id: orderModel.id,
          total: orderModel.getIntValue('total'),
          dateTime: DateTime.parse(orderModel.created),
          dishes: dishes,
        ));
      }
      return orders;
    } catch (error) {
      print("Error fetching orders: $error");
      return orders;
    }
  }
}

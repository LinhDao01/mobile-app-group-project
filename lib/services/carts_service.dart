import 'package:ct312h_project/models/cart_item.dart';
import 'package:http/http.dart' as http;
import 'package:pocketbase/pocketbase.dart';
import '../models/dishes.dart';
import 'pocketbase_client.dart';

class CartsService {
  static final CartsService _instance = CartsService._sharedInstance();

  factory CartsService() {
    return _instance;
  }

  CartsService._sharedInstance();

  Future<String> getUserId() async {
    final pb = await getPocketbaseInstance();
    return pb.authStore.record?.id ?? '';
  }

  String getDishImageUrl(String dishId, String imageName) {
    return 'http://192.168.1.57:8090/api/files/dishes/$dishId/$imageName';
  }

  Future<List<CartItem>> fetchUserCart() async {
    final List<CartItem> cart_items = [];

    try {
      final pb = await getPocketbaseInstance();
      final userId = pb.authStore.record!.id;
      // print("Current User ID when init: $userId");

      final cartModels = await pb
          .collection('cart_items')
          .getFullList(filter: "userId='$userId'");

      for (final cartItemModel in cartModels) {
        final dishId = cartItemModel.data['dishId'];
        final dishItemModel = await pb.collection('dishes').getOne(dishId);

        String imageUrl = getDishImageUrl(dishId, dishItemModel.data['image']);

        final finalModel = {
          ...dishItemModel.toJson(),
          ...cartItemModel.toJson(),
          'id': cartItemModel.id,
          'imageUrl': imageUrl,
        };

        cart_items.add(CartItem.fromJson(finalModel));
      }

      return cart_items;
    } catch (error) {
      print(error);
      return cart_items;
    }
  }

  Future<CartItem?> addToCart(Dish dish, int quantity) async {
    try {
      final pb = await getPocketbaseInstance();
      final userId = pb.authStore.record!.id;

      final existingItems = await pb.collection('cart_items').getFullList(
            filter: "userId='$userId' && dishId='${dish.id}'",
          );

      if (existingItems.isNotEmpty) {
        final existingItem = existingItems.first;
        final updatedQuantity =
            (existingItem.data['quantity'] as int) + quantity;

        await pb.collection('cart_items').update(
          existingItem.id,
          body: {
            'quantity': updatedQuantity,
          },
        );

        return CartItem(
          id: existingItem.id,
          dishId: dish.id!,
          userId: userId,
          name: dish.name,
          imageUrl: dish.imageUrl,
          quantity: updatedQuantity,
          price: dish.price,
        );
      } else {
        final newCartItem = await pb.collection('cart_items').create(
          body: {
            'dishId': dish.id,
            'userId': userId,
            'quantity': quantity,
          },
        );

        return CartItem(
          id: newCartItem.id,
          dishId: dish.id!,
          userId: userId,
          name: dish.name,
          imageUrl: dish.imageUrl,
          quantity: quantity,
          price: dish.price,
        );
      }
    } catch (error) {
      print("Error adding to cart: $error");
      return null;
    }
  }

  Future<bool> removeFromCart(String dishId, {int quantity = 1}) async {
    try {
      final pb = await getPocketbaseInstance();
      final userId = pb.authStore.record!.id;

      final existingItems = await pb.collection('cart_items').getFullList(
            filter: "userId='$userId' && dishId='$dishId'",
          );
      if (existingItems.isNotEmpty) {
        final existingItem = existingItems.first;
        if (existingItem.data['quantity'] > quantity) {
          final updatedQuantity =
              (existingItem.data['quantity'] as int) - quantity;

          await pb.collection('cart_items').update(
            existingItem.id,
            body: {
              'quantity': updatedQuantity,
            },
          );
          return true;
        } else {
          await pb.collection('cart_items').delete(existingItem.id);
          return true;
        }
      }
      return false;
    } catch (error) {
      return false;
    }
  }

  Future<bool> removeUserCart() async {
    try {
      final pb = await getPocketbaseInstance();
      final userId = pb.authStore.record!.id;

      final items = await pb.collection('cart_items').getFullList(
            filter: "userId='$userId'",
          );
      if (items.isEmpty) {
        return false;
      }
      for (var item in items) {
        await pb.collection('cart_items').delete(item.id);
      }
      return true;
    } catch (error) {
      return false;
    }
  }
}

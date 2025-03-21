import 'package:ct312h_project/models/dishes.dart';
import 'package:flutter/foundation.dart';

import '../../models/cart_item.dart';
import '../services/carts_service.dart';

class CartsManager with ChangeNotifier {
  final CartsService _cartsService = CartsService();
  final userId = '';
  final List<CartItem> _carts = [];

  CartsManager() {
    initializeCartList();
  }

  int get itemCount {
    return _carts.length;
  }

  List<CartItem> get carts {
    return [..._carts];
  }

  int findIndexById(String dishId) {
    return _carts.indexWhere((item) => item.dishId == dishId);
  }

  Future<void> initializeCartList() async {
    _carts.clear();
    final fetchedItems = await _cartsService.fetchUserCart();
    _carts.addAll(fetchedItems);
    notifyListeners();
  }

  Future<void> addToCart(Dish dish, int quantity) async {
    final CartItem? newCartItem = await _cartsService.addToCart(dish, quantity);

    if (newCartItem != null) {
      final index = findIndexById(newCartItem.dishId);
      if (index != -1) {
        final updatedItem = _carts[index].copyWith(
          quantity: _carts[index].quantity + quantity,
        );
        _carts[index] = updatedItem;
      } else {
        _carts.insert(0, newCartItem);
      }
    }
    notifyListeners();
  }


  Future<void> removeOneItem(String dishId) async { 
    int index = findIndexById(dishId);
    if (index == -1) {
      return;
    }
    final bool success =
        await _cartsService.removeFromCart(dishId, quantity: 1);
    if (success) {
      if (_carts[index].quantity > 1) {
        final updatedItem = _carts[index].copyWith(
          quantity: _carts[index].quantity - 1,
        );
        _carts[index] = updatedItem;
      } else {
        _carts.removeAt(index);
      }
      notifyListeners();
    }
  }

  Future<void> clearWholeItem(String dishId) async {

    int index = findIndexById(dishId);
    if (index == -1) {
      return;
    }
    final quantity = _carts[index].quantity;
    final bool success =
        await _cartsService.removeFromCart(dishId, quantity: quantity);
    if (success) {
      if (_carts[index].quantity > 1) {
        final updatedItem = _carts[index].copyWith(
          quantity: _carts[index].quantity - 1,
        );
        _carts[index] = updatedItem;
      } else {
        _carts.removeAt(index);
      }
      notifyListeners();
    }
  }

  Future<void> removeUserCart() async {
    final bool success = await _cartsService.removeUserCart();
    if (success){
      _carts.clear();
      notifyListeners();
    }
  }
}

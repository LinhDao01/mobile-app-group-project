import 'package:ct312h_project/themes/light_mode.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ct312h_project/models/menu.dart';
import 'package:ct312h_project/models/carts_manager.dart';

import '../components/sliver_appbar.dart';
import 'package:ct312h_project/components/my_button.dart';
import '../components/quantity_selector.dart';

class DishDetailScreen extends StatefulWidget {
  final String dishId;

  const DishDetailScreen({
    super.key,
    required this.dishId,
  });

  @override
  _DishDetailScreenState createState() => _DishDetailScreenState();
}

class _DishDetailScreenState extends State<DishDetailScreen> {
  int quantity = 1;
  void updateQuantity(int newQuantity) {
    setState(() {
      quantity = newQuantity;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dish = context.watch<Menu>().getDishById(widget.dishId);
    if (dish == null) {
      return const Scaffold(
        body: Center(child: Text('Dish not found')),
      );
    }
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  MySliverAppBar(
                    title: Text(dish.name),
                    child: Image.network(

                      dish.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
                body: Padding(
                  padding: EdgeInsets.only(left: 15, top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dish.name,
                        style: lightmode.textTheme.titleLarge,
                      ),
                      Text('${dish.price} VND',
                          style: lightmode.textTheme.labelLarge),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        dish.description,
                        style: lightmode.textTheme.bodySmall,
                      ),
                      const Spacer(),
                      Align(
                        alignment: Alignment.bottomCenter,

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Quantity:',
                                style: Theme.of(context).textTheme.titleMedium),
                            SizedBox(width: 15),
                            Container(
                              width: 120,
                              height: 44,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 230, 230, 230),
                                borderRadius: BorderRadius.circular(10),

                              ),
                              child: QuantitySelector(
                                onQuantityChanged: updateQuantity,
                                updatedQuantity: quantity,
                              ),
                            ),
                            CartAction(
                              dishId: widget.dishId,
                              onAddToCartPressed: () async {
                                final cart = context.read<CartsManager>();
                                await cart.addToCart(dish, quantity);

                                ScaffoldMessenger.of(context)
                                  ..hideCurrentSnackBar()
                                  ..showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Đã thêm $quantity ${dish.name} vào giỏ hàng!'),
                                      duration: const Duration(seconds: 1),
                                    ),
                                  );
                                setState(() {
                                  quantity = 1;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      )

                    ],
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}

class CartAction extends StatelessWidget {
  final String dishId;
  final VoidCallback onAddToCartPressed;

  const CartAction({
    required this.dishId,
    required this.onAddToCartPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        MyButton(
          text: 'Add',
          onTap: onAddToCartPressed,
        ),
      ],
    );
  }
}

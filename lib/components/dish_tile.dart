import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';

import '../models/dishes.dart';
import '../pages/dish_detail_screen.dart';

class DishTile extends StatefulWidget {
  final Dish dish;
  final void Function()? onFoodTileClick;

  const DishTile({
    super.key,
    required this.dish,
    this.onFoodTileClick,
  });

  @override
  State<DishTile> createState() => _DishTileState();
}

class _DishTileState extends State<DishTile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: widget.onFoodTileClick ??
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => DishDetailScreen(dishId: widget.dish.id!),
                  ),
                );
              },
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 120,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.dish.name,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 19,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Row(
                          children: [
                            Text(
                              '${widget.dish.price} VND',
                              style: TextStyle(
                                color: Colors.black26,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Text(
                          widget.dish.description,
                          style:
                              TextStyle(color: Colors.black54, fontSize: 13.5),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    widget.dish.imageUrl,
                    width: 140,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
        ),
        Dash(
          dashColor: Theme.of(context).colorScheme.primary,
          dashGap: 13,
          dashLength: 10,
          dashThickness: 2,
          length: 330,
        ),
      ],
    );
  }
}

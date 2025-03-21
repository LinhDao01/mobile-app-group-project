import 'package:flutter/material.dart';


class QuantitySelector extends StatefulWidget {
  final Function(int) onQuantityChanged;
  final int? updatedQuantity;

  QuantitySelector(
      {required this.onQuantityChanged, this.updatedQuantity, super.key});

  @override
  _QuantitySelectorState createState() => _QuantitySelectorState();
}

class _QuantitySelectorState extends State<QuantitySelector> {
  late int quantity;

  @override
  void initState() {
    super.initState();
    quantity = widget.updatedQuantity ?? 0;
  }

  void increaseQuantity() {
    setState(() {
      quantity++;
      widget.onQuantityChanged(quantity);
    });
  }

  void decreaseQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
        widget.onQuantityChanged(quantity);
      });
    }
  }

  @override
  void didUpdateWidget(covariant QuantitySelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.updatedQuantity == 1 && oldWidget.updatedQuantity != 1) {
      setState(() {
        quantity = widget.updatedQuantity ?? 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (quantity == 0) {
      return IconButton(
        icon: Icon(Icons.add, size: 24),
        onPressed: () {
          setState(() {
            quantity = 1;
            widget.onQuantityChanged(quantity);
          });
        },
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(Icons.remove, size: 20),
          onPressed: decreaseQuantity,
        ),
        Text('$quantity',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black)),
        IconButton(
          icon: Icon(Icons.add, size: 20),
          onPressed: increaseQuantity,
        ),
      ],
    );
  }
}

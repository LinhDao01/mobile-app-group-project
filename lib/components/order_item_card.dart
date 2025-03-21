import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/order.dart';

class OrderItemCard extends StatelessWidget {
  final OrderDish order;

  const OrderItemCard(this.order, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(10)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$${order.total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                Text(
                  DateFormat('dd/MM/yyyy HH:mm').format(order.dateTime),
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: order.dishes.isEmpty
                ? const Text("No items found", textAlign: TextAlign.center)
                : Table(
                    border: TableBorder.all(color: Colors.grey.shade300),
                    columnWidths: const {
                      0: FlexColumnWidth(3),
                      1: FixedColumnWidth(40),
                      2: FixedColumnWidth(60),
                      3: FixedColumnWidth(80),
                    },
                    children: [
                      TableRow(
                        decoration: BoxDecoration(color: Colors.grey.shade100),
                        children: [
                          _tableHeader('Tên sản phẩm'),
                          _tableHeader('SL'),
                          _tableHeader('Giá'),
                          _tableHeader('Tổng'),
                        ],
                      ),
                      ...order.dishes.map((prod) => TableRow(
                            children: [
                              _tableCell(prod.name),
                              _tableCell(prod.quantity.toString(),
                                  center: true),
                              _tableCell('\$${prod.price}'),
                              _tableCell('\$${prod.quantity * prod.price}'),
                            ],
                          )),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _tableHeader(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _tableCell(String text, {bool center = false}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14),
        textAlign: center ? TextAlign.center : TextAlign.left,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

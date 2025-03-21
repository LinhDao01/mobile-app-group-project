import 'cart_item.dart';

class OrderDish {
  final String? id;
  final int total;
  final List<CartItem> dishes;
  final DateTime dateTime;

  int get dishCount {
    return dishes.length;
  }

  OrderDish({
    this.id,
    required this.total,
    required this.dishes,
    DateTime? dateTime,
  }) : dateTime = dateTime ?? DateTime.now();

  OrderDish copyWith({
    String? newId,
    double? newTotal,
    List<CartItem>? dishes,
    DateTime? newDateTime,
  }) {
    return OrderDish(
      id: id ?? this.id,
      total: total ?? this.total,
      dishes: dishes ?? this.dishes,
      dateTime: dateTime ?? this.dateTime,
    );
  }

  factory OrderDish.fromJson(Map<String, dynamic> json) {
    return OrderDish(
      id: json['id'],
      total: json['total'] as int,
      dateTime: DateTime.parse(json['dateTime']) ,
      dishes: (json['dishes'] as List<dynamic>)
          .map((item) => CartItem.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

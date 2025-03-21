class CartItem {
  final String? id;
  final String dishId;
  final String userId;
  final String name;
  final String imageUrl;
  final int quantity;
  final int price;

  CartItem({
    this.id,
    required this.dishId,
    required this.userId,
    required this.name,
    required this.imageUrl,
    required this.quantity,
    required this.price,
  });

  CartItem copyWith(
      {String? id,
      String? dishId,
      String? userId,
      String? name,
      String? imageUrl,
      int? quantity,
      int? price}) {
    return CartItem(
      id: id ?? this.id,
      dishId: dishId ?? this.dishId,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dishId': dishId,
      'userId': userId,
      'name': name,
      'imageUrl': imageUrl,
      'quantity': quantity,
      'price': price,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] ?? '',
      dishId: json['dishId'] ?? '',
      userId: json['userId'] ?? '',
      name: json['name'] ?? 'unknown',
      imageUrl: json['imageUrl'] ?? '',
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      price: (json['price'] as num?)?.toInt() ?? 0,
    );
  }
}

class Dish {
  final String? id;
  final String name;
  final String description;
  final int price;
  final String imageUrl;
  final FoodCategory category;

  Dish({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
  });

  Dish copyWith({
    String? id,
    String? name,
    String? description,
    int? price,
    String? imageUrl,
    FoodCategory? category,
  }) {
    return Dish(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'category': category.name,
    };
  }

  factory Dish.fromJson(Map<String, dynamic> json) {
    return Dish(
      id: json['id'] ?? '',
      name: json['name'] ?? 'No title',
      description: json['description'] ?? '',
      price: (json['price']).toInt() ?? 0,
      imageUrl: json['imageUrl'] ?? '',
      category: foodCategoryFromString(json['category'] ?? ''),
    );
  }
  @override
  String toString() {
    return 'Dish(id: $id, name: $name, description: $description, price: $price, imageUrl: $imageUrl, category: $category)';
  }
}

enum FoodCategory {
  dry("Món khô"),
  soup("Món nước"),
  drink("Đồ uống");

  final String vietnamese;
  const FoodCategory(this.vietnamese);
}

FoodCategory foodCategoryFromString(String value) {
  return FoodCategory.values.firstWhere(
    (e) => e.vietnamese == value,
    orElse: () => FoodCategory.dry,
  );
}

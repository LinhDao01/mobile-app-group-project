import 'package:ct312h_project/components/dish_tile.dart';
import 'package:flutter/material.dart';
import 'dishes.dart';
import '../services/carts_service.dart';
import '../services/pocketbase_client.dart';

class Menu with ChangeNotifier {
  List<Dish> _dishes = [
    // Dish(
    //   id: '1',
    //   name: 'Phở',
    //   description:
    //       'Nước dùng trong, ngọt thanh từ xương bò, không bột ngọt. Bánh phở mềm dai, thịt bò tươi chọn lọc. Thêm chút tương ớt công thức riêng để trọn vị!',
    //   price: 50000,
    //   imageUrl: 'assets/dishes/Pho.jpg',
    //   category: FoodCategory.soup,
    // ),
    // Dish(
    //   id: '2',
    //   name: 'Cơm tấm',
    //   description: 'description',
    //   price: 40000,
    //   imageUrl: 'assets/dishes/ComTam.jpg',
    //   category: FoodCategory.dry,
    // ),
    // Dish(
    //   id: '3',
    //   name: 'Bánh xèo',
    //   description: 'description',
    //   price: 35000,
    //   imageUrl: 'assets/dishes/BanhXeo.jpg',
    //   category: FoodCategory.dry,
    // ),
    // Dish(
    //   id: '4',
    //   name: 'Đen đá',
    //   description: 'description',
    //   price: 20000,
    //   imageUrl: 'assets/dishes/CaPhe.jpg',
    //   category: FoodCategory.drink,
    // ),
    // Dish(
    //   id: '5',
    //   name: 'Cà phê sữa',
    //   description: 'description',
    //   price: 25000,
    //   imageUrl: 'assets/dishes/CaPheSua.jpg',
    //   category: FoodCategory.drink,
    // ),
    // Dish(
    //   id: 'vg14r71yg6yf988',
    //   name: 'Trà tắc',
    //   description: 'description',
    //   price: 15000,
    //   imageUrl: 'assets/dishes/TraTac.png',
    //   category: FoodCategory.drink,
    // ),
    // Dish(
    //   id: '7',
    //   name: 'Bún bò huế',
    //   description:
    //       'Nước lèo ninh từ xương bò, hòa quyện mắm ruốc Huế, sả thơm lừng. Đầy đủ bò bắp, giò heo, chả cua nhà làm. Mức cay tùy chỉnh theo khẩu vị!',
    //   price: 45000,
    //   imageUrl: 'assets/dishes/BunBoHue.jpg',
    //   category: FoodCategory.soup,
    // ),
    // Dish(
    //   id: '8',
    //   name: 'Bún cá lóc',
    //   description:
    //       'Cá lóc đồng tươi, lọc thịt thủ công, nước dùng trong, thanh mát với nghệ vàng. Ăn kèm rau sống, chấm mắm me công thức riêng – chua, ngọt, cay, mặn tròn vị!',
    //   price: 45000,
    //   imageUrl: 'assets/dishes/BunCaLoc.jpg',
    //   category: FoodCategory.soup,
    // ),
  ];

  Menu() {
    loadDishes();
  }

  int get dishCount {
    return _dishes.length;
  }

  Future<void> loadDishes() async {
    try {
      final pb = await getPocketbaseInstance();
      final dishesModels = await pb.collection('dishes').getFullList();

      _dishes = dishesModels.map((dishModel) {
        final dishJson = {
          ...dishModel.toJson(),
          'imageUrl': CartsService()
              .getDishImageUrl(dishModel.id, dishModel.data['image']),
        };
        return Dish.fromJson(dishJson);
      }).toList();
      for (var item in _dishes) {
        print(item);
      }
      notifyListeners();
    } catch (e) {
      print("Error loading dishes: $e");
    }
  }

  List<Dish> get dishes {
    return [..._dishes];
  }

  Dish? getDishById(String id) {
    try {
      return _dishes.firstWhere((dish) => dish.id == id);
    } catch (error) {
      return null;
    }
  }

  List<Dish> _getDishesByCategory(FoodCategory category, List<Dish> menu) {
    return menu.where((dish) => dish.category == category).toList();
  }

  List<Widget> buildFoodCategoryList(List<Dish> menu) {
    return FoodCategory.values.map((category) {
      List<Dish> categoryDishes = _getDishesByCategory(category, menu);

      return ListView.builder(
        itemCount: categoryDishes.length,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final dish = categoryDishes[index];
          return DishTile(
            dish: dish,
          );
        },
      );
    }).toList();
  }
}

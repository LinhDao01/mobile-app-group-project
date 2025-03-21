import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/app_drawer.dart';
import '../components/sliver_appbar.dart';
import '../components/tab_bar.dart';
import '../models/dishes.dart';
import '../models/menu.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static const routeName = '/home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(vsync: this, length: FoodCategory.values.length);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: MyDrawer(),
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            MySliverAppBar(
              tab_bar: MyTabBar(tabController: _tabController),
              child: Image.asset('assets/appbar.jpg'),
              title: Text('Food Delivery App'),
            ),
          ],
          body: Consumer<Menu>(
            builder: (context, menu, child) => TabBarView(
              controller: _tabController,
              children: menu.buildFoodCategoryList(menu.dishes),
            ),
          ),
        ),
      ),
    );
  }
}

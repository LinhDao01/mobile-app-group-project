// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/dishes.dart';

class MyTabBar extends StatelessWidget {
  final TabController tabController;

  const MyTabBar({
    super.key,
    required this.tabController,
  });

  List<Tab> _buildCategoryTabs() {
    return FoodCategory.values.map((category) {
      return Tab(
        text: category.vietnamese,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TabBar(
        controller: tabController,
        labelColor: Theme.of(context).colorScheme.primary,
        unselectedLabelColor: Colors.black45,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(width: 2.0, color: Colors.orangeAccent),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        tabs: _buildCategoryTabs(),
        labelPadding: EdgeInsets.all(0),
        labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }
}

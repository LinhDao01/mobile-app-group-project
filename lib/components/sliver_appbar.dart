import 'package:flutter/material.dart';

class MySliverAppBar extends StatelessWidget {
  final Widget child;
  final Widget? tab_bar;
  final Widget title;

  const MySliverAppBar({
    super.key,
    required this.child,
    this.tab_bar,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300,
      collapsedHeight: 80,
      pinned: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.shopping_cart),
          onPressed: () {
            Navigator.pushNamed(context, '/cart');
          },
        ),
      ],
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      title: title,
      flexibleSpace: SafeArea(
        child: FlexibleSpaceBar(
          title: tab_bar != null
              ? Container(
                  color: Colors.white,
                  height: 32.0,
                  width: double.infinity,
                  child: tab_bar,
                )
              : null,
          titlePadding: EdgeInsets.only(left: 0, right: 0, top: 0),
          collapseMode: CollapseMode.pin,
          background: Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                top: 57,
                bottom: 0,
                left: 0,
                right: 0,
                child: ClipRect(
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: child,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

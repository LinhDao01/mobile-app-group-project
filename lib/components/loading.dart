import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Loading extends StatelessWidget {
  final double size;
  final Color color;

  const Loading({
    super.key,
    this.size = 50.0,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return LoadingAnimationWidget.staggeredDotsWave(
      color: color,
      size: size,
    );
  }
}

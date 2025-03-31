import 'package:flutter/material.dart';

class ColoredBottomBar extends StatelessWidget {
  final Color barColor;
  final double barHeight;

  const ColoredBottomBar({
    super.key,
    this.barColor =  const Color.fromRGBO(105, 240, 174, 1),
    this.barHeight = 26.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: barHeight,
      width: double.infinity,
      color: barColor,
    );
  }
}
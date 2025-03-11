import 'package:flutter/material.dart';

class TopTitle extends StatelessWidget {
  final String title;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry padding;
  final AlignmentGeometry alignment;

  const TopTitle({
    super.key,
    this.title = 'TO DO',
    this.textStyle,
    this.padding = const EdgeInsets.all(8),
    this.alignment = Alignment.centerLeft,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Padding(
        padding: padding,
        child: Text(
          title,
          style: textStyle ?? const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
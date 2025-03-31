
import 'package:flutter/material.dart';

class PersonPainter extends CustomPainter {
  final Color color;

  PersonPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(size.width / 2, size.height / 4), size.width / 3, paint);
    canvas.drawRect(Rect.fromCenter(center: Offset(size.width / 2, size.height / 2 + 10), width: size.width / 2, height: size.height / 2), paint);
    canvas.drawRect(Rect.fromLTWH(size.width / 4, size.height, size.width / 6, size.height / 3), paint);
    canvas.drawRect(Rect.fromLTWH(size.width / 2 + size.width / 6, size.height, size.width / 6, size.height / 3), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
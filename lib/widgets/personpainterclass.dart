import 'package:flutter/material.dart';

// Custom painter for the person illustrations
class PersonPainter extends CustomPainter {
  final Color color;

  PersonPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Head
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.2),
      size.width * 0.15,
      paint,
    );

    // Body
    final Path path = Path()
      ..moveTo(size.width * 0.4, size.height * 0.3)
      ..lineTo(size.width * 0.3, size.height * 0.8)
      ..lineTo(size.width * 0.7, size.height * 0.8)
      ..lineTo(size.width * 0.6, size.height * 0.3)
      ..close();

    canvas.drawPath(path, paint);

    // Arms
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.2,
        size.height * 0.4,
        size.width * 0.2,
        size.height * 0.1,
      ),
      paint,
    );

    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.6,
        size.height * 0.4,
        size.width * 0.2,
        size.height * 0.1,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
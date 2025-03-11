import 'package:flutter/material.dart';

class TodoTileHeader extends StatelessWidget {
  final String date;
  final VoidCallback onViewAllPressed;

  const TodoTileHeader({
    super.key,
    required this.date,
    required this.onViewAllPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'TODAY',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(date),
            ),
            TextButton(
              onPressed: onViewAllPressed,
              child: const Text('View All Tasks'),
            ),
          ],
        ),
      ],
    );
  }
}
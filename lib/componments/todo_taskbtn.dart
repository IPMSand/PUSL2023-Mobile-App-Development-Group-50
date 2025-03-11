import 'package:flutter/material.dart';

class TodoCreateButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;

  const TodoCreateButton({
    super.key,
    required this.onPressed,
    this.icon = Icons.add,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Icon(icon),
    );
  }
}
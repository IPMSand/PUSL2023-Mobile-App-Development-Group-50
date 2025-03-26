import 'package:flutter/material.dart';

Widget buildFormField({
  required String label,
  required TextEditingController controller,
  bool isPassword = false,
  TextInputType keyboardType = TextInputType.text,
  Widget? suffix,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      const SizedBox(height: 8),
      TextField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: '',
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 5,
          ),
          suffixIcon: suffix,
        ),
      ),
      const SizedBox(height: 5),
    ],
  );
}
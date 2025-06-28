import 'package:flutter/material.dart';

InputDecoration customInputDecoration({
  required String hintText,
  required Icon prefixIcon,
  Widget? suffixIcon,
}) {
  return InputDecoration(
    contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
    hintText: hintText,
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Color(0xFF4A90E2)),
    ),
  );
}

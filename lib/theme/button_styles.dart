import 'package:flutter/material.dart';

ButtonStyle primaryButtonStyle() {
  return ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF4A90E2),
    padding: const EdgeInsets.symmetric(vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  );
}

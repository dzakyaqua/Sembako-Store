import 'package:flutter/material.dart';

BoxDecoration formContainerDecoration() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        spreadRadius: 3,
        blurRadius: 10,
        offset: Offset(0, 5),
      ),
    ],
  );
}

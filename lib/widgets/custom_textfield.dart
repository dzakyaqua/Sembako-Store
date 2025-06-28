import 'package:flutter/material.dart';
import '../theme/input_decoration.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Icon prefixIcon;
  final bool obscureText;
  final VoidCallback? toggleVisibility;
  final TextInputType keyboardType;
  final void Function(String)? onSubmitted;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.obscureText = false,
    this.toggleVisibility,
    this.keyboardType = TextInputType.text,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      onSubmitted: onSubmitted,
      decoration: customInputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: toggleVisibility != null
            ? IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: toggleVisibility,
              )
            : null,
      ),
    );
  }
}

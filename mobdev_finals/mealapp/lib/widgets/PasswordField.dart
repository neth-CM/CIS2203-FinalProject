import 'package:flutter/material.dart';

class PasswordField extends StatelessWidget {
  final String labelText;
  final bool obscureText;
  final VoidCallback onTap;
  final TextEditingController controller;

  const PasswordField({
    super.key,
    required this.labelText,
    required this.obscureText,
    required this.onTap,
    required this.controller
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.text,
      obscureText: obscureText,
      cursorColor: const Color.fromRGBO(255, 255, 255, 80),
      style: const TextStyle(color: Color.fromRGBO(255, 255, 255, 80)),
      decoration: InputDecoration(
        prefixIcon: Container(
          padding: const EdgeInsets.only(left: 20.0, right: 15.0),
          child: const Icon(Icons.lock, color: Color.fromRGBO(156, 100, 54, 1)),
        ),
        suffixIcon: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.only(right: 20.0),
            child: Icon(obscureText ? Icons.visibility_off : Icons.visibility, color: const Color.fromRGBO(156, 100, 54, 1)),
          ),
        ),
        labelText: labelText,
        labelStyle: const TextStyle(color: Color.fromRGBO(255, 255, 255, 150)),
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30.0))
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
          borderSide: BorderSide(color: Color.fromRGBO(156, 100, 54, 1))
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
          borderSide: BorderSide(color: Color.fromRGBO(156, 100, 54, 1))
        )
      ),
    );
  }
}

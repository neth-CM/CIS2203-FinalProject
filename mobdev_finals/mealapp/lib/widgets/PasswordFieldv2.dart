import 'package:flutter/material.dart';

class PasswordFieldv2 extends StatelessWidget {
  final bool obscureText;
  final VoidCallback onTap;
  final TextEditingController controller;
  final Color borderColorChoice;
  final Color backgroundColorChoice;

  const PasswordFieldv2({
    super.key,
    required this.obscureText,
    required this.onTap,
    required this.controller,
    required this.borderColorChoice,
    required this.backgroundColorChoice
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.text,
      obscureText: obscureText,
      cursorColor: const Color.fromRGBO(255, 255, 255, 80),
      style: const TextStyle(color: Color.fromRGBO(255, 255, 255, 80), fontSize: 17),
      decoration: InputDecoration(
        suffixIcon: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.only(right: 20.0),
            child: Icon(
              obscureText ? Icons.visibility_off : Icons.visibility, 
              color: Color(0xFFD9D9D9),
              size: 30,
            ),
          ),
        ),
        filled: true,
        fillColor: backgroundColorChoice,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(color: borderColorChoice, width: 2)
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(color: borderColorChoice, width: 2)
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(color: borderColorChoice, width: 2)
        )
      )
    );
  }
}

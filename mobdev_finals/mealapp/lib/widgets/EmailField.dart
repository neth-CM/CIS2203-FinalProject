import 'package:flutter/material.dart';

class EmailField extends StatelessWidget {
  final String labelText;
  final IconData iconData;
  final TextInputType textInputType;
  final TextEditingController controller;

  const EmailField({
    super.key,
    required this.labelText,
    required this.iconData,
    required this.textInputType,
    required this.controller
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: textInputType,
      cursorColor: const Color.fromRGBO(255, 255, 255, 80),
      style: const TextStyle(
        color: Color.fromRGBO(255, 255, 255, 80), 
      ),
      decoration: InputDecoration(
        prefixIcon: Container(
          padding: const EdgeInsets.only(left: 20.0, right: 15.0),
          child: Icon(iconData, color: const Color.fromRGBO(156, 100, 54, 1)),
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
      )
    );
  }
}

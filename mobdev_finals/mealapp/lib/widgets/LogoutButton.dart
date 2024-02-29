import 'package:flutter/material.dart';

class LogoutButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  LogoutButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        fixedSize: Size(double.maxFinite, 60),
        backgroundColor: Colors.red[400],
        shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0))
      ),
      child: Text(text, style: const TextStyle(
          fontFamily: 'LexendDeca',
          fontSize: 25.0,
          color: Colors.white
      ),),
    );
  }
}

import 'package:flutter/material.dart';

class DisabledPrimaryButton extends StatelessWidget {
  final String text;

  DisabledPrimaryButton(
      {required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: null,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) => Color.fromRGBO(105, 42, 8, 1)
          ),
          padding: MaterialStateProperty.resolveWith<EdgeInsetsGeometry>(
            (Set<MaterialState> states) => EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0)
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white60),
            )
          ],
        ));
  }
}

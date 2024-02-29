import 'package:flutter/material.dart';

class GoogleButton extends StatelessWidget {
  final VoidCallback onPressed;

  GoogleButton(
      {required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 210,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0)),
            backgroundColor: Colors.transparent,
            side: const BorderSide(color: Color.fromRGBO(156, 100, 54, 1))
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/google_logo.png', width: 30.0, height: 30.0,),
            const SizedBox(width: 15.0,),
            const Text(
              "Google",
              style: TextStyle(
                fontSize: 24.0, 
                fontFamily: 'LexendDeca',
                fontWeight: FontWeight.w300,
                color: Color.fromRGBO(101, 94, 92, 1)
              ),
            )
          ],
        )),
    );
  }
}

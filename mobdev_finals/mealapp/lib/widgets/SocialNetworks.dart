import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GoogleContainer extends StatefulWidget {
  final String displayName;
  final bool linked;
  final VoidCallback onTap;
  final String buttonDescription;

  const GoogleContainer({
    required this.displayName, 
    required this.linked, 
    required this.onTap, 
    required this.buttonDescription, 
    Key? key
  }) : super(key: key);

  @override
  State<GoogleContainer> createState() => _GoogleContainerState();
}

class _GoogleContainerState extends State<GoogleContainer> {
  final currentUser = FirebaseAuth.instance.currentUser!;
    
  @override
  Widget build(BuildContext context) {
    return Container(        
        margin: const EdgeInsets.symmetric(horizontal: 27, vertical: 25),
        padding: const EdgeInsets.only(left: 20, right: 20, top: 25, bottom: 35),
        decoration: const BoxDecoration(
          color: Color(0xFF2D2013),
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Social Networks", style: TextStyle(
              color: Color(0xFFFFAE50), 
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),),
            const SizedBox(height: 10),
            const Divider(color: Color(0xFF9C6436), thickness: 1,),
            const SizedBox(height: 20),
            Row(
              children: [
                Image.asset('assets/images/google_logo_white.png', width: 40, height: 40),
                Container(
                  margin: const EdgeInsets.only(left: 15),
                  width: 145,
                  child: Text(
                    widget.displayName,
                    style: const TextStyle(color: Color(0xFFACACAC), fontSize: 18,), 
                ),),
                Expanded(child: GestureDetector(
                  onTap: widget.onTap,
                  child: Text(widget.buttonDescription, textAlign: TextAlign.right, style: const TextStyle(
                    color: Color(0xFFFFAE50), 
                    fontFamily: 'Poppins',
                    fontSize: 22,
                  ),),
                ))
              ],
            )
          ],
        ),
    );
  }
}
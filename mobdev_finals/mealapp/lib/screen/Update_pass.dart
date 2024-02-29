import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mealapp/widgets/PasswordFieldv2.dart';

class ChangePasswordDialog extends StatefulWidget {
  static const String routeName = "/update_pass";
  const ChangePasswordDialog({super.key});

  @override
  State<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  TextEditingController currentPassController = TextEditingController();
  TextEditingController newPassController = TextEditingController();
  TextEditingController retypePassController = TextEditingController();
  bool obscureText1 = true;
  bool obscureText2 = true;
  bool obscureText3 = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      backgroundColor: const Color(0xFF231815),
        appBar: AppBar(
          centerTitle: true,
          toolbarHeight: 70,
          backgroundColor: const Color(0xFF231815),
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text("Set New Password", style: TextStyle(
            fontFamily: 'LexendDeca',
            fontWeight: FontWeight.w700,
            fontSize: 27, 
            color: Color.fromRGBO(255, 174, 80, 1),
          ),),
        ),
        body: SingleChildScrollView(
          child: Container(
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
            child: Column(
              children: [
                Container(  ////////////// CURRENT PASSWORD
                  width: double.maxFinite,
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: const Text("Current Password", style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    color: Color(0xFFD9D9D9)
                  ),),
                ),
                PasswordFieldv2(
                  obscureText: obscureText1, onTap: (){
                    setPasswordVisibility(1);
                  }, 
                  controller: currentPassController, 
                  borderColorChoice: const Color(0xFF59413B), 
                  backgroundColorChoice: const Color(0xFF2D2013)
                ),
                Container(  ////////////// NEW PASSWORD
                  width: double.maxFinite,
                  margin: const EdgeInsets.only(bottom: 5, top: 25),
                  child: const Text("New Password", style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    color: Color(0xFFD9D9D9)
                  ),),
                ),
                PasswordFieldv2(
                  obscureText: obscureText2, onTap: (){
                    setPasswordVisibility(2);
                  }, 
                  controller: newPassController, 
                  borderColorChoice: const Color(0xFF59413B), 
                  backgroundColorChoice: const Color(0xFF2D2013)
                ),
                Container(  ////////////// RETYPE NEW PASSWORD
                  width: double.maxFinite,
                  margin: const EdgeInsets.only(bottom: 5, top: 25),
                  child: const Text("Repeat New Password", style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    color: Color(0xFFD9D9D9)
                  ),),
                ),
                PasswordFieldv2(
                  obscureText: obscureText3, onTap: (){
                    setPasswordVisibility(3);
                  }, 
                  controller: retypePassController, 
                  borderColorChoice: const Color(0xFF59413B), 
                  backgroundColorChoice: const Color(0xFF2D2013)
                ),
                const SizedBox(height: 50,),
                ElevatedButton(  ////////////// UPDATE BUTTON
                  onPressed: (){
                    changePassword(
                      context, currentPassController.value.text, 
                      newPassController.value.text, 
                      retypePassController.value.text,
                  );},
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 35, vertical: 19),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100)),
                      backgroundColor: const Color(0xFFE4814A)
                  ),
                  child: const Text("Update Password", style: TextStyle(
                    fontSize: 20, 
                    fontFamily: 'LexendDeca', 
                    color: Colors.white
                  ),)
                ),
                const SizedBox(height: 15,),
                GestureDetector(
                  onTap: (){
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "Cancel", 
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      color: Color(0xFFACACAC)
                    ),
                  )
                )
              ]
            ),
          ),
        )
    ),);
  }


  void setPasswordVisibility(int fieldNum) {
    switch (fieldNum) {
      case 1:
        setState(() {
          obscureText1 = !obscureText1;
        });
        break;
      case 2:
        setState(() {
          obscureText2 = !obscureText2;
        });
        break;
      case 3:
        setState(() {
          obscureText3 = !obscureText3;
        });
        break;
      default:
        print("test");
    }
  }

  changePassword(context, String currentPass, String newPass, String retypePass) async {
    bool isValid = true;

    if(currentPass == '' || newPass == '' || retypePass == ''){
      errorDialog(context, "Please fill all fields.");
      isValid = false;
    }

    if(isValid && newPass != retypePass){
      errorDialog(context, "Password confirmation do not match.");
      isValid = false;
    }

    if(isValid){
      var currentUser = FirebaseAuth.instance.currentUser!;
      final credential = EmailAuthProvider.credential(
        email: currentUser.email!, password: currentPass);

      await currentUser.reauthenticateWithCredential(credential).then((value) async {

          await currentUser.updatePassword(newPass).then((_) {

            showDialog(context: context, builder: (BuildContext context){
              Future.delayed(const Duration(seconds: 2), () {
                Navigator.of(context).pop(true);
                Navigator.of(context).pop(true);
              });
              return AlertDialog(
                backgroundColor: Colors.greenAccent[700],
                title: const Text(
                  "Password updated successfully.", 
                  textAlign: TextAlign.center, 
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "LexendDeca",
                    fontSize: 20, 
                    fontWeight: FontWeight.w700
                )),
              );
            });

          }).catchError((error) {
            switch (error.code) {
              case "weak-password":
                errorDialog(context, "Password provided is too weak. Password should be atleast 6 characters.");
                break;
              default:
                errorDialog(context, error.message);
            }
          });

      }).catchError((err) {
        switch (err.code) {
          case "too-many-requests":
            errorDialog(context, "Too many attempts. Please try again later.");
            break;
          case "invalid-credential":
            errorDialog(context, "Password is incorrect.");
            break;
          default:
            errorDialog(context, err.message);
        }
      });
    }
  }

  void errorDialog(context, errorMessage){
    showDialog(context: context, builder: (BuildContext context){
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.of(context).pop(true);
      });
      return AlertDialog(
        backgroundColor: Colors.deepOrangeAccent[700],
        title: const Center(
          child: Text("Error", style: TextStyle(
            color: Colors.white,
            fontFamily: "LexendDeca",
            fontWeight: FontWeight.w700,
          ),),
        ),
        content: Text(
          errorMessage, 
          textAlign: TextAlign.center, 
          style: const TextStyle(color: Colors.white,)
        ),
      );
    });
  }

}
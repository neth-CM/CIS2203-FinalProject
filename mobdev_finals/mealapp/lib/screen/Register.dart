// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mealapp/config/models/storage_item.dart';
import 'package:mealapp/screen/Home.dart';
import 'package:mealapp/screen/Register_Link.dart';
import 'package:mealapp/services/storage_service.dart';
import 'package:mealapp/widgets/EmailField.dart';
import 'package:mealapp/widgets/GoogleButton.dart';
import 'package:mealapp/widgets/PasswordField.dart';
import 'package:mealapp/widgets/PrimaryButton.dart';
import 'package:mealapp/screen/Login.dart';

class Register extends StatefulWidget {
  static const String routeName = "/register";
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  StorageService storageService = StorageService();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height - 100,
                padding: const EdgeInsets.only(bottom: 45),
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(63, 35, 10, 1),
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40)),
                ),
                child: Container(
                  padding: const EdgeInsets.only(bottom: 45),
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(45, 32, 19, 1),
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40)),
                  ),
                  child: Container(
                    padding: const EdgeInsets.only(top: 50),
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(35, 24, 21, 1),
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40)),
                    ),
                    child: Column(
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "THE MEAL",
                              style: TextStyle(
                                  fontSize: 47,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w700,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Color.fromRGBO(255, 174, 80, 1),
                                  color: Color.fromRGBO(255, 174, 80, 1)), 
                            ),
                            Padding(padding: EdgeInsets.all(5)),
                            Icon(Icons.fastfood,
                              size: 70,
                              color: Color.fromRGBO(255, 174, 80, 1)
                            )
                          ],
                        ),
                        
                        Container(
                          padding: const EdgeInsets.only(left: 30, top: 50, right: 30),
                          child: Form(
                            child: Column(
                              children: [
                                GoogleButton(onPressed: () => loginWithGoogle(),), 
                                const SizedBox(
                                  height: 20.0,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Container(
                                          margin: const EdgeInsets.only(right: 13.0),
                                          child: const Divider(
                                            color: Color.fromRGBO(156, 100, 54, 1),
                                            height: 0.2,
                                          )),
                                    ),
                                    const Text("or", style: TextStyle(
                                      color: Color.fromRGBO(101, 94, 92, 1),
                                      fontSize: 22,
                                    ),),
                                    Expanded(
                                      child: Container(
                                          margin: const EdgeInsets.only(left: 13.0),
                                          child: const Divider(
                                            color: Color.fromRGBO(156, 100, 54, 1),
                                            height: 0.2,
                                          )),
                                    ),
                                ]),
                                const SizedBox(
                                  height: 20.0,
                                ),
                                EmailField(
                                  labelText: "Email Address", 
                                  iconData: Icons.email, 
                                  textInputType: TextInputType.emailAddress, 
                                  controller: emailController),
                                const SizedBox(
                                  height: 15.0,
                                ),
                                PasswordField(
                                    labelText: "Password",
                                    obscureText: obscureText,
                                    onTap: setPasswordVisibility,
                                    controller: passController),
                                const SizedBox(
                                  height: 25.0,
                                ),
                                PrimaryButton(
                                  text: "Create Account", onPressed: () {
                                    signUp(context, emailController.value.text, passController.value.text);
                                }),
                                const SizedBox(
                                  height: 40.0,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: (){
                                        Navigator.pushReplacementNamed(context, Login.routeName);
                                      },
                                      child: const Text(
                                        "Have an account? Log in", 
                                        style: TextStyle(color: Color.fromRGBO(248, 170, 79, 1)),
                                      )
                                    )
                                ])
                              ],
                            ),
                          )
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }


  void setPasswordVisibility() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  signUp(context, String email, String password) async {
    bool isValid = true;
    
    if(email == '' || password == '' ){
      errorDialog(context, "Please fill all fields.");
      isValid = false;
    }

    if(isValid){
      try {
        UserCredential credentials = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        var item = StorageItem("uid", credentials.user?.uid ?? "");
        await storageService.saveData(item);

        Navigator.pushReplacementNamed(context, Home.routeName);
        
      } on FirebaseAuthException catch(e) {
        switch (e.code) {
          case "too-many-requests":
            errorDialog(context, "Too many attempts. Please try again later.");
            break;
          case "invalid-email":
            errorDialog(context, "Invalid account format.");
            break;
          case "weak-password":
            errorDialog(context, "The password provided is too weak. Password should be atleast 6 characters.");
            break;
          case "email-already-in-use":
            errorDialog(context, "The account already exists for that email.");
            break;
          default:
            errorDialog(context, e.message);
        }
      } catch(e){
        print(e);
      }
    }
  }

  loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if(googleUser == null) {
        return ;
      }

      final GoogleSignInAuthentication? googleAuth = 
        await googleUser?.authentication;
      
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken, 
        idToken: googleAuth?.idToken
      );

      UserCredential? userCredential = 
        await FirebaseAuth.instance.signInWithCredential(credential);

      var item = StorageItem("uid", userCredential.user?.uid ?? "");
      await storageService.saveData(item);

      if (userCredential.additionalUserInfo!.isNewUser) {
        // User is signing in for the first time
        print('User is signing in for the first time with Google');
        Navigator.pushReplacementNamed(context, RegistrationLink.routeName);

      } else {
        // User has signed in before
        print('User has signed in before with Google');
        Navigator.pushReplacementNamed(context, Home.routeName);
      }
      
    } catch (e) {
      print(e);
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
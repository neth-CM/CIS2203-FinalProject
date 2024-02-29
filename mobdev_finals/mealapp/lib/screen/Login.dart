import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mealapp/config/models/storage_item.dart';
import 'package:mealapp/screen/Register_Link.dart';
import 'package:mealapp/services/storage_service.dart';
import 'package:mealapp/widgets/EmailField.dart';
import 'package:mealapp/widgets/GoogleButton.dart';
import 'package:mealapp/widgets/PasswordField.dart';
import 'package:mealapp/widgets/PrimaryButton.dart';
import 'package:mealapp/screen/Home.dart';
import 'package:mealapp/screen/Register.dart';

class Login extends StatefulWidget {
  static const String routeName = "/login";
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
                color: const Color.fromRGBO(255, 249, 244, 1),
                height: 180,
                alignment: Alignment.center,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
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
                )
              ),
              Container(
                height: MediaQuery.of(context).size.height - 180,
                padding: const EdgeInsets.only(top:45),
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(63, 35, 10, 1),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
                ),
                child: Container(
                  padding: const EdgeInsets.only(top:45),
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(45, 32, 19, 1),
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
                  ),
                  child: Container(
                    padding: const EdgeInsets.only(top:45, left: 30, right: 30),
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(35, 24, 21, 1),
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
                    ),
                    child: Form(
                      child: Column(
                        children: [
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
                          text: "Login", 
                          onPressed: () {
                            signIn(context, emailController.value.text, passController.value.text);
                          }),
                          const SizedBox(
                            height: 25.0,
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
                          GoogleButton(onPressed: () {loginWithGoogle();}),
                          const SizedBox(
                            height: 40.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: (){
                                  Navigator.pushReplacementNamed(context, Register.routeName);
                                },
                                child: const Text(
                                  "Don't have an account? Sign up", 
                                  style: TextStyle(color: Color.fromRGBO(255, 174, 80, 1)),
                                )
                              )
                            ]),
                        ],
                      ),
                    )
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

  signIn(context, String email, String password) async {
    bool isValid = true;
    
    if(email == '' || password == '' ){
      errorDialog(context, "Please fill all fields.");
      isValid = false;
    }

    if(isValid){
      try {
        UserCredential credentials = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);

        var item = StorageItem("uid", credentials.user?.uid ?? "");
        await storageService.saveData(item);

        Navigator.pushReplacementNamed(context, Home.routeName);

      } on FirebaseAuthException catch(e) {
        var errorMessage;

        switch (e.code) {
          case "invalid-email":
            errorDialog(context, "Invalid account format.");
            break;
          case "invalid-credential":
            errorDialog(context, "Account or password error.");
            break;
          case "too-many-requests":
            errorDialog(context, "Too many attempts. Please try again later.");
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
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mealapp/screen/Home.dart';
import 'package:mealapp/widgets/PasswordFieldv2.dart';

class RegistrationLink extends StatefulWidget {
  static const String routeName = "/registrationlink";
  const RegistrationLink({super.key});

  @override
  State<RegistrationLink> createState() => _RegistrationLinkState();
}

class _RegistrationLinkState extends State<RegistrationLink> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  User? user = FirebaseAuth.instance.currentUser;
  String parsedUser = "";
  TextEditingController passController = TextEditingController();
  bool obscureText = true;

  @override
  void initState() {
    super.initState();
    
    setEmail();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF231815),
        body: SingleChildScrollView(
          child: Container(
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
            child: Column(
              children: [
                const SizedBox(height: 20,),     //////////////// PICTURE
                if(user?.providerData[0].photoURL != null) ...[
                  ClipRRect(                       
                    borderRadius: BorderRadius.circular(200),
                    child: Image.network(
                      currentUser.providerData[0].photoURL!, 
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                ] else ...[
                  ClipRRect(                       
                    borderRadius: BorderRadius.circular(200),
                    child: Image.asset(
                      'assets/images/no_image.jpg', 
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
                const SizedBox(height: 15,),
                Text(                      //////////////// WELCOME TITLE
                  "Welcome ${currentUser.displayName}!",  
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                  fontSize: 24,
                  color: Color(0xFFD9D9D9),
                ),),
                const SizedBox(height: 25,),
                const Text(                      //////////////// EMAIL
                  "Email",  
                  textAlign: TextAlign.center,
                  style: TextStyle( 
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color(0xFFD9D9D9),
                ),),
                const SizedBox(height: 5,),
                Text(                      ///////////////// DISPLAY EMAIL
                  parsedUser,  
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                  fontSize: 20,
                  color: Color(0xFFD9D9D9),
                ),),
                Container(                       //////////////// SET PASSWORD
                  width: double.maxFinite,
                  margin: const EdgeInsets.only(bottom: 5, top: 25),
                  child: const Text("Set a Password", style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    color: Color(0xFFD9D9D9)
                  ),),
                ),
                PasswordFieldv2(
                  obscureText: obscureText, onTap: setPasswordVisibility, 
                  controller: passController, 
                  borderColorChoice: const Color(0xFF59413B), 
                  backgroundColorChoice: const Color(0xFF2D2013)
                ),
                const SizedBox(height: 40,),
                ElevatedButton(                  //////////////// START BUTTON
                  onPressed: () => linkWithEmailAndPass(context, passController.value.text),
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 55, vertical: 13),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100)),
                      backgroundColor: const Color(0xFFE4814A)
                  ),
                  child: const Text("Start Now", style: TextStyle(
                    fontSize: 20, 
                    fontFamily: 'LexendDeca', 
                    color: Colors.white
                  ),)
                ),
              ]
            ),
          ),
        ),
      )
    );
  }

  void setPasswordVisibility() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  Future<void> setEmail() async{
    String googleEmail = currentUser.email!;
    String email = googleEmail.split('@')[0];

    setState(() {
      parsedUser = "${email}@email.com";
    });
  }

  linkWithEmailAndPass(context, String password) async {
    bool isValid = true;
    
    if(password == '' ){
      errorDialog(context, "Please don't leave empty fields.");
      isValid = false;
    }

    if(isValid){
      final emailCredential = 
      EmailAuthProvider.credential(email: parsedUser, password: password);

      try {
        await currentUser.linkWithCredential(emailCredential);

        print('Account successfully linked with an Email provider ');

        showDialog(
          context: context, 
          barrierDismissible: false,
          builder: (BuildContext context){
          return AlertDialog(
            backgroundColor: Colors.greenAccent[700],
            title: const Text(
              "Account successfully set", 
              textAlign: TextAlign.center, 
              style: TextStyle(
                color: Colors.white,
                fontFamily: "LexendDeca",
                fontSize: 20, 
                fontWeight: FontWeight.w700
            )),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.pushReplacementNamed(context, Home.routeName);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF03AF4B)),
                    child: const Text(
                      'Continue', style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 18
                    ),),
                  ),
                ],
              )
            ],
          );
        });
        
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case "provider-already-linked":
            errorDialog(context, "The provider has already been linked to the user.");
            break;
          case "invalid-credential":
            errorDialog(context, "The provider's credential is not valid.");
            break;
          case "credential-already-in-use":
            errorDialog(context, "The account corresponding to the credential already exists, or is already linked to a Firebase User.");
            break;
          default:
            errorDialog(context, e.message);
        }
      }
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
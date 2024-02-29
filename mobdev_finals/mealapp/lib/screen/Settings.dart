import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mealapp/screen/Update_pass.dart';
import 'package:mealapp/services/storage_service.dart';
import 'package:mealapp/widgets/LogoutButton.dart';
import 'package:mealapp/screen/Login.dart';
import 'package:mealapp/widgets/SocialNetworks.dart';

class Settings extends StatefulWidget {
  static const String routeName = "/settings";
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  String displayName = "Link a Google Account";
  bool linked = false;

  @override
  void initState() {
    super.initState();

    checkGoogleLinked();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 70,
          backgroundColor: const Color.fromRGBO(45, 32, 19, 1),
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            "Settings", 
            style: TextStyle(fontSize: 27, color: Color.fromRGBO(255, 174, 80, 1),),
          ),
        ),
        body: Container(
          color: const Color.fromRGBO(228, 129, 74, 1),
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.symmetric(vertical: 30.0),
          child: Column(
            children: [
              Container( /////////////// EMAIL ///////////////
                margin: const EdgeInsets.symmetric(horizontal: 27),
                height: 90,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(right: 17),
                      child: const Icon(Icons.mail, size: 52, color: Color(0xFF2D2013)),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Email",
                          style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF2D2013)), 
                        ),
                        Text(
                          currentUser.email!,
                          style: const TextStyle(color: Color(0xFF2D2013), fontSize: 20,), 
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const Divider(color: Color(0xFF231815), thickness: 1,),

              /////////////// CHANGE PASSWORD ///////////////
              GestureDetector( 
                onTap: (){
                  Navigator.pushNamed(context, ChangePasswordDialog.routeName);
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 27),
                  height: 90,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(right: 17),
                        child: const Icon(Icons.key, size: 52, color: Color(0xFF2D2013)),
                      ),
                      const Text(
                        "Change Password",
                        style: TextStyle(color: Color(0xFF2D2013), fontSize: 20,), 
                      ),
                      Expanded(child: Container(
                        alignment: Alignment.centerRight,
                        child: const Icon(
                          Icons.keyboard_arrow_right_rounded, 
                          size: 52, 
                          color: Color(0xFF2D2013)),
                      ),)
                    ],
                  ),
                ),
              ),
              const Divider(color: Color(0xFF231815), thickness: 1,),
              
              /////////////// GOOGLE PROVIDER ///////////////
              if(linked) ...[
                GoogleContainer(  
                  displayName: displayName, linked: linked, 
                  onTap: unlinkWithGoogle,buttonDescription: "UNLINK"
                ),
              ] else ... [
                GoogleContainer(  
                  displayName: displayName, linked: linked, 
                  onTap: linkWithGoogle, buttonDescription: "LINK"
                ),
              ],

              /////////////// LOG OUT ///////////////
              Container(
                margin: const EdgeInsets.only(left: 25, right: 25, top: 20),
                child: LogoutButton(text: "Logout", onPressed: logout),
              ),
            ],
          ),
        ),
      ),
    );
  }


  checkGoogleLinked() async {
    if(currentUser != null){
      try {
        if (currentUser.providerData.any((userInfo) => userInfo.providerId == 'google.com')) {
          final GoogleSignInAccount? googleUser = 
            await GoogleSignIn().signInSilently();

          if (googleUser != null) {
            setState(() {
              displayName = googleUser.displayName!;
              linked = true;
            });
          } else {
            print('Error fetching Google user information');
          }
        } else {
          print('User is not linked with Google provider');
        }
      } catch (e) {
        print('Error getting Google display name: $e');
      }
    } else {
      print('No user signed in');
    }
  }

  linkWithGoogle() async {
    if (currentUser != null) {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser != null) {

        try {
          final GoogleSignInAuthentication googleAuth = 
            await googleUser.authentication;

          final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );

          await currentUser.linkWithCredential(credential);

          print('Account successfully linked with Google provider ');
          setState(() {
            displayName = googleUser.displayName!;
            linked = true;
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
              errorDialog(context, "Unkown error.");
          }
          await GoogleSignIn().signOut();
        }
      } else {
        errorDialog(context, 'Google sign-in canceled');
      }
    } else {
      errorDialog(context, 'No user signed in');
    }
  }

  unlinkWithGoogle() async {
    if(currentUser != null){
      try {
        await currentUser.unlink('google.com');
        print('Account successfully unlinked from Google provider');
        await GoogleSignIn().signOut();
        setState(() {
          displayName = "Link a Google Account";
          linked = false;
        });
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case "no-such-provider":
            errorDialog(context, "The user isn't linked to the provider or the provider doesn't exist.");
            break;
          default:
            errorDialog(context, "Unkown error.");
        }
      }
    } else {
      errorDialog(context, 'No user signed in');
    }
  }

  void logout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Log out', 
            textAlign: TextAlign.center, 
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          content: const Text(
            'Are you sure you want to log out?',
            textAlign: TextAlign.center
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () { Navigator.of(context).pop(); },
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE0DEDE)),
                  child: const Text('Cancel', style: TextStyle(color: Colors.black),),
                ),
                const SizedBox(width: 15,),
                ElevatedButton(
                  onPressed: () async {
                    StorageService storageService = StorageService();
                    storageService.deleteAllData();

                    await GoogleSignIn().signOut();
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushReplacementNamed(context, Login.routeName);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF9494)),
                  child: const Text('Confirm', style: TextStyle(color: Color(0xFFAC0000)),),
                ),
              ],
            )
          ],
        );
      },
    );
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
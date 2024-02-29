import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mealapp/config/routes.dart';
import 'package:mealapp/config/firebase_options.dart';
import 'package:mealapp/screen/Home.dart';
import 'package:mealapp/screen/Login.dart';
import 'package:mealapp/services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  StorageService storageService = StorageService();
  var item = await storageService.readData("uid");

  if (item != null) {
    runApp(MaterialApp(
      initialRoute: Home.routeName,
      routes: routes,
      theme: ThemeData(fontFamily: 'Montserrat'),
    ));
  } else {
    runApp(MaterialApp(
      initialRoute: Login.routeName,
      routes: routes,
      theme: ThemeData(fontFamily: 'Montserrat'),
    ));
  }
}

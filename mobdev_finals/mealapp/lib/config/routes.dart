import 'package:flutter/material.dart';
import 'package:mealapp/screen/Dashboard.dart';
import 'package:mealapp/screen/Discover.dart';
import 'package:mealapp/screen/Favorites.dart';
import 'package:mealapp/screen/Home.dart';
import 'package:mealapp/screen/Login.dart';
import 'package:mealapp/screen/Register.dart';
import 'package:mealapp/screen/Register_Link.dart';
import 'package:mealapp/screen/Settings.dart';
import 'package:mealapp/screen/Update_pass.dart';

final Map<String, WidgetBuilder> routes = {
  Login.routeName: (BuildContext context) => const Login(),
  Register.routeName: (BuildContext context) => const Register(),
  RegistrationLink.routeName: (BuildContext context) => const RegistrationLink(),
  Home.routeName: (BuildContext context) => const Home(),
  Discover.routeName: (BuildContext context) => const Discover(),
  Dashboard.routeName: (BuildContext context) => const Dashboard(),
  Favorites.routeName: (BuildContext context) => const Favorites(),
  Settings.routeName: (BuildContext context) => const Settings(),
  ChangePasswordDialog.routeName: (BuildContext context) => const ChangePasswordDialog()
};

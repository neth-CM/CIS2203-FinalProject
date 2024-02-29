import 'package:flutter/material.dart';
import 'package:mealapp/screen/Dashboard.dart';
import 'package:mealapp/screen/Discover.dart';
import 'package:mealapp/screen/Favorites.dart';
import 'package:mealapp/screen/Settings.dart';

class Home extends StatefulWidget {
  static const String routeName = "/home";
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
int pageIndex = 1;
final List<Widget> _pages = [const Discover(), const Dashboard(), const Favorites()];
String pageTitle = "Dashboard";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 70,
          backgroundColor: const Color.fromRGBO(45, 32, 19, 1),
          automaticallyImplyLeading: false,
          title: Text(pageTitle, style: const TextStyle(
            fontFamily: 'LexendDeca',
            fontSize: 27, 
            color: Color.fromRGBO(255, 174, 80, 1),
          ),),
          actions: [
            IconButton(
                onPressed: settings, icon: const Icon(Icons.settings, size: 35, color: Color.fromRGBO(255, 174, 80, 1),))
          ],
        ),
        body: _pages[pageIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: pageIndex,
          selectedItemColor: const Color.fromRGBO(255, 174, 80, 1),
          unselectedItemColor: const Color.fromRGBO(172, 172, 172, 1),
          backgroundColor: const Color.fromRGBO(45, 32, 19, 1),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.search), 
              label: "Discover"
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard), 
              label: "Dashboard"
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite), 
              label: "Favorites"
            ),
          ], onTap: (index){
            setState(() {
              pageIndex = index;
              switch (pageIndex) {
                case 0:
                  pageTitle = "Discover";
                  break;
                case 1:
                  pageTitle = "Dashboard";
                  break;
                case 2:
                  pageTitle = "Favorites";
                  break;
                default:
                  pageTitle = "Home";
              }
            });
          },
        ),
      ),
    );
  }

  void settings() {
    Navigator.pushNamed(context, Settings.routeName);
  }
}
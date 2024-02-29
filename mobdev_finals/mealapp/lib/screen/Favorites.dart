import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:mealapp/config/models/FavoriteMeals.dart';

List<FavoriteMeals> meals = [];

class Favorites extends StatefulWidget {
  static const String routeName = "/favorites";
  const Favorites({super.key});

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  bool test = true;

  @override
  void initState() {
    super.initState();

    callFirestore();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          color: const Color.fromRGBO(228, 129, 74, 1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if(meals.isEmpty) ...[
                const Text(
                  "(O_O;)",
                  style: TextStyle(
                    color: Color.fromRGBO(45, 32, 19, 1),
                    fontSize: 45,
                    fontWeight: FontWeight.bold
                  ),
                ),
                Container(
                  width: 230,
                  padding: const EdgeInsets.only(top: 15),
                  child: const Text(
                    "You currently do not have any favorites. Add some from the dashboard",
                    style: TextStyle(
                      color: Color.fromRGBO(45, 32, 19, 1),
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ] else ...[
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => FavoriteDetails(index: index,),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                          padding:
                              const EdgeInsets.only(
                                left: 10, right: 10, top: 10, bottom: 20),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5.0)),
                          child: Column(
                            children: [
                              Image.network(meals[index].imgUrl),
                              const SizedBox(height: 12,),
                              Text(meals[index].name,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18)
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: meals.length,
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }

  Future<List<FavoriteMeals>> callFirestore() async {
    final currentUser = FirebaseAuth.instance.currentUser!;
    String uid = currentUser.uid;

    List<FavoriteMeals> list = [];

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('UserUID')
        .doc(uid)
        .collection('Meal')
        .get();

    list = querySnapshot.docs
        .map((document) => FavoriteMeals.fromJson(document.data()))
        .toList();

    setState(() {
      meals = list;
    });

    return list;
  }

}


////////////////////////////////////////////////////////////////////////////////
/////////////////////////////// MEAL DETAILS ///////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

class FavoriteDetails extends StatefulWidget {
  final int index;
  const FavoriteDetails({required this.index, Key? key}) : super(key: key);

  @override
  State<FavoriteDetails> createState() => _FavoriteDetailsState();
}

class _FavoriteDetailsState extends State<FavoriteDetails> {
  bool isSaved = false;

  @override
  void initState() {
    super.initState();

    checkMeal(meals[widget.index].id);
  }

  @override
  Widget build(BuildContext context) {
    int index = widget.index;

    return Dialog(
        child: SingleChildScrollView(
      child: Container(
        width: 400,
        padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                    color: const Color.fromRGBO(213, 125, 31, 1), width: 5.0),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Image.network(
                meals[index].imgUrl,
                width: 200,
              ),
            ),
            const SizedBox(height: 10),

            /////////////////////////////////// TITLE
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Row( 
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: Text(
                    meals[index].name, 
                    // textAlign: TextAlign.center,             
                    style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ))),
                  const SizedBox(width: 15,),
                  if(isSaved) ...[
                    IconButton(
                      onPressed: () => 
                        removeSavedDrink(context, meals[index].id),
                      icon: const Icon(Icons.favorite),
                      iconSize: 40,
                      color: const Color(0xFFEF5450),
                    )
                  ] else ...[
                    const IconButton(
                      onPressed: null,
                      icon: Icon(Icons.favorite_border),
                      iconSize: 40,
                      color: Color(0xFFEF5450),
                    )
                  ]
              ],),
            ),
            
            /////////////////////////////////// CATEGORY & AREA
            const SizedBox(height: 15),
            RichText(
              text: TextSpan(
                  style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.normal, 
                      color: Colors.black),
                  children: [
                    const TextSpan(
                        text: "CATEGORY: ",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: " ${meals[index].category}"),
                    const TextSpan(
                        text: "\nAREA: ",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: " ${meals[index].area}"),
                  ]),
            ),

            /////////////////////////////////// INGREDIENTS
            const SizedBox(height: 20),
            const Text("INGREDIENTS", style: TextStyle(
              fontFamily: 'Poppins', 
              fontWeight: FontWeight.bold,
              fontSize: 18
            ),),
            const SizedBox(height: 3),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meals[index].ingredients,
                  textAlign: TextAlign.center,
                ),
              ],
            ),

            /////////////////////////////////// INSTRUCTIONS
            const SizedBox(height: 20),
            const Text("INSTRUCTIONS", style: TextStyle(
              fontFamily: 'Poppins', 
              fontWeight: FontWeight.bold,
              fontSize: 17
            ),),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 4, bottom: 10),
              child: Text(
                meals[index].instructions, 
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    ));
  }


  checkMeal(String id) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser!;
      String uid = currentUser.uid;

      CollectionReference mealCollection = FirebaseFirestore.instance
          .collection('UserUID')
          .doc(uid)
          .collection('Meal');

      DocumentSnapshot<Object?> documentSnapshot =
          await mealCollection.doc(id).get();

      bool checker = documentSnapshot.exists;
      setState(() {
        isSaved = checker;
      });
    } catch (error) {
      print(error);
    }
  }

  removeSavedDrink(context, id) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser!;
      String uid = currentUser.uid;

      CollectionReference mealCollection = FirebaseFirestore.instance
          .collection('UserUID')
          .doc(uid)
          .collection('Meal');

      try {
        await mealCollection.doc(id).delete();
        
        print('Drink removed successfully!');
        Navigator.of(context).pop();

        setState(() {
          isSaved = false;
        });

      } catch (e) {
        print(e);
      }
    } catch (error) {
      print(error);
    }
  }
}
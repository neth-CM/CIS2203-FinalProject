import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:mealapp/config/models/Meal.dart';

class Discover extends StatefulWidget {
  static const String routeName = "/discover";
  const Discover({super.key});

  @override
  State<Discover> createState() => _DiscoverState();
}

class _DiscoverState extends State<Discover> {
  Meal meal = Meal("", "", "", "", "", "", "");
  bool isSaved = false;
  String id = "";

  @override
  void initState() {
    super.initState();

    getRandomMeal();
    checkMeal(id);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFE4814A),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 25,),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 110),
                child: ElevatedButton(
                  onPressed: () => callApi(),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.only(
                      left: 5, top: 13, bottom: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                    backgroundColor: const Color(0xFFC8591C)),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Refresh", style: TextStyle(
                          fontFamily: 'LexendDeca',
                          fontSize: 19,
                          color: Colors.white),
                      ),
                      SizedBox(width: 5,),
                      Icon(Icons.refresh, color: Colors.white, size: 26,)
                    ],
                )),
              ),
              const SizedBox(height: 25,),
              Container(
                width: double.maxFinite,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(30),
                decoration: const BoxDecoration(color: Colors.white),
                child: Column(
                  children: [
                  if(meal.id != "") ...[
                    Image.network(meal.imgUrl),   //////////////// PICTURE
                    const SizedBox(height: 15,),
                    Row( 
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(child: Text(
                          meal.name,              //////////////// TITLE
                          style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 22,
                        ))),
                        const SizedBox(width: 18,),
                        if(isSaved) ...[
                          IconButton(
                            onPressed: () => 
                              removeSavedDrink(meal.id),
                            icon: const Icon(Icons.favorite),
                            iconSize: 40,
                            color: Color(0xFFEF5450),
                          )
                        ] else ...[
                          IconButton(
                            onPressed: () => 
                              addToFavorites(
                                meal.id, 
                                meal.name,
                                meal.category,
                                meal.area,
                                meal.ingredients,
                                meal.instructions,
                                meal.imgUrl
                              ),
                            icon: const Icon(Icons.favorite_border),
                            iconSize: 40,
                            color: Color(0xFFEF5450),
                          )
                        ]
                    ],), 
                    const SizedBox(height: 20,),

                    Row(                          //////////////// CATEGORY
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text("CATEGORY: ", style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                          fontSize: 23
                        )),
                        Text(" ${meal.category}", style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 20
                        )),
                    ],),

                    Row(                          //////////////// AREA
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text("AREA: ", style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                          fontSize: 23
                        )),
                        Text(" ${meal.area}", style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 20
                        )),
                    ],),

                    const SizedBox(height: 20,),  //////////////// INGREDIENTS
                    const Text("INGREDIENTS", style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      fontSize: 25
                    )),
                    const SizedBox(height: 10,),
                    Text(
                      meal.ingredients, 
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18, fontFamily: 'LexendDeca'),),
                    
                    const SizedBox(height: 25,),   //////////////// INSTRUCTIONS
                    const Text("INSTRUCTIONS", style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      fontSize: 24
                    )),
                    const SizedBox(height: 10,),
                    Text(
                      meal.instructions, 
                      textAlign: TextAlign.center, style: const TextStyle(
                        fontSize: 18, fontFamily: 'LexendDeca'),
                    )
                  ] else ... [
                    const Text(
                      "No Meals Found", 
                      textAlign: TextAlign.center, 
                      style: TextStyle(
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold
                    )),
                  ]
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }


  callApi() async {
    Response response = await http.get(
        Uri.parse("https://www.themealdb.com/api/json/v1/1/random.php"));

    setState(() {
      meal = Meal.fromJson(response.body);
      id = meal.id;
    });

    checkMeal(id);
  }

  Future<void> getRandomMeal() async {
    Response response = await http.get(
        Uri.parse("https://www.themealdb.com/api/json/v1/1/random.php"));

    setState(() {
      meal = Meal.fromJson(response.body);
      id = meal.id;
    });
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

  addToFavorites(id, name, category, area, ingredients, mealInstructions, img) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if(currentUser != null){
        String uid = currentUser.uid;

        CollectionReference mealCollection = FirebaseFirestore.instance
            .collection('UserUID')
            .doc(uid)
            .collection('Meal');

        try {
          await mealCollection.doc(id).set({
            'id': id, 
            'mealName': name,
            'category': category,
            'area': area,
            'ingredients': ingredients,
            'instructions': mealInstructions,
            'img': img
          });

          print('Drink saved successfully!');

          setState(() {
            isSaved = true;
          });
        } catch (e) {
          print(e);
        }
      }
    } catch (error) {
      print('Error saving drink: $error');
    }
  }

  removeSavedDrink(id) async {
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
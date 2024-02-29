import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:mealapp/config/models/Meal.dart';

List<dynamic> meals = [];

class Dashboard extends StatefulWidget {
  static const String routeName = "/dashboard";
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int number = 1;

  List<String> alphabet1 = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 
                            'h', 'i', 'j', 'k', 'l', 'm'];
  List<String> alphabet2 = ['n', 'o', 'p', 'q', 'r', 's', 't',
                            'u', 'v', 'w', 'x', 'y', 'z'];

  @override
  void initState() {
    super.initState();
    
    getMeals();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFE4814A),
        body: Column(
          children: [
            Card(
              elevation: 10,
              child: Container(
                color: Colors.white,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(
                    top: 5, right: 15, bottom: 10, left: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Browse Meals",
                      style: TextStyle(
                          fontFamily: 'LexendDeca',
                          fontSize: 25.0,
                          color: Color(0xFFC8591C)),
                    ),
                    const SizedBox(
                      height: 2.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        for (var i in alphabet1)
                          SizedBox(
                            width: 25,
                            height: 30,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    backgroundColor:const Color(0xFFC8591C),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5))),
                                onPressed: () => callApi(i),
                                child: Text(
                                  i.toUpperCase(),
                                  style: const TextStyle(color: Colors.white),
                                )),
                            ),
                      ],
                    ),
                    const SizedBox(
                      height: 4.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        for (var i in alphabet2)
                          SizedBox(
                            width: 25,
                            height: 30,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    backgroundColor:const Color(0xFFC8591C),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5))),
                                onPressed: () => callApi(i),
                                child: Text(
                                  i.toUpperCase(),
                                  style: const TextStyle(color: Colors.white),
                                )),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (meals.isNotEmpty) ...[
              Expanded(
                child: ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => MealDetails(index: index,),
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
                            Image.network(meals[index]["strMealThumb"]),
                            SizedBox(height: 12,),
                            Text(meals[index]["strMeal"],
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
            ] else ...[
              Container(
                padding: const EdgeInsets.only(top: 30),
                child: const Text("No Meals Found",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold)),
              )
            ]
          ],
        ),
      ),
    );
  }

  callApi(String l) async {
    Response response = await http.get(
        Uri.parse("https://www.themealdb.com/api/json/v1/1/search.php?f=$l"));

    Map<String, dynamic> jsonNewList = jsonDecode(response.body);

    List<dynamic> newValues =
        jsonNewList.containsValue(null) ? [] : jsonNewList["meals"];

    print(newValues);

    setState(() {
      meals = newValues;
    });
  }

  Future<void> getMeals() async {
    Response response = await http.get(
        Uri.parse("https://www.themealdb.com/api/json/v1/1/search.php?f=a"));

    Map<String, dynamic> jsonList = jsonDecode(response.body);

    List<dynamic> values = jsonList["meals"];

    setState(() {
      meals = values;
    });
  }

}

////////////////////////////////////////////////////////////////////////////////
/////////////////////////////// MEAL DETAILS ///////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

class MealDetails extends StatefulWidget {
  final int index;
  const MealDetails({required this.index, Key? key}) : super(key: key);

  @override
  State<MealDetails> createState() => _MealDetailsState();
}

class _MealDetailsState extends State<MealDetails> {
  List<String> mealIngredients = [];
  String instructions = '';
  bool isSaved = false;

  @override
  void initState() {
    super.initState();
    buildIngredientsListAndFetchInstructions();
    checkMeal(meals[widget.index]["idMeal"]);
  }

  void buildIngredientsListAndFetchInstructions() {
    var meal = meals[widget.index];
    mealIngredients.clear();
    for (int i = 1; i <= 20; i++) {
      if (meal['strIngredient$i'] != null && meal['strIngredient$i'] != '') {
        mealIngredients.add(
          '- ${meal['strMeasure$i']} ${meal['strIngredient$i']}',
        );
      } else {
        break;
      }
    }
    instructions = meal['strInstructions'];
    setState(() {
      mealIngredients = mealIngredients;
      instructions = instructions;
    });
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
                meals[index]["strMealThumb"],
                width: 200,
              ),
            ),
            const SizedBox(height: 10),

            /////////////////////////////////// TITLE
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Row( 
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: Text(
                    meals[index]["strMeal"], 
                    // textAlign: TextAlign.center,             
                    style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ))),
                  const SizedBox(width: 15,),
                  if(isSaved) ...[
                    IconButton(
                      onPressed: () => 
                        removeSavedDrink(meals[index]["idMeal"]),
                      icon: const Icon(Icons.favorite),
                      iconSize: 40,
                      color: Color(0xFFEF5450),
                    )
                  ] else ...[
                    IconButton(
                      onPressed: (){
                        addToFavorites(
                          meals[index]["idMeal"], 
                          meals[index]["strMeal"],
                          meals[index]["strCategory"],
                          meals[index]["strArea"],
                          convertToString(mealIngredients),
                          meals[index]["strInstructions"],
                          meals[index]["strMealThumb"]
                        );
                      },
                      icon: const Icon(Icons.favorite_border),
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
                    TextSpan(text: " ${meals[index]["strCategory"]}"),
                    const TextSpan(
                        text: "\nAREA: ",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: " ${meals[index]["strArea"]}"),
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
              children: mealIngredients
                  .map((ingredient) => Text(ingredient))
                  .toList(),
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
              child: Text(instructions, textAlign: TextAlign.center,),
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

  String convertToString(List<String> map){
    String strIngredients = map.join();

    return strIngredients;
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
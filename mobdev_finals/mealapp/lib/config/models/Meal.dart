import 'dart:convert';

class Meal {
  String id;
  String name;
  String category;
  String area;
  String ingredients;
  String instructions;
  String imgUrl;

  Meal(
    this.id, this.name, this.category, this.area, 
    this.ingredients, this.instructions, this.imgUrl
  );

  factory Meal.fromJson(String body) {
    Map<String, dynamic> jsonMap = jsonDecode(body);
    List<dynamic> meals = jsonMap['meals'];

    if (meals.isNotEmpty) {
      Map<String, dynamic> mealData = meals[0];
      String mealIngredients = '';
      
      if (mealData['strMeasure1'] != '' && mealData['strMeasure1'] != null){
        mealIngredients += '${mealData['strMeasure1']} ${mealData['strIngredient1']}';
      }


      for (int i = 1; i < 20 && mealData['strIngredient$i'] != ''; i++) {
          if (mealData['strIngredient$i'] != null){
            mealIngredients += '\n${mealData['strMeasure$i']} ${mealData['strIngredient$i']}';
          }
      }

      return Meal(
        mealData["idMeal"],
        mealData["strMeal"],
        mealData["strCategory"],
        mealData["strArea"],
        mealIngredients,
        mealData['strInstructions'],
        mealData["strMealThumb"],
      );
    }

    // Return a default meal if no data is available
    return Meal("", "", "", "", "", "", "");
  }
}

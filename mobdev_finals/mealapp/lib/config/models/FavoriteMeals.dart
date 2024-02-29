class FavoriteMeals {
  String id;
  String name;
  String category;
  String area;
  String ingredients;
  String instructions;
  String imgUrl;

  FavoriteMeals(
    this.id, this.name, this.category, this.area, 
    this.ingredients, this.instructions, this.imgUrl
  );

  factory FavoriteMeals.fromJson(Map<String, dynamic> json) {
    return FavoriteMeals(
      json['id'],
      json['mealName'],
      json["category"],
      json["area"],
      json["ingredients"],
      json['instructions'],
      json["img"],
    );
  }
}
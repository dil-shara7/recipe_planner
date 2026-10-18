class Ingredient {
  final String name;
  final String amount;

  const Ingredient(this.name, this.amount);
}

class Recipe {
  final String title;
  final int minutes;
  final String category; // Breakfast, Lunch, Dinner, Snacks
  final String imageUrl;
  final List<Ingredient> ingredients;
  final List<String> steps;
  bool isFavorite;

  Recipe({
    required this.title,
    required this.minutes,
    required this.category,
    required this.imageUrl,
    this.ingredients = const [],
    this.steps = const [],
    this.isFavorite = false,
  });
}
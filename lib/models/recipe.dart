class Ingredient {
  final String name;
  final String amount;

  const Ingredient(this.name, this.amount);

  factory Ingredient.fromJson(Map<String, dynamic> json) =>
      Ingredient(json['name'] ?? '', json['amount'] ?? '');

  Map<String, dynamic> toJson() => {'name': name, 'amount': amount};
}

class Recipe {
  int? id;
  final String title;
  final int minutes;
  final String category; // Breakfast, Lunch, Dinner, Snacks
  final String imageUrl;
  final List<Ingredient> ingredients;
  final List<String> steps;
  final bool isCustom; // true = added by the user, so it can be deleted
  bool isFavorite;

  Recipe({
    this.id,
    required this.title,
    required this.minutes,
    required this.category,
    required this.imageUrl,
    this.ingredients = const [],
    this.steps = const [],
    this.isCustom = false,
    this.isFavorite = false,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
        id: json['id'],
        title: json['title'] ?? '',
        minutes: json['minutes'] ?? 0,
        category: json['category'] ?? 'Dinner',
        imageUrl: json['imageUrl'] ?? '',
        isCustom: json['isCustom'] ?? false,
        isFavorite: json['favorite'] ?? false,
        ingredients: ((json['ingredients'] ?? []) as List)
            .map((e) => Ingredient.fromJson(e))
            .toList(),
        steps: List<String>.from(json['steps'] ?? []),
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'minutes': minutes,
        'category': category,
        'imageUrl': imageUrl,
        'isCustom': isCustom,
        'favorite': isFavorite,
        'ingredients': ingredients.map((e) => e.toJson()).toList(),
        'steps': steps,
      };
}
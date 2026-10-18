class Recipe {
  final String title;
  final int minutes;
  final String category; // Breakfast, Lunch, Dinner, Snacks
  final String imageUrl;
  bool isFavorite;

  Recipe({
    required this.title,
    required this.minutes,
    required this.category,
    required this.imageUrl,
    this.isFavorite = false,
  });
}
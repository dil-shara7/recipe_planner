import '../models/recipe.dart';

// One shared list of recipes used by every screen.
// (Later this will come from the backend.)
final List<Recipe> allRecipes = [
  Recipe(
    title: 'Chicken Stir Fry',
    minutes: 25,
    category: 'Dinner',
    imageUrl: 'https://picsum.photos/seed/stirfry/400/300',
    ingredients: const [
      Ingredient('Chicken', '300 g'),
      Ingredient('Soy sauce', '2 tbsp'),
      Ingredient('Garlic', '3 cloves'),
      Ingredient('Mixed vegetables', '200 g'),
    ],
    steps: const [
      'Slice the chicken and vegetables.',
      'Fry the chicken with garlic until golden.',
      'Add vegetables and soy sauce.',
      'Stir fry for 5 minutes and serve.',
    ],
  ),
  Recipe(
    title: 'Avocado Toast',
    minutes: 15,
    category: 'Breakfast',
    imageUrl: 'https://picsum.photos/seed/toast/400/300',
    isFavorite: true,
    ingredients: const [
      Ingredient('Bread slices', '2'),
      Ingredient('Avocado', '1'),
      Ingredient('Salt', '1 pinch'),
      Ingredient('Lemon juice', '1 tsp'),
    ],
    steps: const [
      'Toast the bread.',
      'Mash the avocado with salt and lemon juice.',
      'Spread on the toast and serve.',
    ],
  ),
  Recipe(
    title: 'Pasta Carbonara',
    minutes: 30,
    category: 'Lunch',
    imageUrl: 'https://picsum.photos/seed/pasta/400/300',
    ingredients: const [
      Ingredient('Spaghetti', '200 g'),
      Ingredient('Eggs', '2'),
      Ingredient('Parmesan cheese', '50 g'),
      Ingredient('Pancetta', '100 g'),
      Ingredient('Black pepper', '1 tsp'),
    ],
    steps: const [
      'Cook pasta according to package instructions.',
      'Fry pancetta until crispy.',
      'Beat eggs and mix with cheese and pepper.',
      'Combine everything and serve immediately.',
    ],
  ),
  Recipe(
    title: 'Vegetable Soup',
    minutes: 20,
    category: 'Dinner',
    imageUrl: 'https://picsum.photos/seed/soup/400/300',
    ingredients: const [
      Ingredient('Carrots', '2'),
      Ingredient('Potatoes', '2'),
      Ingredient('Onion', '1'),
      Ingredient('Vegetable stock', '500 ml'),
    ],
    steps: const [
      'Chop all the vegetables.',
      'Boil the stock and add the vegetables.',
      'Simmer for 15 minutes and serve hot.',
    ],
  ),
];

// Meal plan: key = date + meal type, value = the recipe
final Map<String, Recipe> mealPlan = {};

String planKey(DateTime d, String meal) =>
    '${d.year}-${d.month}-${d.day}|$meal';

// Extra items the user adds by hand on the shopping list
class ShoppingItem {
  final String name;
  final String quantity;
  final String unit;
  bool checked;

  ShoppingItem(this.name, this.quantity, this.unit, {this.checked = false});
}

final List<ShoppingItem> extraItems = [];

// Which meal-plan ingredients are ticked (key = name|unit)
final Set<String> checkedItems = {};
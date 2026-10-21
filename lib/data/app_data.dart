import '../models/recipe.dart';

// Default recipes built into the app (no backend or internet needed).
// To add one later: copy a Recipe(...) block, paste it, and change the details.
final List<Recipe> allRecipes = [
  // ---------------- BREAKFAST ----------------
  Recipe(
    title: 'Pancakes',
    minutes: 20,
    category: 'Breakfast',
    imageUrl: 'assets/images/pancakes.jpg',
    ingredients: const [
      Ingredient('Flour', '200 g'),
      Ingredient('Milk', '250 ml'),
      Ingredient('Eggs', '2'),
      Ingredient('Sugar', '2 tbsp'),
      Ingredient('Butter', '30 g'),
    ],
    steps: const [
      'Mix the flour, sugar, milk and eggs into a smooth batter.',
      'Heat a pan and melt a little butter.',
      'Pour in some batter and cook until bubbles appear.',
      'Flip and cook the other side until golden. Serve warm.',
    ],
  ),
  Recipe(
    title: 'Avocado Toast',
    minutes: 10,
    category: 'Breakfast',
    imageUrl: 'assets/images/avocado_toast.jpg',
    ingredients: const [
      Ingredient('Bread slices', '2'),
      Ingredient('Avocado', '1'),
      Ingredient('Lemon juice', '1 tsp'),
      Ingredient('Salt', '1 pinch'),
    ],
    steps: const [
      'Toast the bread until golden.',
      'Mash the avocado with lemon juice and salt.',
      'Spread on the toast and serve.',
    ],
  ),
  Recipe(
    title: 'Omelette',
    minutes: 10,
    category: 'Breakfast',
    imageUrl: 'assets/images/omelette.jpg',
    ingredients: const [
      Ingredient('Eggs', '3'),
      Ingredient('Onion', '1'),
      Ingredient('Tomato', '1'),
      Ingredient('Butter', '10 g'),
      Ingredient('Salt', '1 pinch'),
    ],
    steps: const [
      'Beat the eggs with a pinch of salt.',
      'Fry the chopped onion and tomato in butter for 2 minutes.',
      'Pour in the eggs and cook until set.',
      'Fold in half and serve.',
    ],
  ),
  Recipe(
    title: 'Oatmeal with Fruits',
    minutes: 15,
    category: 'Breakfast',
    imageUrl: 'assets/images/oatmeal.jpg',
    ingredients: const [
      Ingredient('Oats', '80 g'),
      Ingredient('Milk', '300 ml'),
      Ingredient('Banana', '1'),
      Ingredient('Honey', '1 tbsp'),
      Ingredient('Berries', '50 g'),
    ],
    steps: const [
      'Cook the oats in the milk for 5 to 7 minutes, stirring often.',
      'Pour into a bowl.',
      'Top with sliced banana, berries and honey.',
    ],
  ),
  Recipe(
    title: 'French Toast',
    minutes: 15,
    category: 'Breakfast',
    imageUrl: 'assets/images/french_toast.jpg',
    ingredients: const [
      Ingredient('Bread slices', '4'),
      Ingredient('Eggs', '2'),
      Ingredient('Milk', '100 ml'),
      Ingredient('Sugar', '1 tbsp'),
      Ingredient('Butter', '20 g'),
    ],
    steps: const [
      'Whisk the eggs, milk and sugar in a shallow dish.',
      'Dip each bread slice in the mixture.',
      'Fry in butter until golden on both sides.',
      'Serve warm.',
    ],
  ),

  // ---------------- LUNCH ----------------
  Recipe(
    title: 'Chicken Fried Rice',
    minutes: 25,
    category: 'Lunch',
    imageUrl: 'assets/images/fried_rice.jpg',
    ingredients: const [
      Ingredient('Cooked rice', '300 g'),
      Ingredient('Chicken', '200 g'),
      Ingredient('Eggs', '2'),
      Ingredient('Mixed vegetables', '100 g'),
      Ingredient('Soy sauce', '2 tbsp'),
    ],
    steps: const [
      'Cook the diced chicken in a hot pan until done.',
      'Push to one side and scramble the eggs.',
      'Add the vegetables and rice and stir fry for 5 minutes.',
      'Add the soy sauce, mix well and serve.',
    ],
  ),
  Recipe(
    title: 'Vegetable Salad',
    minutes: 10,
    category: 'Lunch',
    imageUrl: 'assets/images/vegetable_salad.jpg',
    ingredients: const [
      Ingredient('Lettuce', '1'),
      Ingredient('Tomato', '2'),
      Ingredient('Cucumber', '1'),
      Ingredient('Olive oil', '2 tbsp'),
      Ingredient('Lemon juice', '1 tbsp'),
    ],
    steps: const [
      'Wash and chop all the vegetables.',
      'Mix the olive oil and lemon juice for the dressing.',
      'Toss everything together and serve fresh.',
    ],
  ),
  Recipe(
    title: 'Grilled Chicken Sandwich',
    minutes: 25,
    category: 'Lunch',
    imageUrl: 'assets/images/chicken_sandwich.jpg',
    ingredients: const [
      Ingredient('Chicken', '200 g'),
      Ingredient('Bread rolls', '2'),
      Ingredient('Lettuce', '2 leaves'),
      Ingredient('Tomato', '1'),
      Ingredient('Olive oil', '1 tbsp'),
    ],
    steps: const [
      'Season the chicken and grill it for 6 to 8 minutes per side.',
      'Slice the chicken.',
      'Fill the rolls with lettuce, tomato and chicken.',
      'Serve warm.',
    ],
  ),
  Recipe(
    title: 'Veggie Wrap',
    minutes: 15,
    category: 'Lunch',
    imageUrl: 'assets/images/veggie_wrap.jpg',
    ingredients: const [
      Ingredient('Tortilla wraps', '2'),
      Ingredient('Carrot', '1'),
      Ingredient('Cucumber', '1'),
      Ingredient('Lettuce', '2 leaves'),
      Ingredient('Hummus', '4 tbsp'),
    ],
    steps: const [
      'Spread hummus over each wrap.',
      'Add the sliced carrot, cucumber and lettuce.',
      'Roll tightly, cut in half and serve.',
    ],
  ),
  Recipe(
    title: 'Pasta Carbonara',
    minutes: 30,
    category: 'Lunch',
    imageUrl: 'assets/images/carbonara.jpg',
    ingredients: const [
      Ingredient('Spaghetti', '200 g'),
      Ingredient('Eggs', '2'),
      Ingredient('Parmesan cheese', '50 g'),
      Ingredient('Pancetta', '100 g'),
      Ingredient('Black pepper', '1 tsp'),
    ],
    steps: const [
      'Cook the pasta according to the package instructions.',
      'Fry the pancetta until crispy.',
      'Beat the eggs and mix with the cheese and pepper.',
      'Combine everything and serve immediately.',
    ],
  ),

  // ---------------- DINNER ----------------
  Recipe(
    title: 'Chicken Stir Fry',
    minutes: 25,
    category: 'Dinner',
    imageUrl: 'assets/images/stir_fry.jpg',
    ingredients: const [
      Ingredient('Chicken', '300 g'),
      Ingredient('Soy sauce', '2 tbsp'),
      Ingredient('Garlic', '3 cloves'),
      Ingredient('Mixed vegetables', '200 g'),
    ],
    steps: const [
      'Slice the chicken and vegetables.',
      'Fry the chicken with garlic until golden.',
      'Add the vegetables and soy sauce.',
      'Stir fry for 5 minutes and serve.',
    ],
  ),
  Recipe(
    title: 'Vegetable Soup',
    minutes: 30,
    category: 'Dinner',
    imageUrl: 'assets/images/vegetable_soup.jpg',
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
  Recipe(
    title: 'Chicken Curry',
    minutes: 45,
    category: 'Dinner',
    imageUrl: 'assets/images/chicken_curry.jpg',
    ingredients: const [
      Ingredient('Chicken', '400 g'),
      Ingredient('Onion', '2'),
      Ingredient('Curry powder', '2 tbsp'),
      Ingredient('Coconut milk', '200 ml'),
      Ingredient('Garlic', '3 cloves'),
    ],
    steps: const [
      'Fry the chopped onion and garlic until soft.',
      'Add the chicken and curry powder and cook for 5 minutes.',
      'Pour in the coconut milk.',
      'Simmer for 25 minutes and serve with rice.',
    ],
  ),
  Recipe(
    title: 'Grilled Fish',
    minutes: 25,
    category: 'Dinner',
    imageUrl: 'assets/images/grilled_fish.jpg',
    ingredients: const [
      Ingredient('Fish fillets', '2'),
      Ingredient('Lemon juice', '2 tbsp'),
      Ingredient('Garlic', '2 cloves'),
      Ingredient('Olive oil', '1 tbsp'),
      Ingredient('Salt', '1 tsp'),
    ],
    steps: const [
      'Rub the fish with olive oil, garlic, lemon juice and salt.',
      'Rest for 10 minutes.',
      'Grill for 4 to 5 minutes on each side.',
      'Serve with lemon wedges.',
    ],
  ),
  Recipe(
    title: 'Spaghetti Bolognese',
    minutes: 45,
    category: 'Dinner',
    imageUrl: 'assets/images/bolognese.jpg',
    ingredients: const [
      Ingredient('Spaghetti', '200 g'),
      Ingredient('Minced beef', '250 g'),
      Ingredient('Tomato sauce', '300 ml'),
      Ingredient('Onion', '1'),
      Ingredient('Garlic', '2 cloves'),
    ],
    steps: const [
      'Fry the onion and garlic until soft.',
      'Add the minced beef and cook until browned.',
      'Pour in the tomato sauce and simmer for 20 minutes.',
      'Cook the spaghetti, then serve with the sauce.',
    ],
  ),

  // ---------------- SNACKS ----------------
  Recipe(
    title: 'Fruit Bowl',
    minutes: 10,
    category: 'Snacks',
    imageUrl: 'assets/images/fruit_bowl.jpg',
    ingredients: const [
      Ingredient('Apple', '1'),
      Ingredient('Banana', '1'),
      Ingredient('Grapes', '100 g'),
      Ingredient('Orange', '1'),
      Ingredient('Honey', '1 tsp'),
    ],
    steps: const [
      'Wash and chop all the fruit.',
      'Mix in a bowl.',
      'Drizzle with honey and serve chilled.',
    ],
  ),
  Recipe(
    title: 'Hummus with Veggies',
    minutes: 15,
    category: 'Snacks',
    imageUrl: 'assets/images/hummus.jpg',
    ingredients: const [
      Ingredient('Chickpeas', '240 g'),
      Ingredient('Tahini', '2 tbsp'),
      Ingredient('Lemon juice', '2 tbsp'),
      Ingredient('Garlic', '1 clove'),
      Ingredient('Carrot', '2'),
    ],
    steps: const [
      'Blend the chickpeas, tahini, lemon juice and garlic until smooth.',
      'Add a little water if it is too thick.',
      'Serve with carrot and other vegetable sticks.',
    ],
  ),
  Recipe(
    title: 'Banana Smoothie',
    minutes: 5,
    category: 'Snacks',
    imageUrl: 'assets/images/banana_smoothie.jpg',
    ingredients: const [
      Ingredient('Banana', '2'),
      Ingredient('Milk', '250 ml'),
      Ingredient('Honey', '1 tbsp'),
      Ingredient('Ice cubes', '4'),
    ],
    steps: const [
      'Peel the bananas and add them to a blender.',
      'Add the milk, honey and ice.',
      'Blend until smooth and serve cold.',
    ],
  ),
  Recipe(
    title: 'Garlic Bread',
    minutes: 15,
    category: 'Snacks',
    imageUrl: 'assets/images/garlic_bread.jpg',
    ingredients: const [
      Ingredient('Baguette', '1'),
      Ingredient('Butter', '60 g'),
      Ingredient('Garlic', '3 cloves'),
      Ingredient('Parsley', '1 tbsp'),
    ],
    steps: const [
      'Mix the soft butter with crushed garlic and parsley.',
      'Slice the baguette and spread the garlic butter inside.',
      'Bake at 200 C for 10 minutes until crisp.',
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
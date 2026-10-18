import 'package:flutter/material.dart';
import '../models/recipe.dart';
import 'login_screen.dart';
import 'recipe_details_screen.dart';
import 'add_recipe_screen.dart';

class RecipeListScreen extends StatefulWidget {
  const RecipeListScreen({super.key});

  @override
  State<RecipeListScreen> createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  String _selected = 'All';
  final _categories = ['All', 'Breakfast', 'Lunch', 'Dinner', 'Snacks'];

  final List<Recipe> _recipes = [
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

  @override
  Widget build(BuildContext context) {
    final shown = _selected == 'All'
        ? _recipes
        : _recipes.where((r) => r.category == _selected).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Recipes',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kGreen,
        foregroundColor: Colors.white,
        onPressed: () async {
          final newRecipe = await Navigator.push<Recipe>(
            context,
            MaterialPageRoute(builder: (_) => const AddRecipeScreen()),
          );
          if (newRecipe != null) {
            setState(() => _recipes.add(newRecipe));
          }
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          // Search box
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search recipes...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Category chips
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: _categories.map((c) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(c),
                    selected: _selected == c,
                    selectedColor: kGreen,
                    labelStyle: TextStyle(
                      color: _selected == c ? Colors.white : Colors.black,
                    ),
                    onSelected: (_) => setState(() => _selected = c),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),

          // Recipe grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.8,
              ),
              itemCount: shown.length,
              itemBuilder: (context, index) {
                final r = shown[index];
                return InkWell(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RecipeDetailsScreen(recipe: r),
                      ),
                    );
                    // Refresh in case the favorite heart changed
                    setState(() {});
                  },
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.network(r.imageUrl, fit: BoxFit.cover),
                              Positioned(
                                top: 4,
                                right: 4,
                                child: IconButton(
                                  icon: Icon(
                                    r.isFavorite
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: r.isFavorite
                                        ? Colors.red
                                        : Colors.white,
                                  ),
                                  onPressed: () => setState(
                                    () => r.isFavorite = !r.isFavorite,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                r.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${r.minutes} mins · ${r.category}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
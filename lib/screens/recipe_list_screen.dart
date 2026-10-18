import 'package:flutter/material.dart';
import '../models/recipe.dart';
import 'login_screen.dart';

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
    ),
    Recipe(
      title: 'Avocado Toast',
      minutes: 15,
      category: 'Breakfast',
      imageUrl: 'https://picsum.photos/seed/toast/400/300',
      isFavorite: true,
    ),
    Recipe(
      title: 'Pasta Carbonara',
      minutes: 30,
      category: 'Lunch',
      imageUrl: 'https://picsum.photos/seed/pasta/400/300',
    ),
    Recipe(
      title: 'Vegetable Soup',
      minutes: 20,
      category: 'Dinner',
      imageUrl: 'https://picsum.photos/seed/soup/400/300',
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
                return Card(
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
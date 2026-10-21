import 'package:flutter/material.dart';
import '../data/app_data.dart';
import '../models/recipe.dart';
import '../widgets/recipe_image.dart';
import 'login_screen.dart';
import 'recipe_details_screen.dart';

class MealPlanScreen extends StatefulWidget {
  const MealPlanScreen({super.key});

  @override
  State<MealPlanScreen> createState() => _MealPlanScreenState();
}

class _MealPlanScreenState extends State<MealPlanScreen> {
  late DateTime _monday;
  late DateTime _selected;

  final _meals = ['Breakfast', 'Lunch', 'Dinner', 'Snacks'];
  final _dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  final _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selected = DateTime(now.year, now.month, now.day);
    _monday = _selected.subtract(Duration(days: _selected.weekday - 1));
  }

  void _changeWeek(int weeks) {
    setState(() {
      _monday = _monday.add(Duration(days: 7 * weeks));
      _selected = _selected.add(Duration(days: 7 * weeks));
    });
  }

  Future<void> _pickRecipe(String meal) async {
    final chosen = await showModalBottomSheet<Recipe>(
      context: context,
      builder: (ctx) => ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Choose a recipe',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          for (final r in allRecipes)
            ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: RecipeImage(path: r.imageUrl, width: 48, height: 48),
              ),
              title: Text(r.title),
              subtitle: Text('${r.minutes} mins'),
              onTap: () => Navigator.pop(ctx, r),
            ),
        ],
      ),
    );
    if (chosen != null) {
      setState(() => mealPlan[planKey(_selected, meal)] = chosen);
    }
  }

  @override
  Widget build(BuildContext context) {
    final sunday = _monday.add(const Duration(days: 6));
    final range =
        '${_months[_monday.month - 1]} ${_monday.day} – ${_months[sunday.month - 1]} ${sunday.day}, ${sunday.year}';

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Meal Planner',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // Week header
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () => _changeWeek(-1),
              ),
              Text(range, style: const TextStyle(fontWeight: FontWeight.w600)),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () => _changeWeek(1),
              ),
            ],
          ),

          // Day selector
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: List.generate(7, (i) {
                final day = _monday.add(Duration(days: i));
                final isSel = day.year == _selected.year &&
                    day.month == _selected.month &&
                    day.day == _selected.day;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selected = day),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: isSel ? kGreen : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Text(
                            _dayNames[i],
                            style: TextStyle(
                              fontSize: 12,
                              color: isSel ? Colors.white : Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${day.day}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isSel ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 16),

          // Meals for the selected day
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: _meals.map((meal) {
                final r = mealPlan[planKey(_selected, meal)];
                return Card(
                  child: r == null
                      ? ListTile(
                          leading: SizedBox(
                            width: 70,
                            child: Text(
                              meal,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: const Text(
                            'Add meal',
                            style: TextStyle(color: Colors.grey),
                          ),
                          trailing: const Icon(Icons.add_circle, color: kGreen),
                          onTap: () => _pickRecipe(meal),
                        )
                      : ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: RecipeImage(
                              path: r.imageUrl,
                              width: 56,
                              height: 56,
                            ),
                          ),
                          title: Text(
                            r.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text('$meal · ${r.minutes} mins'),
                          trailing: IconButton(
                            icon: const Icon(Icons.close, color: Colors.red),
                            onPressed: () => setState(
                              () => mealPlan.remove(planKey(_selected, meal)),
                            ),
                          ),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RecipeDetailsScreen(recipe: r),
                            ),
                          ),
                        ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
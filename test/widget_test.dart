import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_planner/models/recipe.dart';

void main() {
  test('Recipe JSON round trip', () {
    final r = Recipe(
      title: 'Test',
      minutes: 10,
      category: 'Lunch',
      imageUrl: '',
      ingredients: const [Ingredient('Eggs', '2')],
      steps: const ['Cook'],
    );
    final copy = Recipe.fromJson(r.toJson());
    expect(copy.title, 'Test');
    expect(copy.ingredients.first.name, 'Eggs');
    expect(copy.steps.length, 1);
  });
}
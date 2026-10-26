import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/app_data.dart';
import '../models/recipe.dart';

// Saves and loads the user's data on the phone, separately for each account.
class StorageService {
  static String _k(SharedPreferences p, String name) =>
      '${p.getString('session') ?? 'guest'}:$name';

  // Back to the plain built-in data (used before loading and on logout)
  static void reset() {
    allRecipes.removeWhere((r) => r.isCustom);
    for (final r in allRecipes) {
      r.isFavorite = false;
    }
    mealPlan.clear();
    extraItems.clear();
    checkedItems.clear();
  }

  static Future<void> save() async {
    final p = await SharedPreferences.getInstance();
    if (p.getString('session') == null) return;

    await p.setString(
      _k(p, 'custom'),
      jsonEncode(
          allRecipes.where((r) => r.isCustom).map((r) => r.toJson()).toList()),
    );
    await p.setStringList(
      _k(p, 'favorites'),
      allRecipes.where((r) => r.isFavorite).map((r) => r.title).toList(),
    );
    await p.setString(
      _k(p, 'plan'),
      jsonEncode(mealPlan.map((key, r) => MapEntry(key, r.title))),
    );
    await p.setString(
      _k(p, 'extras'),
      jsonEncode(extraItems
          .map((e) => {
                'name': e.name,
                'quantity': e.quantity,
                'unit': e.unit,
                'checked': e.checked,
              })
          .toList()),
    );
    await p.setStringList(_k(p, 'checked'), checkedItems.toList());
  }

  static Future<void> load() async {
    final p = await SharedPreferences.getInstance();
    reset();

    final custom = p.getString(_k(p, 'custom'));
    if (custom != null) {
      for (final e in jsonDecode(custom) as List) {
        allRecipes.add(Recipe.fromJson(Map<String, dynamic>.from(e)));
      }
    }

    final favs = p.getStringList(_k(p, 'favorites')) ?? [];
    for (final r in allRecipes) {
      r.isFavorite = favs.contains(r.title);
    }

    final plan = p.getString(_k(p, 'plan'));
    if (plan != null) {
      final saved = Map<String, dynamic>.from(jsonDecode(plan));
      saved.forEach((key, title) {
        final found = allRecipes.where((r) => r.title == title);
        if (found.isNotEmpty) mealPlan[key] = found.first;
      });
    }

    final extras = p.getString(_k(p, 'extras'));
    if (extras != null) {
      for (final e in jsonDecode(extras) as List) {
        extraItems.add(ShoppingItem(
          e['name'] ?? '',
          e['quantity'] ?? '',
          e['unit'] ?? '',
          checked: e['checked'] ?? false,
        ));
      }
    }

    checkedItems.addAll(p.getStringList(_k(p, 'checked')) ?? []);
  }
}
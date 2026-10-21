import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/recipe.dart';

// Works on the phone because of: adb reverse tcp:8080 tcp:8080
const baseUrl = 'http://localhost:8080';

class ApiService {
  static const _headers = {'Content-Type': 'application/json'};

  static Future<List<Recipe>> getRecipes() async {
    final res = await http.get(Uri.parse('$baseUrl/recipes'));
    if (res.statusCode != 200) {
      throw Exception('Server error ${res.statusCode}');
    }
    final list = jsonDecode(res.body) as List;
    return list.map((e) => Recipe.fromJson(e)).toList();
  }

  static Future<Recipe> addRecipe(Recipe r) async {
    final res = await http.post(
      Uri.parse('$baseUrl/recipes'),
      headers: _headers,
      body: jsonEncode(r.toJson()),
    );
    if (res.statusCode != 200) {
      throw Exception('Could not save recipe');
    }
    return Recipe.fromJson(jsonDecode(res.body));
  }

  static Future<void> updateRecipe(Recipe r) async {
    await http.put(
      Uri.parse('$baseUrl/recipes/${r.id}'),
      headers: _headers,
      body: jsonEncode(r.toJson()),
    );
  }
}
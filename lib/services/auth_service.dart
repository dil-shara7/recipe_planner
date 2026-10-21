import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static String _hash(String password) =>
      sha256.convert(utf8.encode(password)).toString();

  static Future<Map<String, dynamic>> _users(SharedPreferences prefs) async {
    final raw = prefs.getString('users');
    return raw == null ? {} : Map<String, dynamic>.from(jsonDecode(raw));
  }

  // Returns null if OK, or an error message
  static Future<String?> register(
      String name, String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final users = await _users(prefs);
    final key = email.trim().toLowerCase();
    if (users.containsKey(key)) return 'This email is already registered';
    users[key] = {'name': name.trim(), 'hash': _hash(password)};
    await prefs.setString('users', jsonEncode(users));
    await prefs.setString('session', key);
    return null;
  }

  // Returns null if OK, or an error message
  static Future<String?> login(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final users = await _users(prefs);
    final key = email.trim().toLowerCase();
    final user = users[key];
    if (user == null || user['hash'] != _hash(password)) {
      return 'Wrong email or password';
    }
    await prefs.setString('session', key);
    return null;
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('session') != null;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('session');
  }
}
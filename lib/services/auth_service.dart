import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';
import 'package:flutter/foundation.dart';

// Paste the Client ID of your *Web application* OAuth client here (Part 2)
const kGoogleWebClientId = '931360606737-74t9fnnhjovo8880o9g19c2vr5vcgnm1.apps.googleusercontent.com';

class AuthService {
  static bool _googleReady = false;

  static String _hash(String p) => sha256.convert(utf8.encode(p)).toString();

  // Returns null when the server cannot be reached
  static Future<http.Response?> _post(
      String path, Map<String, dynamic> body) async {
    try {
      return await http
          .post(
            Uri.parse('$baseUrl$path'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 5));
    } catch (_) {
      return null;
    }
  }

  static String _errorOf(http.Response res, String fallback) {
    try {
      return (jsonDecode(res.body)['error'] ?? fallback).toString();
    } catch (_) {
      return fallback;
    }
  }

  static Map<String, dynamic> _users(SharedPreferences prefs) {
    final raw = prefs.getString('users');
    return raw == null ? {} : Map<String, dynamic>.from(jsonDecode(raw));
  }

  static Future<void> _saveLocal(
      SharedPreferences prefs, String key, String name, String password) async {
    final users = _users(prefs);
    users[key] = {'name': name, 'hash': _hash(password)};
    await prefs.setString('users', jsonEncode(users));
  }

  static Future<void> _startSession(SharedPreferences prefs, String key,
      {String? token}) async {
    await prefs.setString('session', key);
    if (token != null) {
      await prefs.setString('token', token);
    } else {
      await prefs.remove('token');
    }
  }

  // Returns null if OK, or an error message
  static Future<String?> register(
      String name, String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final key = email.trim().toLowerCase();
    final res = await _post('/auth/register',
        {'name': name.trim(), 'email': key, 'password': password});

    if (res != null) {
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        await _saveLocal(prefs, key, name.trim(), password);
        await _startSession(prefs, key, token: data['token']);
        return null;
      }
      return _errorOf(res, 'Registration failed');
    }

    // Server not reachable: register on the phone only
    if (_users(prefs).containsKey(key)) {
      return 'This email is already registered';
    }
    await _saveLocal(prefs, key, name.trim(), password);
    await _startSession(prefs, key);
    return null;
  }

  // Returns null if OK, or an error message
  static Future<String?> login(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final key = email.trim().toLowerCase();
    final res = await _post('/auth/login', {'email': key, 'password': password});

    if (res != null && res.statusCode == 200) {
      final data = jsonDecode(res.body);
      await _saveLocal(prefs, key, (data['name'] ?? '').toString(), password);
      await _startSession(prefs, key, token: data['token']);
      return null;
    }

    // Server said no, or could not be reached: check the account saved on the phone
    final user = _users(prefs)[key];
    if (user != null && user['hash'] == _hash(password)) {
      await _startSession(prefs, key);
      return null;
    }
    if (res != null) return _errorOf(res, 'Wrong email or password');
    return 'Wrong email or password';
  }

  // Returns null if OK, or an error message
  static Future<String?> googleSignIn() async {
    try {
      final gs = GoogleSignIn.instance;
      if (!_googleReady) {
        await gs.initialize(serverClientId: kGoogleWebClientId);
        _googleReady = true;
      }
      final account = await gs.authenticate();
      final idToken = account.authentication.idToken;
      if (idToken == null) return 'Google sign-in failed';

      final prefs = await SharedPreferences.getInstance();
      final res = await _post('/auth/google', {'idToken': idToken});

      if (res != null) {
        if (res.statusCode == 200) {
          final data = jsonDecode(res.body);
          await _startSession(prefs, data['email'].toString().toLowerCase(),
              token: data['token']);
          return null;
        }
        return _errorOf(res, 'Google sign-in failed');
      }

      // Backend not reachable: sign in on the phone with the Google account
      await _startSession(prefs, account.email.toLowerCase());
      return null;
       } catch (e) {
         debugPrint('GOOGLE SIGN-IN ERROR: $e');
         return 'Google sign-in was cancelled or failed';
       }
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('session') != null;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('session');
    await prefs.remove('token');
  }
}
import 'dart:async';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';
import 'main_shell.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _next();
  }

  Future<void> _next() async {
    await Future.delayed(const Duration(seconds: 2));
    bool loggedIn = false;
    try {
      loggedIn = await AuthService.isLoggedIn();
    } catch (_) {
      loggedIn = false;
    }
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => loggedIn ? const MainShell() : const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.restaurant_menu, size: 100, color: kGreen),
            SizedBox(height: 12),
            Text(
              'MealMate',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: kGreen,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Better Meals. Happier You.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 40),
            SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(strokeWidth: 3, color: kGreen),
            ),
          ],
        ),
      ),
    );
  }
}
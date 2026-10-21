import 'package:flutter/material.dart';
import '../screens/login_screen.dart';

// Shows a photo from inside the app (assets/...) or from the internet (http...)
class RecipeImage extends StatelessWidget {
  final String path;
  final double? width;
  final double? height;

  const RecipeImage({super.key, required this.path, this.width, this.height});

  Widget _placeholder() => Container(
        width: width,
        height: height,
        color: const Color(0xFFE8F5EE),
        child: const Icon(Icons.restaurant, size: 40, color: kGreen),
      );

  @override
  Widget build(BuildContext context) {
    if (path.isEmpty) return _placeholder();
    if (path.startsWith('http')) {
      return Image.network(
        path,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _placeholder(),
      );
    }
    return Image.asset(
      path,
      width: width,
      height: height,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _placeholder(),
    );
  }
}
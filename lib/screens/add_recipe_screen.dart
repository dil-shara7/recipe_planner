import 'package:flutter/material.dart';
import '../models/recipe.dart';
import 'login_screen.dart';

class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({super.key});

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _timeCtrl = TextEditingController();
  final _imageCtrl = TextEditingController();

  final _categories = ['Breakfast', 'Lunch', 'Dinner', 'Snacks'];
  String _category = 'Dinner';

  // Each ingredient row has a name and an amount
  final List<TextEditingController> _ingNames = [TextEditingController()];
  final List<TextEditingController> _ingAmounts = [TextEditingController()];

  // Each step row has one text box
  final List<TextEditingController> _steps = [TextEditingController()];

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _timeCtrl.dispose();
    _imageCtrl.dispose();
    for (final c in [..._ingNames, ..._ingAmounts, ..._steps]) {
      c.dispose();
    }
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final ingredients = <Ingredient>[];
    for (var i = 0; i < _ingNames.length; i++) {
      final name = _ingNames[i].text.trim();
      if (name.isNotEmpty) {
        ingredients.add(Ingredient(name, _ingAmounts[i].text.trim()));
      }
    }

    final steps = _steps
        .map((c) => c.text.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    final recipe = Recipe(
      isCustom: true,
      title: _titleCtrl.text.trim(),
      minutes: int.tryParse(_timeCtrl.text.trim()) ?? 0,
      category: _category,
      imageUrl: _imageCtrl.text.trim(),
      ingredients: ingredients,
      steps: steps,
    );

    // Send the new recipe back to the previous screen
    Navigator.pop(context, recipe);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Recipe')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleCtrl,
              decoration: const InputDecoration(
                labelText: 'Title *',
                hintText: 'e.g. Chicken Stir Fry',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Please enter a title' : null,
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _descCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Short description about the recipe...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _imageCtrl,
              decoration: const InputDecoration(
                labelText: 'Photo link (optional)',
                hintText: 'https://...jpg',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _category,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                    ),
                    items: _categories
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (v) => setState(() => _category = v!),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _timeCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Time (minutes)',
                      hintText: 'e.g. 25',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Ingredients
            const Text(
              'Ingredients',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            for (var i = 0; i < _ingNames.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: _ingNames[i],
                        decoration: InputDecoration(
                          hintText: 'Ingredient ${i + 1}',
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: _ingAmounts[i],
                        decoration: const InputDecoration(
                          hintText: 'e.g. 200 g',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: _ingNames.length == 1
                          ? null
                          : () => setState(() {
                                _ingNames.removeAt(i).dispose();
                                _ingAmounts.removeAt(i).dispose();
                              }),
                    ),
                  ],
                ),
              ),
            TextButton.icon(
              onPressed: () => setState(() {
                _ingNames.add(TextEditingController());
                _ingAmounts.add(TextEditingController());
              }),
              icon: const Icon(Icons.add_circle, color: kGreen),
              label: const Text(
                'Add Ingredient',
                style: TextStyle(color: kGreen),
              ),
            ),
            const SizedBox(height: 16),

            // Steps
            const Text(
              'Steps',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            for (var i = 0; i < _steps.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _steps[i],
                        decoration: InputDecoration(
                          hintText: 'Step ${i + 1}',
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: _steps.length == 1
                          ? null
                          : () => setState(() => _steps.removeAt(i).dispose()),
                    ),
                  ],
                ),
              ),
            TextButton.icon(
              onPressed: () =>
                  setState(() => _steps.add(TextEditingController())),
              icon: const Icon(Icons.add_circle, color: kGreen),
              label: const Text('Add Step', style: TextStyle(color: kGreen)),
            ),
            const SizedBox(height: 24),

            SizedBox(
              height: 48,
              child: FilledButton(
                style: FilledButton.styleFrom(backgroundColor: kGreen),
                onPressed: _save,
                child: const Text('Save Recipe'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
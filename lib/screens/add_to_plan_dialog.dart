import 'package:flutter/material.dart';
import '../data/app_data.dart';
import '../models/recipe.dart';
import 'login_screen.dart';

Future<void> showAddToPlanDialog(BuildContext context, Recipe recipe) async {
  DateTime date = DateTime.now();
  String meal = 'Lunch';
  const meals = ['Breakfast', 'Lunch', 'Dinner'];

  await showDialog(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setDialogState) => AlertDialog(
        title: const Text('Add to Meal Plan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              recipe.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text('Select Date'),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              icon: const Icon(Icons.calendar_today, size: 18),
              label: Text('${date.day}/${date.month}/${date.year}'),
              onPressed: () async {
                final picked = await showDatePicker(
                  context: ctx,
                  initialDate: date,
                  firstDate: DateTime.now().subtract(const Duration(days: 30)),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (picked != null) setDialogState(() => date = picked);
              },
            ),
            const SizedBox(height: 16),
            const Text('Select Meal Type'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: meals.map((m) {
                return ChoiceChip(
                  label: Text(m),
                  selected: meal == m,
                  selectedColor: kGreen,
                  labelStyle: TextStyle(
                    color: meal == m ? Colors.white : Colors.black,
                  ),
                  onSelected: (_) => setDialogState(() => meal = m),
                );
              }).toList(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: kGreen),
            onPressed: () {
              mealPlan[planKey(date, meal)] = recipe;
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Added to $meal on ${date.day}/${date.month}')),
              );
            },
            child: const Text('Add'),
          ),
        ],
      ),
    ),
  );
}
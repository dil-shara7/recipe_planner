import 'package:flutter/material.dart';
import '../data/app_data.dart';
import 'login_screen.dart';

class _Line {
  final String name;
  double qty;
  final String unit;
  _Line(this.name, this.qty, this.unit);
}

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  final _meals = ['Breakfast', 'Lunch', 'Dinner', 'Snacks'];
  final _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  String _fmt(double q) =>
      q == q.roundToDouble() ? q.toInt().toString() : q.toStringAsFixed(1);

  // Collect ingredients from this week's meal plan and merge duplicates
  List<_Line> _buildLines(DateTime monday) {
    final merged = <String, _Line>{};
    for (var i = 0; i < 7; i++) {
      final day = monday.add(Duration(days: i));
      for (final meal in _meals) {
        final r = mealPlan[planKey(day, meal)];
        if (r == null) continue;
        for (final ing in r.ingredients) {
          final text = ing.amount.trim();
          final m = RegExp(r'^(\d+(?:\.\d+)?)\s*(.*)$').firstMatch(text);
          final qty = m != null ? double.parse(m.group(1)!) : 1.0;
          final unit = m != null ? m.group(2)!.trim() : text;
          final key = '${ing.name.toLowerCase()}|$unit';
          if (merged.containsKey(key)) {
            merged[key]!.qty += qty;
          } else {
            merged[key] = _Line(ing.name, qty, unit);
          }
        }
      }
    }
    return merged.values.toList();
  }

  Future<void> _addItem() async {
    final nameCtrl = TextEditingController();
    final qtyCtrl = TextEditingController();
    String unit = 'piece';
    const units = ['piece', 'g', 'kg', 'ml', 'l', 'tbsp', 'tsp'];

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Add Shopping Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Item name',
                  hintText: 'e.g. Milk',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: qtyCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Quantity',
                  hintText: 'e.g. 1',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: unit,
                decoration: const InputDecoration(
                  labelText: 'Unit',
                  border: OutlineInputBorder(),
                ),
                items: units
                    .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                    .toList(),
                onChanged: (v) => setDialogState(() => unit = v!),
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
                final name = nameCtrl.text.trim();
                if (name.isEmpty) return;
                setState(() {
                  extraItems.add(
                    ShoppingItem(name, qtyCtrl.text.trim(), unit),
                  );
                });
                Navigator.pop(ctx);
              },
              child: const Text('Add Item'),
            ),
          ],
        ),
      ),
    );

    nameCtrl.dispose();
    qtyCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final monday = today.subtract(Duration(days: today.weekday - 1));
    final sunday = monday.add(const Duration(days: 6));
    final range =
        'Week of ${_months[monday.month - 1]} ${monday.day} – ${_months[sunday.month - 1]} ${sunday.day}, ${sunday.year}';

    final lines = _buildLines(monday);

    final total = lines.length + extraItems.length;
    final done = lines
            .where((l) => checkedItems.contains('${l.name}|${l.unit}'))
            .length +
        extraItems.where((e) => e.checked).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Shopping List',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilledButton.icon(
              style: FilledButton.styleFrom(backgroundColor: kGreen),
              onPressed: _addItem,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Item'),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(range, style: const TextStyle(color: Colors.grey)),
            ),
          ),
          Expanded(
            child: total == 0
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(
                        'Your list is empty.\nAdd meals to your Meal Plan or tap Add Item.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : ListView(
                    children: [
                      if (lines.isNotEmpty)
                        const Padding(
                          padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
                          child: Text(
                            'Ingredients (from meal plan)',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      for (final l in lines)
                        CheckboxListTile(
                          activeColor: kGreen,
                          controlAffinity: ListTileControlAffinity.leading,
                          value: checkedItems.contains('${l.name}|${l.unit}'),
                          onChanged: (v) => setState(() {
                            final k = '${l.name}|${l.unit}';
                            v == true
                                ? checkedItems.add(k)
                                : checkedItems.remove(k);
                          }),
                          title: Text(
                            l.name,
                            style: TextStyle(
                              decoration:
                                  checkedItems.contains('${l.name}|${l.unit}')
                                      ? TextDecoration.lineThrough
                                      : null,
                            ),
                          ),
                          secondary: Text(
                            '${_fmt(l.qty)} ${l.unit}'.trim(),
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ),
                      if (extraItems.isNotEmpty)
                        const Padding(
                          padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                          child: Text(
                            'My items',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      for (final e in extraItems)
                        CheckboxListTile(
                          activeColor: kGreen,
                          controlAffinity: ListTileControlAffinity.leading,
                          value: e.checked,
                          onChanged: (v) =>
                              setState(() => e.checked = v ?? false),
                          title: Text(
                            e.name,
                            style: TextStyle(
                              decoration:
                                  e.checked ? TextDecoration.lineThrough : null,
                            ),
                          ),
                          subtitle: Text('${e.quantity} ${e.unit}'.trim()),
                          secondary: IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                            ),
                            onPressed: () =>
                                setState(() => extraItems.remove(e)),
                          ),
                        ),
                    ],
                  ),
          ),

          // Progress bar
          if (total > 0)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LinearProgressIndicator(
                    value: done / total,
                    color: kGreen,
                    backgroundColor: Colors.grey.shade200,
                    minHeight: 6,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$done of $total items checked',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
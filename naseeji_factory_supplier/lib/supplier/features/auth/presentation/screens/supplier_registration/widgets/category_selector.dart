import 'package:flutter/material.dart';

class CategorySelector extends StatelessWidget {
  final List<String> availableCategories;
  final List<String> selectedCategories;
  final Function(String) onToggle;

  const CategorySelector({
    super.key,
    required this.availableCategories,
    required this.selectedCategories,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: availableCategories.map((category) {
        final isSelected = selectedCategories.contains(category);
        return ChoiceChip(
          label: Text(category),
          selected: isSelected,
          onSelected: (_) => onToggle(category),
          selectedColor: Theme.of(context).colorScheme.primaryContainer,
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : Theme.of(context).colorScheme.onSurface,
          ),
        );
      }).toList(),
    );
  }
}

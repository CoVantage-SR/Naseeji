import 'package:flutter/material.dart';

class GovernorateDropdown extends StatelessWidget {
  final String? selectedGovernorate;
  final String? errorText;
  final ValueChanged<String?> onChanged;

  const GovernorateDropdown({
    super.key,
    this.selectedGovernorate,
    this.errorText,
    required this.onChanged,
  });

  static const List<String> governorates = [
    'القاهرة',
    'الجيزة',
    'الإسكندرية',
    'الغربية',
    'الدقهلية',
    'الشرقية',
    'المنوفية',
    'القليوبية',
    'البحيرة',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'المحافظة *',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          key: ValueKey(selectedGovernorate),
          initialValue: governorates.contains(selectedGovernorate)
              ? selectedGovernorate
              : null,
          onChanged: onChanged,
          isExpanded: true,
          decoration: InputDecoration(
            hintText: 'اختر المحافظة',
            prefixIcon: Icon(
              Icons.map_outlined,
              color: colorScheme.outline,
            ),
            errorText: errorText,
          ),
          items: governorates.map((gov) {
            return DropdownMenuItem<String>(
              value: gov,
              child: Text(
                gov,
                style: const TextStyle(fontSize: 14),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

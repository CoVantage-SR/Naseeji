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
    'القليوبية',
    'الدقهلية',
    'الشرقية',
    'الغربية',
    'المنوفية',
    'البحيرة',
    'كفر الشيخ',
    'دمياط',
    'بورسعيد',
    'الإسماعيلية',
    'السويس',
    'بني سويف',
    'الفيوم',
    'المنيا',
    'أسيوط',
    'سوهاج',
    'قنا',
    'الأقصر',
    'أسوان',
    'مطروح',
    'الوادي الجديد',
    'البحر الأحمر',
    'شمال سيناء',
    'جنوب سيناء',
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
            hintText: 'اختر المحافظة من محافظات مصر',
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

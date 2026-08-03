import 'package:flutter/material.dart';

class CityField extends StatelessWidget {
  final TextEditingController controller;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  const CityField({
    super.key,
    required this.controller,
    this.errorText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'المدينة / المركز / المنطقة *',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          onChanged: onChanged,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            hintText: 'اكتب مدينتك أو منطقتك (مثال: المحلة الكبرى / مدينة نصر / 6 أكتوبر)',
            prefixIcon: Icon(
              Icons.location_city_outlined,
              color: colorScheme.outline,
            ),
            errorText: errorText,
          ),
        ),
      ],
    );
  }
}

// Retain CityDropdown alias for backwards compatibility
class CityDropdown extends StatelessWidget {
  final String? selectedGovernorate;
  final String? selectedCity;
  final String? errorText;
  final ValueChanged<String?> onChanged;

  const CityDropdown({
    super.key,
    this.selectedGovernorate,
    this.selectedCity,
    this.errorText,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: selectedCity ?? '');
    return CityField(
      controller: controller,
      errorText: errorText,
      onChanged: onChanged,
    );
  }
}

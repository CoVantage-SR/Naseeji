import 'package:flutter/material.dart';

class CompanyNameField extends StatelessWidget {
  final TextEditingController controller;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  const CompanyNameField({
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
          'اسم الشركة / المنشأة *',
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
            hintText: 'مثال: شركة النسيج العربي للغزل والنسيج',
            prefixIcon: Icon(
              Icons.domain_outlined,
              color: colorScheme.outline,
            ),
            errorText: errorText,
          ),
        ),
      ],
    );
  }
}

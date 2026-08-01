import 'package:flutter/material.dart';

class AddressField extends StatelessWidget {
  final TextEditingController controller;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  const AddressField({
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
          'العنوان التفصيلي (المنطقة الصناعية / الشارع) *',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          onChanged: onChanged,
          maxLines: 2,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            hintText: 'مثال: المنطقة الصناعية الثانية، بلوك 14، بجوار المصرف',
            prefixIcon: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Icon(
                Icons.place_outlined,
                color: colorScheme.outline,
              ),
            ),
            errorText: errorText,
          ),
        ),
      ],
    );
  }
}

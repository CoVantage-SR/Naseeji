import 'package:flutter/material.dart';
import '../../../../shared/validators/validators.dart';

class PhoneField extends StatelessWidget {
  final TextEditingController controller;
  final String selectedCountryCode;
  final ValueChanged<String> onCountryCodeChanged;

  const PhoneField({
    super.key,
    required this.controller,
    this.selectedCountryCode = '+20',
    required this.onCountryCodeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'رقم الهاتف أو البريد الإلكتروني',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: isDark ? colorScheme.onSurface : const Color(0xFF1E293B),
            fontSize: 13.5,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.emailAddress,
          textDirection: TextDirection.rtl,
          style: theme.textTheme.bodyLarge,
          decoration: InputDecoration(
            hintText: 'أدخل رقم هاتفك أو بريدك الإلكتروني',
            hintStyle: theme.textTheme.bodyMedium?.copyWith(
              color: isDark ? colorScheme.onSurfaceVariant.withValues(alpha: 0.6) : const Color(0xFF94A3B8),
              fontSize: 13,
            ),
            filled: true,
            fillColor: isDark ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.5) : Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            suffixIcon: const Icon(
              Icons.phone_outlined,
              size: 20,
            ),
            prefixIcon: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              margin: const EdgeInsets.only(left: 8),
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color: isDark ? colorScheme.outline : const Color(0xFFCBD5E1),
                  ),
                ),
              ),
              child: PopupMenuButton<String>(
                onSelected: onCountryCodeChanged,
                itemBuilder: (context) => const [
                  PopupMenuItem(value: '+20', child: Text('🇪🇬 +20 (مصر)')),
                  PopupMenuItem(value: '+966', child: Text('🇸🇦 +966 (السعودية)')),
                  PopupMenuItem(value: '+971', child: Text('🇦🇪 +971 (الإمارات)')),
                ],
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      selectedCountryCode,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Icon(Icons.arrow_drop_down, size: 18),
                  ],
                ),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark ? colorScheme.outline.withValues(alpha: 0.4) : const Color(0xFFE2E8F0),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: colorScheme.primary,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: colorScheme.error,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: colorScheme.error,
                width: 1.5,
              ),
            ),
          ),
          validator: Validators.emailOrPhone,
        ),
      ],
    );
  }
}

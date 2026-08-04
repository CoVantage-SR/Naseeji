import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import 'section_title.dart';

class VerificationMethodSelector extends StatelessWidget {
  final String selectedMethod; // 'company' | 'identity'
  final ValueChanged<String> onMethodChanged;

  const VerificationMethodSelector({
    super.key,
    required this.selectedMethod,
    required this.onMethodChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(
          title: 'التحقق من الهوية والنشاط',
          icon: Icons.verified_user_outlined,
        ),
        const SizedBox(height: 12),
        Text(
          'اختر طريقة التوثيق الأنسب لنشاطك التجاري أو مصنعك',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isDark ? colorScheme.onSurfaceVariant : const Color(0xFF64748B),
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            // Card 1: Company Verification
            Expanded(
              child: _buildMethodCard(
                context,
                title: 'توثيق شركة',
                emoji: '🏢',
                description: 'لدي سجل تجاري وبطاقة ضريبية.',
                isSelected: selectedMethod == 'company',
                onSelect: () => onMethodChanged('company'),
              ),
            ),
            const SizedBox(width: 12),

            // Card 2: Identity Verification
            Expanded(
              child: _buildMethodCard(
                context,
                title: 'توثيق بالهوية',
                emoji: '🪪',
                description: 'لا أملك أوراقاً قانونية حالياً وأرغب في التحقق بالبطاقة الشخصية.',
                isSelected: selectedMethod == 'identity',
                onSelect: () => onMethodChanged('identity'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMethodCard(
    BuildContext context, {
    required String title,
    required String emoji,
    required String description,
    required bool isSelected,
    required VoidCallback onSelect,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primary.withValues(alpha: isDark ? 0.2 : 0.08)
            : (isDark ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.3) : Colors.white),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected
              ? AppColors.primary
              : (isDark ? colorScheme.outline.withValues(alpha: 0.3) : const Color(0xFFE2E8F0)),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                emoji,
                style: const TextStyle(fontSize: 26),
              ),
              if (isSelected)
                const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.primary,
                  size: 20,
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: isDark ? colorScheme.onSurface : const Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: theme.textTheme.bodySmall?.copyWith(
              color: isDark ? colorScheme.onSurfaceVariant : const Color(0xFF64748B),
              fontSize: 11.5,
              height: 1.35,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 36,
            child: ElevatedButton(
              onPressed: onSelect,
              style: ElevatedButton.styleFrom(
                backgroundColor: isSelected ? AppColors.primary : colorScheme.surfaceContainerHighest,
                foregroundColor: isSelected ? Colors.white : colorScheme.onSurface,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              child: Text(isSelected ? 'محدد' : 'اختيار'),
            ),
          ),
        ],
      ),
    );
  }
}

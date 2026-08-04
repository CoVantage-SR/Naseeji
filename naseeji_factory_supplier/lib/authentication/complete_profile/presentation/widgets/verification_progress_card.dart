import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class VerificationProgressCard extends StatelessWidget {
  final int completionPercentage;
  final bool hasBasicInfo;
  final bool hasPhoneVerified;
  final bool hasLogo;
  final bool hasAddress;
  final bool hasCategory;
  final bool hasDocuments;
  final bool hasBankInfo;
  final bool hasWebsite;

  const VerificationProgressCard({
    super.key,
    required this.completionPercentage,
    this.hasBasicInfo = true,
    this.hasPhoneVerified = true,
    this.hasLogo = false,
    this.hasAddress = false,
    this.hasCategory = false,
    this.hasDocuments = false,
    this.hasBankInfo = false,
    this.hasWebsite = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final modules = [
      {'label': 'البيانات الأساسية', 'weight': '20%', 'done': hasBasicInfo},
      {'label': 'توثيق رقم الهاتف', 'weight': '10%', 'done': hasPhoneVerified},
      {'label': 'مستندات التوثيق والنشاط', 'weight': '25%', 'done': hasDocuments},
      {'label': 'العنوان والموقع', 'weight': '10%', 'done': hasAddress},
      {'label': 'فئة/نوع النشاط', 'weight': '10%', 'done': hasCategory},
      {'label': 'الحساب البنكي', 'weight': '10%', 'done': hasBankInfo},
      {'label': 'الشعار والصورة الشخصية', 'weight': '10%', 'done': hasLogo},
      {'label': 'الموقع الإلكتروني', 'weight': '5%', 'done': hasWebsite},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.3) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? colorScheme.outline.withValues(alpha: 0.4) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'نسبة اكتمال الملف الشخصي',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.5,
                  color: isDark ? colorScheme.onSurface : const Color(0xFF1E293B),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$completionPercentage%',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: completionPercentage / 100.0,
              minHeight: 8,
              backgroundColor: isDark ? colorScheme.surface : const Color(0xFFCBD5E1),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
          const SizedBox(height: 14),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: modules.map((m) {
              final done = m['done'] as bool;
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    done ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                    size: 14,
                    color: done ? AppColors.primary : (isDark ? colorScheme.onSurfaceVariant : Colors.grey),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${m['label']} (${m['weight']})',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: done ? FontWeight.bold : FontWeight.normal,
                      color: done
                          ? (isDark ? colorScheme.onSurface : const Color(0xFF1E293B))
                          : (isDark ? colorScheme.onSurfaceVariant : const Color(0xFF64748B)),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

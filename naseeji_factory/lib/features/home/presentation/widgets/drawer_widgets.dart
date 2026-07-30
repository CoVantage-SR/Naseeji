import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/widgets/reusable_widgets.dart';

/// 1. DrawerHeaderWidget - Title and logo area
class DrawerHeaderWidget extends StatelessWidget {
  const DrawerHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      decoration: BoxDecoration(
        color: context.theme.brightness == Brightness.dark
            ? AppColors.surfaceDark
            : AppColors.backgroundLight,
        border: Border(
          bottom: BorderSide(
            color: context.theme.brightness == Brightness.dark
                ? AppColors.borderDark
                : AppColors.borderLight,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: AppRadius.rMD,
            ),
            child: const Icon(
              Icons.blur_on_rounded,
              color: AppColors.primary,
              size: 28,
            ),
          ),
          AppSpacing.wMD,
          Text(
            'مصنع نسيجي',
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

/// 2. ProfileSummaryWidget - Summary card for logged in factory profile
class ProfileSummaryWidget extends StatelessWidget {
  final String name;
  final String legalEntity;
  final VoidCallback onTap;

  const ProfileSummaryWidget({
    super.key,
    required this.name,
    required this.legalEntity,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Row(
          children: [
            SupplierAvatar(name: name, size: 48),
            AppSpacing.wMD,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      StatusChip(
                        label: legalEntity,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 8),
                      const StatusChip(
                        label: 'موثق',
                        color: AppColors.success,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_left_rounded, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

/// 3. DrawerItemWidget - Individual menu item
class DrawerItemWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const DrawerItemWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final isDark = context.theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.rMD,
        child: Container(
          decoration: BoxDecoration(
            color: isSelected
                ? colorScheme.primary.withValues(alpha: isDark ? 0.15 : 0.05)
                : Colors.transparent,
            borderRadius: AppRadius.rMD,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected ? colorScheme.primary : Colors.grey,
                size: 22,
              ),
              AppSpacing.wMD,
              Expanded(
                child: Text(
                  title,
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? colorScheme.primary : null,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 4. LogoutButtonWidget - Themed logout action
class LogoutButtonWidget extends StatelessWidget {
  final VoidCallback onTap;

  const LogoutButtonWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: const Icon(Icons.logout_rounded, color: AppColors.error),
        label: const Text(
          'تسجيل الخروج',
          style: TextStyle(
            color: AppColors.error,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.error, width: 1.2),
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.rMD),
        ),
      ),
    );
  }
}

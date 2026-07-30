import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/widgets/app_buttons.dart';

/// 1. EstablishmentTypeCard - Selectable card for Step 1
class EstablishmentTypeCard extends StatefulWidget {
  final String title;
  final String description;
  final String emoji;
  final bool isSelected;
  final VoidCallback onTap;

  const EstablishmentTypeCard({
    super.key,
    required this.title,
    required this.description,
    required this.emoji,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<EstablishmentTypeCard> createState() => _EstablishmentTypeCardState();
}

class _EstablishmentTypeCardState extends State<EstablishmentTypeCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );
    if (widget.isSelected) {
      _animationController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(covariant EstablishmentTypeCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected != oldWidget.isSelected) {
      if (widget.isSelected) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colorScheme = context.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final selectedBg = colorScheme.primary.withValues(alpha: isDark ? 0.15 : 0.05);
    final unselectedBg = theme.cardColor;

    final selectedBorder = colorScheme.primary;
    final unselectedBorder = isDark ? AppColors.borderDark : AppColors.borderLight;

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: widget.isSelected ? selectedBg : unselectedBg,
          borderRadius: AppRadius.rLG, // Large rounded card
          border: Border.all(
            color: widget.isSelected ? selectedBorder : unselectedBorder,
            width: widget.isSelected ? 2.0 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: widget.isSelected
                  ? colorScheme.primary.withValues(alpha: 0.08)
                  : Colors.black.withValues(alpha: 0.02),
              blurRadius: widget.isSelected ? 12 : 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Emoji container
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: widget.isSelected
                    ? colorScheme.primary.withValues(alpha: 0.1)
                    : (isDark ? AppColors.backgroundDark : Colors.grey.shade100),
                borderRadius: AppRadius.rMD,
              ),
              child: Text(
                widget.emoji,
                style: const TextStyle(fontSize: 28),
              ),
            ),
            AppSpacing.wMD,
            // Title & Description
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: widget.isSelected ? colorScheme.primary : null,
                    ),
                  ),
                  AppSpacing.hXS,
                  Text(
                    widget.description,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ),
            AppSpacing.wSM,
            // Animated Check Icon
            Align(
              alignment: Alignment.center,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 2. BusinessCategoryCard - Selectable card for Step 2
class BusinessCategoryCard extends StatelessWidget {
  final String title;
  final String emoji;
  final bool isSelected;
  final VoidCallback onTap;

  const BusinessCategoryCard({
    super.key,
    required this.title,
    required this.emoji,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colorScheme = context.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final selectedBg = colorScheme.primary.withValues(alpha: isDark ? 0.15 : 0.05);
    final unselectedBg = theme.cardColor;

    final selectedBorder = colorScheme.primary;
    final unselectedBorder = isDark ? AppColors.borderDark : AppColors.borderLight;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? selectedBg : unselectedBg,
          borderRadius: AppRadius.rMD,
          border: Border.all(
            color: isSelected ? selectedBorder : unselectedBorder,
            width: isSelected ? 1.8 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? colorScheme.primary.withValues(alpha: 0.05)
                  : Colors.black.withValues(alpha: 0.01),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 24),
            ),
            AppSpacing.hXS,
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? colorScheme.primary : null,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 3. SelectedBadge - Category chip with delete action
class SelectedBadge extends StatelessWidget {
  final String label;
  final VoidCallback onDelete;

  const SelectedBadge({
    super.key,
    required this.label,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final isDark = context.theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: isDark ? 0.2 : 0.08),
        borderRadius: AppRadius.rRound,
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: context.textTheme.bodySmall?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onDelete,
            child: Icon(
              Icons.close,
              size: 14,
              color: colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

/// 4. SelectionCounter - Shows how many items are selected
class SelectionCounter extends StatelessWidget {
  final int count;

  const SelectionCounter({
    super.key,
    required this.count,
  });

  String get _counterText {
    if (count == 0) return 'لم يتم اختيار أي مجال';
    if (count == 1) return 'تم اختيار مجال واحد';
    if (count == 2) return 'تم اختيار مجالين';
    if (count >= 3 && count <= 10) return 'تم اختيار $count مجالات';
    return 'تم اختيار $count مجال';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return ScaleTransition(scale: animation, child: child);
      },
      child: Container(
        key: ValueKey<int>(count),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: count > 0
              ? colorScheme.primary.withValues(alpha: 0.1)
              : Colors.grey.withValues(alpha: 0.1),
          borderRadius: AppRadius.rSM,
        ),
        child: Text(
          _counterText,
          style: context.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: count > 0 ? colorScheme.primary : Colors.grey,
          ),
        ),
      ),
    );
  }
}

/// 5. RegistrationHeader - Reusable header
class RegistrationHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const RegistrationHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: context.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        AppSpacing.hXS,
        Text(
          subtitle,
          style: context.textTheme.bodyMedium?.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
      ],
    );
  }
}

/// 6. RegistrationProgress - Shows step progress indicator and bar
class RegistrationProgress extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const RegistrationProgress({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final theme = context.theme;
    final percent = (currentStep / totalSteps);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'الخطوة $currentStep من $totalSteps',
              style: context.textTheme.bodyMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${(percent * 100).toInt()}% مكتمل',
              style: context.textTheme.bodySmall?.copyWith(
                color: theme.brightness == Brightness.dark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
        AppSpacing.hXS,
        ClipRRect(
          borderRadius: AppRadius.rRound,
          child: LinearProgressIndicator(
            value: percent,
            color: colorScheme.primary,
            backgroundColor: theme.brightness == Brightness.dark
                ? AppColors.borderDark
                : AppColors.borderLight,
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}

/// 7. ContinueButton - Reusable Continue Button wrapping AppButton
class ContinueButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;

  const ContinueButton({
    super.key,
    this.text = 'متابعة',
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppButton.primary(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
    );
  }
}

/// 8. BackButton - Reusable Back Button wrapping AppButton
class BackButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const BackButton({
    super.key,
    this.text = 'السابق',
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppButton.secondary(
      text: text,
      onPressed: onPressed,
    );
  }
}

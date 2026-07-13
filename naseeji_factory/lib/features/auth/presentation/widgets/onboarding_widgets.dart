import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/extensions/context_extensions.dart';

class OnboardingImageWidget extends StatelessWidget {
  final IconData icon;
  final String label;

  const OnboardingImageWidget({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: AppColors.primary,
            ),
            AppSpacing.hXS,
            Text(
              label,
              style: context.textTheme.labelLarge?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingTitleWidget extends StatelessWidget {
  final String title;

  const OnboardingTitleWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: context.textTheme.headlineMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).brightness == Brightness.light
            ? AppColors.textPrimaryLight
            : AppColors.textPrimaryDark,
      ),
    );
  }
}

class OnboardingDescriptionWidget extends StatelessWidget {
  final String description;

  const OnboardingDescriptionWidget({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return Text(
      description,
      textAlign: TextAlign.center,
      style: context.textTheme.bodyLarge?.copyWith(
        color: Theme.of(context).brightness == Brightness.light
            ? AppColors.textSecondaryLight
            : AppColors.textSecondaryDark,
        height: 1.6,
      ),
    );
  }
}

class ProgressIndicatorWidget extends StatelessWidget {
  final int count;
  final int currentIndex;

  const ProgressIndicatorWidget({
    super.key,
    required this.count,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: isActive ? 24 : 8,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : AppColors.borderLight,
            borderRadius: AppRadius.rRound,
          ),
        );
      }),
    );
  }
}

class NextButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const NextButtonWidget({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(56),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.rMD,
        ),
      ),
      child: Text(
        text,
        style: context.textTheme.titleMedium?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class SkipButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;

  const SkipButtonWidget({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        'تخطي',
        style: context.textTheme.bodyMedium?.copyWith(
          color: AppColors.textSecondaryLight,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

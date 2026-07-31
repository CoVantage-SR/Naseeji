import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:naseeji_factory/core/constants/app_colors.dart';
import 'package:naseeji_factory/core/constants/app_radius.dart';
import 'package:naseeji_factory/core/extensions/context_extensions.dart';


class OnboardingImageWidget extends StatelessWidget {
  final String? imageUrl;
  final IconData fallbackIcon;
  final String label;

  const OnboardingImageWidget({
    super.key,
    required this.imageUrl,
    required this.fallbackIcon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 320,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.black.withValues(alpha: 0.05)
              : Colors.white.withValues(alpha: 0.08),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22), // slightly smaller to account for border width
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Network Image with fallback
            if (imageUrl != null && imageUrl!.isNotEmpty)
              Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Theme.of(context).brightness == Brightness.light
                        ? AppColors.borderLight.withValues(alpha: 0.3)
                        : AppColors.borderDark.withValues(alpha: 0.3),
                    child: const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return _buildFallback();
                },
              )
            else
              _buildFallback(),
            // Soft gradient overlay at the bottom to blend image with text
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.0),
                    Colors.black.withValues(alpha: 0.35),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            // Floating label tag - Glassmorphism effect
            Positioned(
              top: 16,
              right: 16,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.15),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFallback() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.15),
            AppColors.primary.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              fallbackIcon,
              size: 80,
              color: AppColors.primary,
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
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
        height: 1.3,
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOutCubic,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: isActive ? 28 : 8,
          decoration: BoxDecoration(
            gradient: isActive
                ? const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryLight],
                  )
                : null,
            color: isActive
                ? null
                : (isDark ? AppColors.borderDark : AppColors.borderLight),
            borderRadius: AppRadius.rRound,
            boxShadow: isActive ? [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ] : null,
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
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primaryLight,
          ],
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
        ),
        borderRadius: AppRadius.rMD,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          shadowColor: Colors.transparent,
          minimumSize: const Size.fromHeight(56),
          elevation: 0,
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
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(
        'تخطي',
        style: context.textTheme.bodyMedium?.copyWith(
          color: Theme.of(context).brightness == Brightness.light
              ? AppColors.textSecondaryLight
              : AppColors.textSecondaryDark,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}



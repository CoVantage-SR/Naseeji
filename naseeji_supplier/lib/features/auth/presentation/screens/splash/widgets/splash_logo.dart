import 'package:flutter/material.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';

class SplashLogo extends StatelessWidget {
  final double opacity;

  const SplashLogo({
    super.key,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 1200),
      curve: Curves.easeOut,
      opacity: opacity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            child: const Icon(
              Icons.blur_circular_rounded,
              size: 56,
              color: AppColors.surface,
            ),
          ),
          SizedBox(height: 24),
          Text(
            'Naseeji Supplier',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'منصة نسيجي للموردين والمصانع',
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
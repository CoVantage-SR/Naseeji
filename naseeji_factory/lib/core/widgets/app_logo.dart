import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final Color? color;

  const AppLogo({
    super.key,
    this.size = 64.0,
    this.showText = true,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final themeColor = color ?? Theme.of(context).primaryColor;
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.blur_on_rounded, // Premium geometric shape for textile/spinning logo
          size: size,
          color: themeColor,
        ),
        if (showText) ...[
          AppSpacing.hXS,
          Text(
            'نسيجي مصنع',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: themeColor,
                  letterSpacing: 0.5,
                ),
          ),
        ],
      ],
    );
  }
}

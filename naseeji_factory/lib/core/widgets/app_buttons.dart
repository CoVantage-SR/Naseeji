import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_radius.dart';
import '../extensions/context_extensions.dart';

enum AppButtonType {
  primary,
  secondary,
}

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final bool isLoading;
  final IconData? icon;
  final double? width;
  final double height;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = AppButtonType.primary,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height = 52.0,
  });

  const AppButton.primary({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height = 52.0,
  }) : type = AppButtonType.primary;

  const AppButton.secondary({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height = 52.0,
  }) : type = AppButtonType.secondary;

  @override
  Widget build(BuildContext context) {
    final isPrimary = type == AppButtonType.primary;
    
    final bg = isPrimary 
        ? AppColors.primary 
        : Colors.transparent;
    final fg = isPrimary 
        ? Colors.white 
        : AppColors.primary;
    final borderSide = isPrimary 
        ? BorderSide.none 
        : const BorderSide(color: AppColors.primary, width: 1.5);

    final resolvedOnPressed = (isLoading || onPressed == null) ? null : onPressed;

    Widget content = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null && !isLoading) ...[
          Icon(icon, size: 20, color: fg),
          const SizedBox(width: 8),
        ],
        if (isLoading) ...[
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: isPrimary ? Colors.white : AppColors.primary,
            ),
          ),
          const SizedBox(width: 8),
        ],
        Text(
          text,
          style: context.textTheme.titleMedium?.copyWith(
            color: fg,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: OutlinedButton(
        onPressed: resolvedOnPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          side: borderSide,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.rMD,
          ),
          disabledBackgroundColor: isPrimary 
              ? AppColors.primary.withOpacity(0.4) 
              : Colors.transparent,
        ),
        child: content,
      ),
    );
  }
}

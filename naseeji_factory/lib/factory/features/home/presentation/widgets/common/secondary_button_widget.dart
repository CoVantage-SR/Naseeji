import 'package:flutter/material.dart';
import '../../../../../../../../core/constants/app_colors.dart';
import '../../../../../../../../core/constants/app_radius.dart';

class SecondaryButtonWidget extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool fullWidth;

  const SecondaryButtonWidget({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    final buttonChild = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 18),
          const SizedBox(width: 8),
        ],
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );

    final style = OutlinedButton.styleFrom(
      foregroundColor: AppColors.primary,
      side: const BorderSide(color: AppColors.primary),
      shape: RoundedRectangleBorder(borderRadius: AppRadius.rSM),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    );

    if (fullWidth) {
      return SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: onPressed,
          style: style,
          child: buttonChild,
        ),
      );
    }

    return OutlinedButton(
      onPressed: onPressed,
      style: style,
      child: buttonChild,
    );
  }
}

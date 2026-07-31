import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_radius.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final BorderSide? borderSide;
  final VoidCallback? onTap;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16.0),
    this.color,
    this.borderSide,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cardShape = RoundedRectangleBorder(
      borderRadius: AppRadius.rMD,
      side: borderSide ??
          BorderSide(
            color: Theme.of(context).brightness == Brightness.light
                ? AppColors.borderLight
                : AppColors.borderDark,
            width: 1,
          ),
    );

    if (onTap != null) {
      return Card(
        color: color,
        shape: cardShape,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: padding,
            child: child,
          ),
        ),
      );
    }

    return Card(
      color: color,
      shape: cardShape,
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}


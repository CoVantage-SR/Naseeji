import 'package:flutter/material.dart';
import 'package:naseeji_factory/factory/core/constants/app_radius.dart';
import 'package:naseeji_factory/factory/core/extensions/context_extensions.dart';

import '../common/card_container_widget.dart';

class QuickActionItemWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const QuickActionItemWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final isDark = theme.brightness == Brightness.dark;

    return CardContainerWidget(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: isDark ? 0.2 : 0.08),
              borderRadius: AppRadius.rMD,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8.0),
          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

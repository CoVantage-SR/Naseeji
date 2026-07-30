import 'package:flutter/material.dart';
import '../../../../../../../core/constants/app_colors.dart';
import '../../../../../../../core/extensions/context_extensions.dart';
import '../../../domain/entities/home_entities.dart';
import '../common/card_container_widget.dart';

class RecommendationCardWidget extends StatelessWidget {
  final SmartRecommendation recommendation;
  final VoidCallback onTap;

  const RecommendationCardWidget({
    super.key,
    required this.recommendation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final isDark = theme.brightness == Brightness.dark;

    IconData icon = Icons.lightbulb_outline_rounded;
    Color color = AppColors.primary;

    switch (recommendation.type) {
      case 'cheaper_supplier':
        icon = Icons.local_offer_outlined;
        color = Colors.amber;
        break;
      case 'faster_delivery':
        icon = Icons.speed_rounded;
        color = AppColors.info;
        break;
      case 'trending_product':
        icon = Icons.trending_up_rounded;
        color = AppColors.success;
        break;
      case 'recommended_supplier':
        icon = Icons.thumb_up_alt_outlined;
        color = AppColors.primary;
        break;
    }

    return Container(
      width: 300,
      margin: const EdgeInsets.only(left: 12, bottom: 8, top: 4),
      child: CardContainerWidget(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: isDark ? 0.2 : 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    recommendation.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Text(
                recommendation.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.bodySmall?.copyWith(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  fontSize: 11,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                onTap: onTap,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      recommendation.actionLabel,
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    Icon(
                      Icons.chevron_left_rounded,
                      size: 16,
                      color: color,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

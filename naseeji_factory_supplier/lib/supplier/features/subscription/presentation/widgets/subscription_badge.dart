import 'package:flutter/material.dart';
import '../../domain/entities/subscription_models.dart';

class SubscriptionBadge extends StatelessWidget {
  final PlanTier tier;
  final String planName;
  final SubscriptionStatus? status;

  const SubscriptionBadge({
    super.key,
    required this.tier,
    required this.planName,
    this.status,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Color badgeColor;
    Color textColor;
    IconData badgeIcon;

    switch (tier) {
      case PlanTier.free:
        badgeColor = Colors.grey.shade200;
        textColor = Colors.grey.shade800;
        badgeIcon = Icons.card_membership;
        break;
      case PlanTier.basic:
        badgeColor = const Color(0xFFE3F2FD);
        textColor = const Color(0xFF0D47A1);
        badgeIcon = Icons.star_border;
        break;
      case PlanTier.professional:
        badgeColor = const Color(0xFFE8F5E9);
        textColor = const Color(0xFF1B5E20);
        badgeIcon = Icons.stars;
        break;
      case PlanTier.enterprise:
        badgeColor = const Color(0xFFFFF8E1);
        textColor = const Color(0xFFE65100);
        badgeIcon = Icons.workspace_premium;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: textColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(badgeIcon, size: 14, color: textColor),
          const SizedBox(width: 4),
          Text(
            planName,
            style: theme.textTheme.labelMedium?.copyWith(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (status != null) ...[
            const SizedBox(width: 6),
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: status == SubscriptionStatus.active
                    ? Colors.green
                    : Colors.orange,
              ),
            ),
          ]
        ],
      ),
    );
  }
}




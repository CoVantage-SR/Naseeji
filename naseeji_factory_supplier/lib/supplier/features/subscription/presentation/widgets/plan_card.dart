import 'package:flutter/material.dart';
import '../../domain/entities/subscription_models.dart';
import 'subscription_badge.dart';

class PlanCard extends StatelessWidget {
  final SubscriptionPlan plan;
  final bool isCurrentPlan;
  final VoidCallback? onSelectPlan;

  const PlanCard({
    super.key,
    required this.plan,
    this.isCurrentPlan = false,
    this.onSelectPlan,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: plan.isRecommended
                ? colorScheme.primary
                : (isCurrentPlan
                    ? Colors.green
                    : colorScheme.outlineVariant.withValues(alpha: 0.5)),
            width: plan.isRecommended || isCurrentPlan ? 2 : 1,
          ),
          boxShadow: [
            if (plan.isRecommended)
              BoxShadow(
                color: colorScheme.primary.withValues(alpha: 0.15),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Banner if recommended
            if (plan.isRecommended)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(14),
                    topRight: Radius.circular(14),
                  ),
                ),
                child: Text(
                  'موصى بها للموردين النموذجيين',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SubscriptionBadge(
                        tier: plan.tier,
                        planName: plan.name,
                      ),
                      if (isCurrentPlan)
                        Chip(
                          avatar: const Icon(Icons.check_circle,
                              size: 14, color: Colors.white),
                          label: const Text('باقك الحالية'),
                          backgroundColor: Colors.green.shade700,
                          labelStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                          visualDensity: VisualDensity.compact,
                          padding: EdgeInsets.zero,
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Pricing display
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        plan.price == 0 ? 'مجاناً' : '${plan.price.toInt()}',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      if (plan.price > 0) ...[
                        const SizedBox(width: 4),
                        Text(
                          'ر.س / شهرياً',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1),
                  const SizedBox(height: 16),

                  // Features Checklist
                  ...plan.features.map(
                    (feature) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            size: 16,
                            color: colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              feature,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Action Button
                  if (isCurrentPlan)
                    OutlinedButton(
                      onPressed: null,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('الباقة الحالية النشطة'),
                    )
                  else
                    FilledButton(
                      onPressed: onSelectPlan,
                      style: FilledButton.styleFrom(
                        backgroundColor: plan.isRecommended
                            ? colorScheme.primary
                            : colorScheme.secondary,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        plan.price > 0 ? 'ترقية لهذه الباقة' : 'اختيار الباقة',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



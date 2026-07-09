import 'package:flutter/material.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import 'package:naseeji_supplier/core/widgets/general_widgets.dart';
import '../../domain/entities/subscription_models.dart';

class SubscriptionPlanCard extends StatelessWidget {
  final SubscriptionPlan plan;
  final bool isCurrentPlan;
  final VoidCallback onSelect;
  final VoidCallback onCompare;

  const SubscriptionPlanCard({
    super.key,
    required this.plan,
    required this.isCurrentPlan,
    required this.onSelect,
    required this.onCompare,
  });

  @override
  Widget build(BuildContext context) {
    final hasPrice = plan.price > 0;

    return Card(
      elevation: plan.isRecommended ? 4.0 : 0.5,
      color: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: plan.isRecommended
              ? const Color(0xFF0040E0)
              : AppColors.outlineVariant.withValues(alpha: 0.3),
          width: plan.isRecommended ? 2.0 : 1.0,
        ),
      ),
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Banner for recommendation
          if (plan.isRecommended)
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF0040E0),
                borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
              ),
              padding: const EdgeInsets.symmetric(vertical: 4),
              alignment: Alignment.center,
              child: Text(
                'الباقة الموصى بها',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.surface,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (isCurrentPlan)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF006B5F).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'باقتك الحالية',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF006B5F),
                          ),
                        ),
                      )
                    else
                      const SizedBox.shrink(),
                    Text(
                      plan.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),

                // Pricing
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      ' / شهرياً',
                      style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                    SizedBox(width: 4),
                    Text(
                      hasPrice ? plan.price.toStringAsFixed(0) : 'مجاناً',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    if (hasPrice) ...[
                      SizedBox(width: 4),
                      Text(
                        'ر.س',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                      ),
                    ],
                  ],
                ),
                const Divider(height: 24, color: AppColors.outlineVariant),

                // Features lists
                Text(
                  'المزايا والحدود المتاحة:',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 8),
                ...plan.features.map(
                  (feature) => Padding(
                    padding: const EdgeInsets.only(bottom: 6.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Text(
                            feature,
                            style: TextStyle(
                              fontSize: 11,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        SizedBox(width: 8),
                        const Icon(
                          Icons.check_circle_outline,
                          size: 14,
                          color: Color(0xFF006B5F),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // Buttons
                if (isCurrentPlan)
                  PrimaryButton(
                    text: 'تفاصيل الاستهلاك الحالي',
                    onPressed: onSelect,
                  )
                else
                  PrimaryButton(
                    text: plan.price > 0 ? 'اشتراك / ترقية الباقة' : 'التحويل للباقة المجانية',
                    onPressed: onSelect,
                  ),
                SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: onCompare,
                    child: Text(
                      'مقارنة المزايا بالتفصيل',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0040E0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

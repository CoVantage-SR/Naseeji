import 'package:flutter/material.dart';
import 'package:naseeji_supplier/features/products/domain/entities/product_model.dart';

class ProductLifecycleTimelineWidget extends StatelessWidget {
  final ProductModel product;

  const ProductLifecycleTimelineWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final lifecycle = product.lifecycle;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.alt_route_rounded, color: colorScheme.primary, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'دورة حياة وتتبع مسار المنتج',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'المرحلة ${(lifecycle.currentStepIndex + 1)} من 12',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(color: colorScheme.outlineVariant.withValues(alpha: 0.4), height: 1),
          const SizedBox(height: 12),

          // Overall Lifecycle Progress Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('نسبة اكتمال دورة المعاملة', style: TextStyle(fontSize: 11, color: colorScheme.onSurfaceVariant)),
              Text(
                '${(lifecycle.progressPercentage * 100).round()}%',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: colorScheme.primary),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: lifecycle.progressPercentage,
              minHeight: 8,
              backgroundColor: colorScheme.outlineVariant.withValues(alpha: 0.3),
              valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
            ),
          ),
          const SizedBox(height: 16),

          // 12 Steps Timeline List
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: lifecycle.steps.length,
            itemBuilder: (context, index) {
              final step = lifecycle.steps[index];
              final isCompleted = step.isCompleted;
              final isCurrent = step.isCurrent;
              final isLast = index == lifecycle.steps.length - 1;

              final Color stepColor = isCompleted
                  ? const Color(0xFF2E7D32)
                  : isCurrent
                      ? colorScheme.primary
                      : colorScheme.outlineVariant;

              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Timeline Node Circle & Connector Line
                    Column(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: isCompleted
                                ? const Color(0xFF2E7D32)
                                : isCurrent
                                    ? colorScheme.primary
                                    : colorScheme.surface,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: stepColor,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: isCompleted
                                ? const Icon(Icons.check_rounded, size: 14, color: Colors.white)
                                : isCurrent
                                    ? Container(
                                        width: 8,
                                        height: 8,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                      )
                                    : Text(
                                        '${index + 1}',
                                        style: TextStyle(fontSize: 10, color: colorScheme.outline),
                                      ),
                          ),
                        ),
                        if (!isLast)
                          Expanded(
                            child: Container(
                              width: 2,
                              color: isCompleted ? const Color(0xFF2E7D32) : colorScheme.outlineVariant.withValues(alpha: 0.4),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 12),

                    // Step Title & Status Text
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 14.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              step.title,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: isCurrent || isCompleted ? FontWeight.bold : FontWeight.w500,
                                color: isCurrent
                                    ? colorScheme.primary
                                    : isCompleted
                                        ? colorScheme.onSurface
                                        : colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                              ),
                            ),
                            if (step.subtitle != null) ...[
                              const SizedBox(height: 2),
                              Text(
                                step.subtitle!,
                                style: TextStyle(fontSize: 11, color: colorScheme.outline),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

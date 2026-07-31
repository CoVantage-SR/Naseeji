import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../../../core/constants/app_colors.dart';
import '../../../../../../../../core/constants/app_radius.dart';
import '../../../../../../../../core/constants/app_spacing.dart';
import '../../../../../../../../core/extensions/context_extensions.dart';
import '../../../../../../../../core/widgets/reusable_widgets.dart';
import '../../providers/production_capacity_provider.dart';

/// Displays supplier production capacity with a utilization progress bar.
/// Reads data from [productionCapacityProvider].
class ProductionCapacityWidget extends ConsumerWidget {
  final String productId;

  const ProductionCapacityWidget({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(productionCapacityProvider(productId: productId));
    final isDark = context.theme.brightness == Brightness.dark;

    return state.when(
      loading: () => const SizedBox(height: 80, child: Center(child: CircularProgressIndicator())),
      error: (_, _) => const SizedBox.shrink(),
      data: (capacity) {
        final utilizationPercent = (capacity.currentUtilization * 100).toInt();
        final utilizationColor = capacity.currentUtilization > 0.85
            ? AppColors.error
            : capacity.currentUtilization > 0.6
                ? AppColors.warning
                : AppColors.success;

        return PrimaryCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.factory_rounded, color: AppColors.primary, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'الطاقة الإنتاجية',
                    style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              AppSpacing.hMD,
              Row(
                children: [
                  Expanded(
                    child: _CapacityStat(
                      label: 'الطاقة اليومية',
                      value: '${capacity.dailyCapacity}',
                      unit: capacity.unit,
                      isDark: isDark,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _CapacityStat(
                      label: 'الطاقة الشهرية',
                      value: '${capacity.monthlyCapacity}',
                      unit: capacity.unit,
                      isDark: isDark,
                    ),
                  ),
                ],
              ),
              AppSpacing.hMD,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'معدل الإشغال الحالي',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: utilizationColor.withValues(alpha: 0.1),
                      borderRadius: AppRadius.rRound,
                      border: Border.all(color: utilizationColor.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      '$utilizationPercent%',
                      style: TextStyle(color: utilizationColor, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: AppRadius.rRound,
                child: LinearProgressIndicator(
                  value: capacity.currentUtilization,
                  color: utilizationColor,
                  backgroundColor: isDark ? AppColors.borderDark : AppColors.borderLight,
                  minHeight: 8,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CapacityStat extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final bool isDark;

  const _CapacityStat({
    required this.label,
    required this.value,
    required this.unit,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.textTheme.bodySmall?.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
        const SizedBox(height: 4),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: value,
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
              TextSpan(
                text: ' $unit',
                style: context.textTheme.bodySmall?.copyWith(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

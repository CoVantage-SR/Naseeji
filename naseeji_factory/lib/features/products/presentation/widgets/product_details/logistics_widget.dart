import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../../core/constants/app_colors.dart';
import '../../../../../../../core/constants/app_radius.dart';
import '../../../../../../../core/constants/app_spacing.dart';
import '../../../../../../../core/extensions/context_extensions.dart';
import '../../../../../../../core/widgets/reusable_widgets.dart';
import '../../providers/logistics_provider.dart';

/// Displays Naseeji Logistics delivery information.
///
/// Business rules enforced by the repository layer:
/// - Carrier is ALWAYS "ناصيجي لوجستيك"
/// - SLA is ALWAYS 48 hours
/// - External shipping companies are NEVER displayed.
class LogisticsWidget extends ConsumerWidget {
  final String productId;

  const LogisticsWidget({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(logisticsInfoProvider(productId: productId));
    final isDark = context.theme.brightness == Brightness.dark;

    return state.when(
      loading: () => const SizedBox(height: 80, child: Center(child: CircularProgressIndicator())),
      error: (_, _) => const SizedBox.shrink(),
      data: (logistics) => PrimaryCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.local_shipping_rounded, color: AppColors.primary, size: 18),
                const SizedBox(width: 8),
                Text(
                  'الشحن والتوصيل',
                  style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            AppSpacing.hMD,
            // Carrier badge — always Naseeji Logistics
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: isDark ? 0.15 : 0.06),
                borderRadius: AppRadius.rMD,
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.verified_rounded, color: AppColors.primary, size: 18),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        logistics.carrier,
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                      ),
                      Text(
                        'شريك اللوجستيك الرسمي لمنصة ناصيجي',
                        style: context.textTheme.bodySmall?.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            AppSpacing.hMD,
            // SLA badge
            Row(
              children: [
                _InfoBadge(
                  icon: Icons.timer_rounded,
                  label: 'ضمان الشحن',
                  value: 'خلال ${logistics.slaHours} ساعة',
                  color: AppColors.success,
                  isDark: isDark,
                ),
                const SizedBox(width: 10),
                _InfoBadge(
                  icon: Icons.local_offer_rounded,
                  label: 'شحن مجاني فوق',
                  value: '${logistics.freeShippingThreshold.toInt()} ج.م',
                  color: AppColors.secondary,
                  isDark: isDark,
                ),
              ],
            ),
            AppSpacing.hMD,
            Text(
              'مناطق التغطية',
              style: context.textTheme.bodySmall?.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: logistics.coverageZones
                  .map((zone) => StatusChip(label: zone, color: AppColors.primary))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final bool isDark;

  const _InfoBadge({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: isDark ? 0.15 : 0.07),
          borderRadius: AppRadius.rMD,
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(height: 4),
            Text(label, style: context.textTheme.labelSmall?.copyWith(color: Colors.grey)),
            Text(value, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

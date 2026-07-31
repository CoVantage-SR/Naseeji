import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naseeji_factory/core/constants/app_colors.dart';
import 'package:naseeji_factory/core/constants/app_radius.dart';
import 'package:naseeji_factory/core/constants/app_spacing.dart';
import 'package:naseeji_factory/core/extensions/context_extensions.dart';
import 'package:naseeji_factory/core/widgets/reusable_widgets.dart';

import '../../providers/sample_provider.dart';

/// Displays physical sample ordering information with a request button.
/// Reads data from [sampleInfoProvider].
class SampleWidget extends ConsumerWidget {
  final String productId;
  final VoidCallback onRequestSample;

  const SampleWidget({super.key, required this.productId, required this.onRequestSample});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sampleInfoProvider(productId: productId));
    final isDark = context.theme.brightness == Brightness.dark;

    return state.when(
      loading: () => const SizedBox(height: 60, child: Center(child: CircularProgressIndicator())),
      error: (_, _) => const SizedBox.shrink(),
      data: (sample) {
        if (!sample.isAvailable) return const SizedBox.shrink();

        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.secondary.withValues(alpha: isDark ? 0.12 : 0.07),
            borderRadius: AppRadius.rMD,
            border: Border.all(color: AppColors.secondary.withValues(alpha: 0.25)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.colorize_rounded, color: AppColors.secondary, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'طلب عينة فعلية',
                    style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  StatusChip(label: 'متاحة', color: AppColors.success),
                ],
              ),
              AppSpacing.hMD,
              Row(
                children: [
                  _SampleDetail(
                    icon: Icons.attach_money_rounded,
                    label: 'سعر العينة',
                    value: '${sample.pricePerSample.toInt()} ج.م',
                    isDark: isDark,
                  ),
                  const SizedBox(width: 12),
                  _SampleDetail(
                    icon: Icons.schedule_rounded,
                    label: 'موعد التسليم',
                    value: 'خلال ${sample.sampleDeliveryDays} أيام',
                    isDark: isDark,
                  ),
                ],
              ),
              if (sample.requiresDeposit) ...[
                AppSpacing.hMD,
                Row(
                  children: [
                    const Icon(Icons.info_outline_rounded, size: 14, color: AppColors.warning),
                    const SizedBox(width: 6),
                    Text(
                      'يتطلب دفع عربون مقدم',
                      style: context.textTheme.bodySmall?.copyWith(color: AppColors.warning),
                    ),
                  ],
                ),
              ],
              AppSpacing.hMD,
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: onRequestSample,
                  icon: const Icon(Icons.science_outlined, size: 18),
                  label: const Text('طلب عينة للفحص'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.secondary,
                    side: const BorderSide(color: AppColors.secondary),
                    shape: RoundedRectangleBorder(borderRadius: AppRadius.rMD),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SampleDetail extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isDark;

  const _SampleDetail({required this.icon, required this.label, required this.value, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, size: 14, color: AppColors.secondary),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: context.textTheme.labelSmall?.copyWith(color: Colors.grey)),
                Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}




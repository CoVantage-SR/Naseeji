import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naseeji_factory/factory/core/constants/app_colors.dart';
import 'package:naseeji_factory/factory/core/constants/app_radius.dart';
import 'package:naseeji_factory/factory/core/constants/app_spacing.dart';
import 'package:naseeji_factory/factory/core/extensions/context_extensions.dart';
import 'package:naseeji_factory/factory/core/widgets/reusable_widgets.dart';

import '../../providers/procurement_timeline_provider.dart';
import '../../../domain/entities/product_detail_entities.dart';

/// Displays the full 24-step procurement timeline.
/// Shows the active step highlighted. Collapsed to 5 steps by default.
/// Reads data from [procurementTimelineProvider].
class ProcurementTimelineWidget extends ConsumerStatefulWidget {
  final String productId;

  const ProcurementTimelineWidget({super.key, required this.productId});

  @override
  ConsumerState<ProcurementTimelineWidget> createState() => _ProcurementTimelineWidgetState();
}

class _ProcurementTimelineWidgetState extends ConsumerState<ProcurementTimelineWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(procurementTimelineProvider(productId: widget.productId));
    final isDark = context.theme.brightness == Brightness.dark;

    return state.when(
      loading: () => const SizedBox(height: 80, child: Center(child: CircularProgressIndicator())),
      error: (_, _) => const SizedBox.shrink(),
      data: (stages) {
        final completedCount = stages.where((s) => s.isCompleted).length;
        final activeStep = stages.firstWhere((s) => s.isActive, orElse: () => stages.last);
        final displayedStages = _isExpanded ? stages : _getCollapsedStages(stages);

        return PrimaryCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.timeline_rounded, color: AppColors.primary, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'مسار الطلب والتوريد',
                    style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: AppRadius.rRound,
                    ),
                    child: Text(
                      '$completedCount / ${stages.length}',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              AppSpacing.hXS,
              // Progress summary
              Text(
                'المرحلة الحالية: ${activeStep.label}',
                style: context.textTheme.bodySmall?.copyWith(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                ),
              ),
              AppSpacing.hMD,
              // Timeline steps
              ...displayedStages.map((stage) => _StageRow(stage: stage, isLast: stage == displayedStages.last)),
              // Expand/Collapse toggle
              if (stages.length > 5) ...[
                AppSpacing.hMD,
                InkWell(
                  onTap: () => setState(() => _isExpanded = !_isExpanded),
                  borderRadius: AppRadius.rMD,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.borderDark : Colors.grey.shade100,
                      borderRadius: AppRadius.rMD,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _isExpanded ? Icons.expand_less_rounded : Icons.expand_more_rounded,
                          size: 18,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _isExpanded ? 'إخفاء المراحل' : 'عرض كل ${stages.length} مراحل',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  /// Returns stages around the active step when collapsed: last 2 completed + active + next 2
  List<ProcurementStage> _getCollapsedStages(List<ProcurementStage> stages) {
    final activeIdx = stages.indexWhere((s) => s.isActive);
    if (activeIdx == -1) return stages.take(5).toList();
    final start = (activeIdx - 2).clamp(0, stages.length - 1);
    final end = (activeIdx + 3).clamp(0, stages.length);
    return stages.sublist(start, end);
  }
}

class _StageRow extends StatelessWidget {
  final ProcurementStage stage;
  final bool isLast;

  const _StageRow({required this.stage, required this.isLast});

  Color get _color {
    if (stage.isCompleted) return AppColors.success;
    if (stage.isActive) return AppColors.primary;
    return Colors.grey;
  }

  IconData get _icon {
    if (stage.isCompleted) return Icons.check_circle_rounded;
    if (stage.isActive) return Icons.radio_button_checked_rounded;
    return Icons.radio_button_unchecked_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: _color.withValues(alpha: stage.isPending ? 0.06 : (isDark ? 0.2 : 0.12)),
                shape: BoxShape.circle,
                border: Border.all(color: _color.withValues(alpha: stage.isPending ? 0.2 : 0.4), width: 1.5),
              ),
              child: Icon(_icon, color: _color, size: 14),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 36,
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${stage.step}. ${stage.label}',
                        style: context.textTheme.bodySmall?.copyWith(
                          fontWeight: stage.isActive ? FontWeight.bold : FontWeight.normal,
                          color: stage.isPending
                              ? (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)
                              : null,
                        ),
                      ),
                    ),
                    if (stage.completedAt != null)
                      Text(
                        stage.completedAt!,
                        style: context.textTheme.bodySmall?.copyWith(color: Colors.grey, fontSize: 10),
                      ),
                    if (stage.isActive)
                      Container(
                        margin: const EdgeInsets.only(right: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: AppRadius.rRound,
                        ),
                        child: const Text('الآن', style: TextStyle(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

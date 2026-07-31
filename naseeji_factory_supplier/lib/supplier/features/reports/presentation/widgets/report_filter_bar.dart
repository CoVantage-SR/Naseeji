// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naseeji_factory/supplier/core/theme/app_colors.dart';
import '../../../dashboard/presentation/controllers/analytics_report_controller.dart';

class ReportFilterBar extends ConsumerStatefulWidget {
  final bool showExport;
  final VoidCallback? onExportPdf;
  final VoidCallback? onExportExcel;
  final VoidCallback? onExportCsv;

  const ReportFilterBar({
    super.key,
    this.showExport = true,
    this.onExportPdf,
    this.onExportExcel,
    this.onExportCsv,
  });

  @override
  ConsumerState<ReportFilterBar> createState() => _ReportFilterBarState();
}

class _ReportFilterBarState extends ConsumerState<ReportFilterBar> {
  static const _filterOptions = <DateFilterType, String>{
    DateFilterType.today: 'اليوم',
    DateFilterType.yesterday: 'أمس',
    DateFilterType.last7Days: 'آخر 7 أيام',
    DateFilterType.last30Days: 'آخر 30 يوم',
    DateFilterType.last3Months: 'آخر 3 أشهر',
    DateFilterType.last6Months: 'آخر 6 أشهر',
    DateFilterType.currentYear: 'هذا العام',
    DateFilterType.custom: 'نطاق مخصص',
  };

  Future<void> _pickCustomRange(BuildContext context, ReportFilter current) async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 2),
      lastDate: now,
      initialDateRange: current.startDate != null && current.endDate != null
          ? DateTimeRange(start: current.startDate!, end: current.endDate!)
          : null,
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: Theme.of(ctx).colorScheme.copyWith(primary: AppColors.primary),
        ),
        child: child!,
      ),
    );
    if (!mounted) return;
    if (picked != null) {
      ref.read(analyticsReportFilterProvider.notifier).updateFilter(
            current.copyWith(
              dateFilter: DateFilterType.custom,
              startDate: picked.start,
              endDate: picked.end,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final filter = ref.watch(analyticsReportFilterProvider);
    final selectedLabel = _filterOptions[filter.dateFilter] ?? 'آخر 30 يوم';

    return Row(
      children: [
        if (widget.showExport) ...[
          _ExportButton(
            label: 'PDF',
            icon: Icons.picture_as_pdf,
            color: AppColors.primary,
            onTap: widget.onExportPdf ?? () => _showExportSnack(context, 'PDF'),
          ),
          const SizedBox(width: 6),
          _ExportButton(
            label: 'Excel',
            icon: Icons.table_chart_outlined,
            color: AppColors.secondary,
            onTap: widget.onExportExcel ?? () => _showExportSnack(context, 'Excel'),
          ),
          const SizedBox(width: 6),
          _ExportButton(
            label: 'CSV',
            icon: Icons.download_outlined,
            color: const Color(0xFF5E35B1),
            onTap: widget.onExportCsv ?? () => _showExportSnack(context, 'CSV'),
          ),
          const SizedBox(width: 8),
        ],
        Expanded(
          child: GestureDetector(
            onTap: () async {
              if (filter.dateFilter == DateFilterType.custom) {
                await _pickCustomRange(context, filter);
                return;
              }
              final chosen = await showModalBottomSheet<DateFilterType>(
                context: context,
                backgroundColor: Colors.transparent,
                builder: (_) => _FilterPicker(
                  options: _filterOptions,
                  selected: filter.dateFilter,
                ),
              );
              if (!mounted) return;
              if (chosen != null) {
                if (chosen == DateFilterType.custom) {
                  await _pickCustomRange(context, filter);
                } else {
                  ref.read(analyticsReportFilterProvider.notifier).updateFilter(
                        filter.copyWith(dateFilter: chosen, startDate: null, endDate: null),
                      );
                }
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.5)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.keyboard_arrow_down, color: AppColors.outline, size: 18),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.primary),
                      const SizedBox(width: 6),
                      Text(
                        selectedLabel,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showExportSnack(BuildContext context, String format) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('جاري تصدير التقرير بصيغة $format...'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class _ExportButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ExportButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: Colors.white),
            const SizedBox(width: 4),
            Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}

class _FilterPicker extends StatelessWidget {
  final Map<DateFilterType, String> options;
  final DateFilterType selected;

  const _FilterPicker({required this.options, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Text(
              'اختر الفترة الزمنية',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
            ),
          ),
          const Divider(height: 1),
          ...options.entries.map((entry) {
            final isSelected = entry.key == selected;
            return ListTile(
              onTap: () => Navigator.pop(context, entry.key),
              trailing: Text(
                entry.value,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? AppColors.primary : Theme.of(context).colorScheme.onSurface,
                ),
              ),
              leading: isSelected
                  ? const Icon(Icons.check_circle, color: AppColors.primary, size: 20)
                  : const Icon(Icons.radio_button_unchecked, color: AppColors.outline, size: 20),
            );
          }),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}


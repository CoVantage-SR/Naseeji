import 'package:flutter/material.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../../domain/entities/marketing_models.dart';

class AdvertisementCard extends StatelessWidget {
  final B2BAdvertisement ad;
  final VoidCallback onView;
  final VoidCallback onPauseToggle;
  final VoidCallback onDelete;

  const AdvertisementCard({
    super.key,
    required this.ad,
    required this.onView,
    required this.onPauseToggle,
    required this.onDelete,
  });

  Color _getStatusColor(AdStatus status) {
    switch (status) {
      case AdStatus.active:
        return const Color(0xFF006B5F);
      case AdStatus.scheduled:
        return const Color(0xFF0040E0);
      case AdStatus.pendingReview:
        return const Color(0xFFFF9800);
      case AdStatus.paused:
        return AppColors.outline;
      case AdStatus.completed:
        return const Color(0xFF673AB7);
      case AdStatus.rejected:
        return const Color(0xFFBA1A1A);
    }
  }

  String _getStatusText(AdStatus status) {
    switch (status) {
      case AdStatus.active:
        return 'نشط';
      case AdStatus.scheduled:
        return 'مجدول';
      case AdStatus.pendingReview:
        return 'قيد المراجعة';
      case AdStatus.paused:
        return 'موقوف مؤقتاً';
      case AdStatus.completed:
        return 'مكتمل';
      case AdStatus.rejected:
        return 'مرفوض';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ListTile(
            onTap: onView,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(ad.status).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    _getStatusText(ad.status),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: _getStatusColor(ad.status),
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    ad.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSurface,
                    ),
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                'المنتج: ${ad.productName} | الحملة: ${ad.campaignName}',
                style: const TextStyle(fontSize: 10, color: AppColors.onSurfaceVariant),
                textAlign: TextAlign.right,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Divider(height: 1, color: AppColors.outlineVariant),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildMetricsColumn('نسبة النقر CTR', '${ad.ctr.toStringAsFixed(2)}%'),
                _buildMetricsColumn('النقرات', '${ad.clicks}'),
                _buildMetricsColumn('الوصول', '${ad.reach}'),
                _buildMetricsColumn('الإيرادات', '${ad.revenue.toStringAsFixed(0)} ر.س'),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: AppColors.surfaceContainerLow,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 18, color: Color(0xFFBA1A1A)),
                      onPressed: onDelete,
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.zero,
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      icon: Icon(
                        ad.status == AdStatus.active ? Icons.pause_circle_outline : Icons.play_circle_outline,
                        size: 18,
                        color: ad.status == AdStatus.active ? const Color(0xFFFF9800) : const Color(0xFF006B5F),
                      ),
                      onPressed: onPauseToggle,
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
                Text(
                  'الميزانية المتبقية: ${ad.remainingBudget.toStringAsFixed(0)} ر.س / ${ad.budget.toStringAsFixed(0)} ر.س',
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsColumn(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 9, color: AppColors.onSurfaceVariant)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
      ],
    );
  }
}

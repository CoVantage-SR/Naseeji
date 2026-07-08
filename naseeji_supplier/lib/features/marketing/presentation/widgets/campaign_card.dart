import 'package:flutter/material.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../../domain/entities/marketing_models.dart';

class CampaignCard extends StatelessWidget {
  final MarketingCampaign campaign;
  final VoidCallback onView;
  final VoidCallback? onPauseToggle;

  const CampaignCard({
    super.key,
    required this.campaign,
    required this.onView,
    this.onPauseToggle,
  });

  Color _getStatusColor(CampaignStatus status) {
    switch (status) {
      case CampaignStatus.active:
        return const Color(0xFF006B5F);
      case CampaignStatus.scheduled:
        return const Color(0xFF0040E0);
      case CampaignStatus.completed:
        return AppColors.outline;
      case CampaignStatus.paused:
        return const Color(0xFFFF9800);
    }
  }

  String _getStatusText(CampaignStatus status) {
    switch (status) {
      case CampaignStatus.active:
        return 'نشط';
      case CampaignStatus.scheduled:
        return 'مجدول';
      case CampaignStatus.completed:
        return 'مكتمل';
      case CampaignStatus.paused:
        return 'موقوف مؤقتاً';
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
      child: InkWell(
        onTap: onView,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(campaign.status).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      _getStatusText(campaign.status),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: _getStatusColor(campaign.status),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      campaign.name,
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
              const SizedBox(height: 8),
              Text(
                campaign.objective,
                style: const TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant),
                textAlign: TextAlign.right,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: Divider(height: 1, color: AppColors.outlineVariant),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildMetricItem('عائد الإعلانات (ROAS)', '${campaign.roas.toStringAsFixed(1)}x'),
                  _buildMetricItem('الإيرادات المحققة', '${campaign.revenue.toStringAsFixed(0)} ر.س'),
                  _buildMetricItem('الميزانية', '${campaign.budget.toStringAsFixed(0)} ر.س'),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'المنتجات المشمولة: ${campaign.productsCount}',
                    style: const TextStyle(fontSize: 10, color: AppColors.onSurfaceVariant),
                  ),
                  Text(
                    'المدة: ${campaign.durationDays} يوم',
                    style: const TextStyle(fontSize: 10, color: AppColors.onSurfaceVariant),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(label, style: const TextStyle(fontSize: 9, color: AppColors.onSurfaceVariant)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
      ],
    );
  }
}

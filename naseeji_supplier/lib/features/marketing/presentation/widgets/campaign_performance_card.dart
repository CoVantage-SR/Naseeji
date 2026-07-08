import 'package:flutter/material.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../../domain/entities/marketing_models.dart';

class CampaignPerformanceCard extends StatelessWidget {
  final MarketingCampaign campaign;

  const CampaignPerformanceCard({
    super.key,
    required this.campaign,
  });

  @override
  Widget build(BuildContext context) {
    final double aov = campaign.orders > 0 ? (campaign.revenue / campaign.orders) : 0.0;
    final double conversionRate = campaign.reach > 0 ? (campaign.orders / campaign.reach) * 100 : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text(
            'مؤشرات الأداء الرئيسية للحملة',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.onSurface),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildPerformanceItem('نسبة النقر CTR', '${campaign.ctr.toStringAsFixed(2)}%'),
              _buildPerformanceItem('النقرات', '${campaign.clicks}'),
              _buildPerformanceItem('الوصول للمصانع', '${campaign.reach}'),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: Divider(color: AppColors.outlineVariant),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildPerformanceItem('نسبة التحويل', '${conversionRate.toStringAsFixed(2)}%'),
              _buildPerformanceItem('الطلبات المستلمة', '${campaign.orders}'),
              _buildPerformanceItem('الإيرادات الناتجة', '${campaign.revenue.toStringAsFixed(0)} ر.س'),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: Divider(color: AppColors.outlineVariant),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildPerformanceItem('معدل الطلب AOV', '${aov.toStringAsFixed(0)} ر.س'),
              _buildPerformanceItem('الإنفاق الكلي', '${campaign.spent.toStringAsFixed(0)} ر.س'),
              _buildPerformanceItem('العائد ROAS', '${campaign.roas.toStringAsFixed(1)}x', isHighlight: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceItem(String label, String value, {bool isHighlight = false}) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 9, color: AppColors.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: isHighlight ? const Color(0xFF006B5F) : AppColors.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

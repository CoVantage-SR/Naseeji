import 'package:flutter/material.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';

class ProductSubscriptionStatus extends StatelessWidget {
  final String planName;
  final bool hasPublishPermission;
  final String adStatus;
  final String featuredStatus;
  final int promoDaysRemaining;
  final double storageUsed;
  final double maxStorage;

  const ProductSubscriptionStatus({
    super.key,
    required this.planName,
    required this.hasPublishPermission,
    required this.adStatus,
    required this.featuredStatus,
    required this.promoDaysRemaining,
    required this.storageUsed,
    required this.maxStorage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'حالة هذا المنتج في الباقة والمبيعات B2B',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
          ),
          const Divider(height: 20, color: AppColors.outlineVariant),
          _buildInfoRow('باقة الاشتراك الحالية', planName),
          _buildInfoRow('صلاحية النشر والبيع', hasPublishPermission ? 'نشطة ومصرحة' : 'معطلة (تجاوز الحدود)'),
          _buildInfoRow('حالة الترويج الإعلاني بالمنصة', adStatus),
          _buildInfoRow('حالة رعاية المنتج ووضعه بالصدارة', featuredStatus),
          _buildInfoRow('الأيام المتبقية للتمييز الممتاز', '$promoDaysRemaining يوم'),
          _buildInfoRow('مساحة الصور والملفات الفنية المستهلكة', '${storageUsed.toStringAsFixed(2)} ميجابايت / ${maxStorage.toStringAsFixed(0)} ميجابايت'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            value,
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.onSurface),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
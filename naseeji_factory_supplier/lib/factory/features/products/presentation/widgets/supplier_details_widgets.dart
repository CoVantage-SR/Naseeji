import 'package:flutter/material.dart';
import 'package:naseeji_factory/core/constants/app_colors.dart';
import 'package:naseeji_factory/core/constants/app_radius.dart';
import 'package:naseeji_factory/core/constants/app_spacing.dart';
import 'package:naseeji_factory/core/extensions/context_extensions.dart';
import 'package:naseeji_factory/core/widgets/reusable_widgets.dart';

import '../providers/suppliers_provider.dart';

/// 1. SupplierHeaderWidget
class SupplierHeaderWidget extends StatelessWidget {
  final Supplier supplier;

  const SupplierHeaderWidget({super.key, required this.supplier});

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;

    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          clipBehavior: Clip.none,
          children: [
            // Banner Background
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.secondary, AppColors.secondaryLight],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
              ),
            ),
            // Avatar Overlay
            Positioned(
              bottom: -40,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDark ? AppColors.backgroundDark : Colors.white,
                    width: 4,
                  ),
                ),
                child: SupplierAvatar(name: supplier.name, size: 80),
              ),
            ),
          ],
        ),
        const SizedBox(height: 52),
        Text(
          supplier.name,
          style: context.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StatusChip(label: supplier.type, color: AppColors.primary),
            const SizedBox(width: 8),
            if (supplier.isVerified)
              const StatusChip(label: 'مورد موثق ✅', color: AppColors.success)
            else
              const StatusChip(label: 'مورد نشط', color: AppColors.info),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_on_outlined, color: Colors.grey, size: 14),
            const SizedBox(width: 4),
            Text(
              '${supplier.city}، ${supplier.governorate}',
              style: context.textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }
}

/// 2. CompanyInformationWidget
class CompanyInformationWidget extends StatelessWidget {
  final Supplier supplier;

  const CompanyInformationWidget({super.key, required this.supplier});

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;

    return PrimaryCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'نبذة عن الشركة',
            style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          AppSpacing.hMD,
          Text(
            supplier.description,
            style: context.textTheme.bodyMedium?.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
          ),
          const Divider(height: 24),
          _buildDetailRow('سنوات الخبرة', supplier.experience, Icons.history_rounded),
          const SizedBox(height: 12),
          _buildDetailRow('معدل الالتزام بالتسليم', supplier.deliveryPerformance, Icons.local_shipping_outlined),
          const SizedBox(height: 12),
          _buildDetailRow('سرعة الاستجابة للرسائل', supplier.responseSpeed, Icons.speed_rounded),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 18),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

/// 3. SupplierStatisticsWidget
class SupplierStatisticsWidget extends StatelessWidget {
  final Supplier supplier;

  const SupplierStatisticsWidget({super.key, required this.supplier});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: StatisticsCard(
            label: 'تقييم الجودة',
            value: '${supplier.rating} ⭐',
            icon: Icons.star_rounded,
            color: Colors.amber,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: StatisticsCard(
            label: 'إجمالي المنتجات',
            value: supplier.productsCount.toString(),
            icon: Icons.shopping_bag_outlined,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: StatisticsCard(
            label: 'طلبات مكتملة',
            value: '${supplier.completedOrders}+',
            icon: Icons.check_circle_outline_rounded,
            color: AppColors.success,
          ),
        ),
      ],
    );
  }
}

/// 4. CertificatesWidget
class CertificatesWidget extends StatelessWidget {
  final List<String> certificates;

  const CertificatesWidget({super.key, required this.certificates});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Text(
            'شهادات الجودة والاعتماد',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
              fontSize: 14,
            ),
          ),
        ),
        AppSpacing.hSM,
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: certificates.map((cert) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.08),
                borderRadius: AppRadius.rRound,
                border: Border.all(
                  color: AppColors.secondary.withValues(alpha: 0.15),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.workspace_premium_outlined, color: AppColors.secondary, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    cert,
                    style: const TextStyle(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}




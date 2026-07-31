import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/reusable_widgets.dart';
import '../providers/suppliers_provider.dart';

/// 1. SuppliersHeaderWidget
class SuppliersHeaderWidget extends StatelessWidget {
  final int totalCount;

  const SuppliersHeaderWidget({super.key, required this.totalCount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'الشركاء والموردين المعتمدين',
                style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 2),
              Text(
                'تواصل مباشرة مع كبار مصانع الغزل والنسيج في مصر.',
                style: context.textTheme.bodySmall?.copyWith(color: Colors.grey, fontSize: 10),
              ),
            ],
          ),
          StatusChip(label: '$totalCount مورد', color: AppColors.primary),
        ],
      ),
    );
  }
}

/// 2. SupplierCardWidget
class SupplierCardWidget extends StatelessWidget {
  final Supplier supplier;
  final VoidCallback onFavoriteTap;
  final VoidCallback onViewProfile;
  final bool isSelectedForComparison;
  final VoidCallback onComparisonToggle;

  const SupplierCardWidget({
    super.key,
    required this.supplier,
    required this.onFavoriteTap,
    required this.onViewProfile,
    required this.isSelectedForComparison,
    required this.onComparisonToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;

    return PrimaryCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SupplierAvatar(name: supplier.name, size: 56),
              AppSpacing.wMD,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            supplier.name,
                            style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        if (supplier.isVerified) const StatusChip(label: 'موثق', color: AppColors.success),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      supplier.type,
                      style: context.textTheme.bodySmall?.copyWith(color: Colors.grey, fontSize: 11),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  supplier.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  color: supplier.isFavorite ? AppColors.error : Colors.grey,
                ),
                onPressed: onFavoriteTap,
              ),
            ],
          ),
          AppSpacing.hMD,
          // Stats Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem('التقييم', '${supplier.rating} ⭐', isDark),
              _buildStatItem('المنتجات', '${supplier.productsCount} منتج', isDark),
              _buildStatItem('الطلبات المكتملة', '${supplier.completedOrders}+ طلب', isDark),
              _buildStatItem('الموقع', supplier.city, isDark),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 12),
          // Actions Row
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onViewProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: AppRadius.rMD),
                  ),
                  child: const Text('عرض الملف الشخصي'),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: onComparisonToggle,
                icon: Icon(
                  isSelectedForComparison ? Icons.check_circle_rounded : Icons.compare_arrows_rounded,
                  size: 16,
                ),
                label: Text(isSelectedForComparison ? 'محدد للمقارنة' : 'قارن'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: isSelectedForComparison ? AppColors.success : AppColors.primary,
                  side: BorderSide(
                    color: isSelectedForComparison ? AppColors.success : AppColors.primary,
                  ),
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.rMD),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

/// 3. SortWidget
class SortWidget extends StatelessWidget {
  final String activeSort;
  final ValueChanged<String> onSortChanged;

  const SortWidget({
    super.key,
    required this.activeSort,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          const Text(
            'ترتيب حسب: ',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(width: 8),
          _buildChip('الأعلى تقييماً', 'rating'),
          const SizedBox(width: 8),
          _buildChip('الأكثر مبيعاً', 'orders'),
          const SizedBox(width: 8),
          _buildChip('عدد المنتجات', 'products'),
        ],
      ),
    );
  }

  Widget _buildChip(String label, String key) {
    final isSelected = activeSort == key;
    return ChoiceChip(
      label: Text(label, style: const TextStyle(fontSize: 11)),
      selected: isSelected,
      onSelected: (_) => onSortChanged(key),
      selectedColor: AppColors.primary.withValues(alpha: 0.1),
      labelStyle: TextStyle(
        color: isSelected ? AppColors.primary : Colors.grey,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.rRound,
        side: BorderSide(color: isSelected ? AppColors.primary : Colors.grey.shade300),
      ),
      showCheckmark: false,
    );
  }
}


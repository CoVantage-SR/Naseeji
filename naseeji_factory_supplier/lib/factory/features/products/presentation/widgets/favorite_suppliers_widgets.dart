import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/reusable_widgets.dart';
import '../providers/suppliers_provider.dart';

/// 1. FavoriteSupplierCardWidget
class FavoriteSupplierCardWidget extends StatelessWidget {
  final Supplier supplier;
  final VoidCallback onSendRfq;
  final VoidCallback onRemove;

  const FavoriteSupplierCardWidget({
    super.key,
    required this.supplier,
    required this.onSendRfq,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return PrimaryCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SupplierAvatar(name: supplier.name, size: 44),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      supplier.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    Text(
                      supplier.type,
                      style: const TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error),
                tooltip: 'إزالة من المفضلة',
                onPressed: onRemove,
              ),
            ],
          ),
          if (supplier.favoriteCategory != null || supplier.favoriteNote != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.05),
                borderRadius: AppRadius.rMD,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (supplier.favoriteCategory != null && supplier.favoriteCategory!.isNotEmpty)
                    Text(
                      'تصنيف المفضلة: ${supplier.favoriteCategory}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.primary),
                    ),
                  if (supplier.favoriteNote != null && supplier.favoriteNote!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      'ملاحظة: ${supplier.favoriteNote}',
                      style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic),
                    ),
                  ],
                ],
              ),
            ),
          ],
          AppSpacing.hMD,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.star_rounded, color: Colors.amber, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    supplier.rating.toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ],
              ),
              Text(
                'آخر طلب: ٢٠٢٦/٠٦/١٢',
                style: context.textTheme.bodySmall?.copyWith(fontSize: 10, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onSendRfq,
                  icon: const Icon(Icons.request_quote_outlined, size: 16),
                  label: const Text('إرسال طلب عرض سعر سريع'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: AppRadius.rMD),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}



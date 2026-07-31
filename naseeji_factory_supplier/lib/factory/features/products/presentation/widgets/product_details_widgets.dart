import 'package:flutter/material.dart';
import 'package:naseeji_factory/core/constants/app_colors.dart';
import 'package:naseeji_factory/core/constants/app_radius.dart';
import 'package:naseeji_factory/core/constants/app_spacing.dart';
import 'package:naseeji_factory/core/extensions/context_extensions.dart';
import 'package:naseeji_factory/core/widgets/reusable_widgets.dart';

import '../providers/products_provider.dart';

/// 1. ProductGalleryWidget & ImageCarouselWidget
class ProductGalleryWidget extends StatefulWidget {
  final Product product;

  const ProductGalleryWidget({super.key, required this.product});

  @override
  State<ProductGalleryWidget> createState() => _ProductGalleryWidgetState();
}

class _ProductGalleryWidgetState extends State<ProductGalleryWidget> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final images = [widget.product.imageUrl, widget.product.imageUrl];
    final isDark = context.theme.brightness == Brightness.dark;

    return Column(
      children: [
        SizedBox(
          height: 240,
          child: PageView.builder(
            itemCount: images.length,
            onPageChanged: (idx) => setState(() => _currentIndex = idx),
            itemBuilder: (context, index) {
              return Image.network(
                images[index],
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: isDark ? AppColors.borderDark : Colors.grey.shade100,
                  alignment: Alignment.center,
                  child: const Icon(Icons.image_not_supported_outlined, size: 48, color: Colors.grey),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(images.length, (idx) {
            final isSelected = _currentIndex == idx;
            return Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.grey.shade400,
                shape: BoxShape.circle,
              ),
            );
          }),
        ),
      ],
    );
  }
}

/// 2. VideoPreviewWidget
class VideoPreviewWidget extends StatelessWidget {
  const VideoPreviewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;

    return SecondaryCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.play_circle_outline_rounded, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'عرض فيديو توضيحي للمنتج',
                  style: context.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  'شاهد خط الإنتاج وجودة الفتل بالصوت والصورة.',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_back_ios_new_rounded, size: 14, color: Colors.grey),
        ],
      ),
    );
  }
}

/// 3. PdfCatalogWidget
class PdfCatalogWidget extends StatelessWidget {
  final VoidCallback onDownload;

  const PdfCatalogWidget({super.key, required this.onDownload});

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: isDark ? 0.15 : 0.08),
        borderRadius: AppRadius.rMD,
        border: Border.all(color: AppColors.info.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.picture_as_pdf_outlined, color: AppColors.info, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'الكتالوج الفني الكامل (PDF)',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                Text(
                  'اضغط للتحميل واستعراض كافة التفاصيل الفنية والمقاسات.',
                  style: context.textTheme.bodySmall?.copyWith(fontSize: 10, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.download_rounded, color: AppColors.info),
            onPressed: onDownload,
          ),
        ],
      ),
    );
  }
}

/// 4. ProductInformationWidget
class ProductInformationWidget extends StatelessWidget {
  final Product product;

  const ProductInformationWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                product.name,
                style: context.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            if (product.isVerifiedSupplier) const StatusChip(label: 'مورد موثق ✅', color: AppColors.success),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
            const SizedBox(width: 4),
            Text(
              product.rating.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 12),
            Container(width: 1, height: 12, color: Colors.grey),
            const SizedBox(width: 12),
            Text(
              'البلد الأصلي: ${product.countryOfOrigin}',
              style: context.textTheme.bodySmall?.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
        AppSpacing.hLG,
        Text(
          'وصف المنتج',
          style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Text(
          product.description,
          style: context.textTheme.bodyMedium?.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
      ],
    );
  }
}

/// 5. TechnicalSpecificationsWidget
class TechnicalSpecificationsWidget extends StatelessWidget {
  final Product product;

  const TechnicalSpecificationsWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return PrimaryCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'المواصفات التقنية',
            style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          AppSpacing.hMD,
          _buildRow('الخامة والتركيب', product.material),
          _buildRow('الألوان المتاحة', product.colors.join('، ')),
          _buildRow('المقاسات / العروض', product.sizes.join('، ')),
          _buildRow('الكمية المتاحة للتسليم', '${product.availableQty} وحدة'),
          for (final entry in product.technicalSpecs.entries) _buildRow(entry.key, entry.value),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.left,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

/// 6. ProductPricingWidget
class ProductPricingWidget extends StatelessWidget {
  final Product product;

  const ProductPricingWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return PrimaryCard(
      color: AppColors.primary.withValues(alpha: 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'السعر المبدئي للوحدة',
                style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
              ),
              Text(
                '${product.price.toInt()} ج.م',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ],
          ),
          AppSpacing.hMD,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('الحد الأدنى للطلب (MOQ)'),
              Text(
                '${product.moq} وحدة',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('زمن تجهيز الطلب المتوسط'),
              Text(
                '${product.prepTimeDays} أيام عمل',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 7. SupplierPreviewWidget
class SupplierPreviewWidget extends StatelessWidget {
  final String supplierName;
  final VoidCallback onTap;

  const SupplierPreviewWidget({
    super.key,
    required this.supplierName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;

    return PrimaryCard(
      onTap: onTap,
      child: Row(
        children: [
          SupplierAvatar(name: supplierName, size: 48),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  supplierName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Text(
                  'اضغط لعرض الملف التعريفي والشهادات الفنية للمورد.',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_back_ios_new_rounded, size: 14, color: Colors.grey),
        ],
      ),
    );
  }
}

/// 8. ActionButtonsWidget
class ActionButtonsWidget {
  // We'll write this buttons builder directly in the screen or combine inside product_details_screen.dart to save layout space and retain clean action wires!
}




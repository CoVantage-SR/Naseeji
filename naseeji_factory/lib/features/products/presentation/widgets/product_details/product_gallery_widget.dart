import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../providers/products_provider.dart';

/// Product image gallery with page indicator dots.
/// Migrated from the monolithic product_details_widgets.dart.
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

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

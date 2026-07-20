import 'package:flutter/material.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/widgets/reusable_widgets.dart';
import '../providers/products_provider.dart';

/// Technical specifications table for the product.
/// Migrated from TechnicalSpecificationsWidget in product_details_widgets.dart.
class ProductTechnicalSpecsWidget extends StatelessWidget {
  final Product product;

  const ProductTechnicalSpecsWidget({super.key, required this.product});

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

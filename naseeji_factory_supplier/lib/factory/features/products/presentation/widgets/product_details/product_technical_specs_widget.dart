import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../providers/products_provider.dart';

/// Product Overview card matching reference screenshot:
/// - Header: "نبذة عن المنتج" with collapse chevron
/// - Overview paragraph
/// - 4 Key Specs icon grid (التركيب, العرض, الوزن, اللون)
class ProductOverviewCardWidget extends StatefulWidget {
  final Product product;

  const ProductOverviewCardWidget({super.key, required this.product});

  @override
  State<ProductOverviewCardWidget> createState() => _ProductOverviewCardWidgetState();
}

class _ProductOverviewCardWidgetState extends State<ProductOverviewCardWidget> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: AppRadius.rMD,
        border: Border.all(
          color: isDark ? AppColors.borderDark : Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            borderRadius: AppRadius.rMD,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: Icon(
                      _isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                      color: Colors.grey,
                    ),
                    onPressed: () => setState(() => _isExpanded = !_isExpanded),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'نبذة عن المنتج',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (_isExpanded) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.description,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.6,
                      color: isDark ? AppColors.textSecondaryDark : Colors.grey.shade800,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Divider(
                    height: 1,
                    color: isDark ? AppColors.borderDark : Colors.grey.shade200,
                  ),
                  const SizedBox(height: 16),
                  // 4 Spec Icons Grid
                  Row(
                    children: [
                      Expanded(
                        child: _buildSpecIconBox(
                          context,
                          icon: Icons.grid_4x4_rounded,
                          iconColor: primaryColor,
                          title: 'التركيب',
                          value: widget.product.composition,
                        ),
                      ),
                      Expanded(
                        child: _buildSpecIconBox(
                          context,
                          icon: Icons.square_foot_rounded,
                          iconColor: primaryColor,
                          title: 'العرض',
                          value: widget.product.width,
                        ),
                      ),
                      Expanded(
                        child: _buildSpecIconBox(
                          context,
                          icon: Icons.shopping_bag_outlined,
                          iconColor: primaryColor,
                          title: 'الوزن',
                          value: widget.product.weight,
                        ),
                      ),
                      Expanded(
                        child: _buildSpecIconBox(
                          context,
                          icon: Icons.palette_outlined,
                          iconColor: primaryColor,
                          title: 'اللون',
                          value: widget.product.colors.isNotEmpty ? widget.product.colors.first : 'أبيض',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSpecIconBox(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: iconColor),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? AppColors.textSecondaryDark : Colors.grey.shade600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

/// Full Technical specifications widget for the Specifications Tab
class ProductTechnicalSpecsWidget extends StatelessWidget {
  final Product product;

  const ProductTechnicalSpecsWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final specs = [
      {'label': 'العرض', 'value': product.width},
      {'label': 'الوزن', 'value': product.weight},
      {'label': 'الخامة', 'value': product.material},
      {'label': 'التركيب', 'value': product.composition},
      {'label': 'اللون', 'value': product.colors.join('، ')},
      {'label': 'اللمسة النهائية', 'value': product.finish},
      {'label': 'النقشة', 'value': product.pattern},
      {'label': 'نسبة التفاوت', 'value': product.tolerance},
      {'label': 'نسبة الانكماش', 'value': product.shrinkage},
      {'label': 'نمرة الخيط', 'value': product.yarnCount},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: AppRadius.rMD,
        border: Border.all(
          color: isDark ? AppColors.borderDark : Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'المواصفات الفنية والتقنية',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 14),
          ...specs.asMap().entries.map((entry) {
            final idx = entry.key;
            final item = entry.value;
            final isEven = idx % 2 == 0;

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: isEven
                    ? (isDark ? AppColors.backgroundDark : Colors.grey.shade50)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      item['label']!,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? AppColors.textSecondaryDark : Colors.grey.shade600,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      item['value']!,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

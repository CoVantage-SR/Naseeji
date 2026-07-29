import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_radius.dart';

/// Supplier card widget matching reference screenshot:
/// - Supplier logo, verified badge checkmark, online status dot ('متصل الآن')
/// - Location ('المنصورة، الدقهلية، مصر')
/// - Rating ('4.9 ★★★★★ (124 تقييم)')
/// - Stats bar (مدة التوريد: 5-7 أيام, عدد المنتجات: 245 منتج, نسبة الاستجابة: 98%, سنة التأسيس: 2005)
/// - Outlined button ('عرض جميع منتجات المورد')
class SupplierCardWidget extends StatefulWidget {
  final String supplierName;
  final String location;
  final double rating;
  final int reviewsCount;
  final String logoUrl;
  final bool isVerified;
  final bool isOnline;
  final String deliveryTime;
  final int productsCount;
  final String responseRate;
  final String establishedYear;
  final VoidCallback onViewAllProducts;

  const SupplierCardWidget({
    super.key,
    required this.supplierName,
    required this.location,
    required this.rating,
    required this.reviewsCount,
    required this.logoUrl,
    required this.isVerified,
    required this.isOnline,
    required this.deliveryTime,
    required this.productsCount,
    required this.responseRate,
    required this.establishedYear,
    required this.onViewAllProducts,
  });

  @override
  State<SupplierCardWidget> createState() => _SupplierCardWidgetState();
}

class _SupplierCardWidgetState extends State<SupplierCardWidget> {
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
        children: [
          // Header Row
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            borderRadius: AppRadius.rMD,
            child: Padding(
              padding: const EdgeInsets.all(14.0),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              widget.supplierName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            if (widget.isVerified) ...[
                              const SizedBox(width: 4),
                              Icon(Icons.verified_rounded, size: 16, color: primaryColor),
                            ],
                          ],
                        ),
                        const SizedBox(height: 2),
                        const Row(
                          children: [
                            Icon(Icons.circle, size: 7, color: AppColors.success),
                            SizedBox(width: 4),
                            Text(
                              'متصل الآن',
                              style: TextStyle(
                                color: AppColors.success,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.location,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              '(${widget.reviewsCount} تقييم)',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.rating.toStringAsFixed(1),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 2),
                            Row(
                              children: List.generate(
                                5,
                                (i) => const Icon(
                                  Icons.star_rounded,
                                  color: Colors.amber,
                                  size: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Supplier Logo Avatar
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.blue.shade100),
                    ),
                    child: ClipOval(
                      child: widget.logoUrl.isNotEmpty
                          ? Image.network(
                              widget.logoUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => _buildDefaultLogo(primaryColor),
                            )
                          : _buildDefaultLogo(primaryColor),
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (_isExpanded) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: Divider(
                height: 1,
                color: isDark ? AppColors.borderDark : Colors.grey.shade200,
              ),
            ),
            // Stats Row inside supplier card
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.backgroundDark : Colors.grey.shade50,
                  borderRadius: AppRadius.rSM,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildStatItem(
                        context,
                        label: 'مدة التوريد',
                        value: widget.deliveryTime,
                      ),
                    ),
                    _buildDivider(isDark),
                    Expanded(
                      child: _buildStatItem(
                        context,
                        label: 'عدد المنتجات',
                        value: '${widget.productsCount} منتج',
                      ),
                    ),
                    _buildDivider(isDark),
                    Expanded(
                      child: _buildStatItem(
                        context,
                        label: 'نسبة الاستجابة',
                        value: widget.responseRate,
                      ),
                    ),
                    _buildDivider(isDark),
                    Expanded(
                      child: _buildStatItem(
                        context,
                        label: 'سنة التأسيس',
                        value: widget.establishedYear,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // View All Supplier Products Button
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: SizedBox(
                width: double.infinity,
                height: 42,
                child: OutlinedButton(
                  onPressed: widget.onViewAllProducts,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: primaryColor,
                    side: BorderSide(color: primaryColor.withValues(alpha: 0.5)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'عرض جميع منتجات المورد',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDefaultLogo(Color primaryColor) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.factory_rounded, color: primaryColor, size: 24),
        const SizedBox(height: 2),
        Text(
          'مصر للنسيج',
          style: TextStyle(fontSize: 7, color: primaryColor, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildStatItem(BuildContext context, {required String label, required String value}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: isDark ? AppColors.textSecondaryDark : Colors.grey.shade600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildDivider(bool isDark) {
    return Container(
      width: 1,
      height: 24,
      color: isDark ? AppColors.borderDark : Colors.grey.shade300,
    );
  }
}

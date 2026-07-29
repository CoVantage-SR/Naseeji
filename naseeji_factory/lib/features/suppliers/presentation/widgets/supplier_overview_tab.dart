import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../products/presentation/providers/suppliers_provider.dart';

/// Tab 1: Overview Tab ("نبذة عن المورد")
class SupplierOverviewTab extends StatefulWidget {
  final Supplier supplier;
  final VoidCallback? onCategoryTap;

  const SupplierOverviewTab({
    super.key,
    required this.supplier,
    this.onCategoryTap,
  });

  @override
  State<SupplierOverviewTab> createState() => _SupplierOverviewTabState();
}

class _SupplierOverviewTabState extends State<SupplierOverviewTab> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. About Supplier Card (Photo Gallery + Text)
          _buildAboutCard(context, isDark: isDark, primaryColor: primaryColor),
          const SizedBox(height: 16),

          // 2. Row of Basic Info Grid & Product Categories
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Basic Information Card (Right column in RTL layout)
              Expanded(
                flex: 6,
                child: _buildBasicInfoCard(context, isDark: isDark, primaryColor: primaryColor),
              ),
              const SizedBox(width: 12),

              // Product Categories List (Left column in RTL layout)
              Expanded(
                flex: 5,
                child: _buildCategoriesCard(context, isDark: isDark, primaryColor: primaryColor),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 3. Ratings Summary Card
          _buildRatingsSummaryCard(context, isDark: isDark, primaryColor: primaryColor),
        ],
      ),
    );
  }

  // 1. About Card
  Widget _buildAboutCard(BuildContext context, {required bool isDark, required Color primaryColor}) {
    final images = widget.supplier.factoryImages;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: AppRadius.rMD,
        border: Border.all(color: isDark ? AppColors.borderDark : Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gallery Column (Left in RTL layout)
          Expanded(
            flex: 5,
            child: Column(
              children: [
                // Main Big Factory Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: AspectRatio(
                    aspectRatio: 1.6,
                    child: Image.network(
                      images.isNotEmpty
                          ? images.first
                          : 'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=600',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.factory_rounded, size: 40, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // 3 Thumbnails + "+12" Badge
                Row(
                  children: [
                    _buildThumb(images.length > 1 ? images[1] : ''),
                    const SizedBox(width: 4),
                    _buildThumb(images.length > 2 ? images[2] : ''),
                    const SizedBox(width: 4),
                    _buildThumb(images.length > 3 ? images[3] : ''),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.backgroundDark : Colors.grey.shade800,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Center(
                          child: Text(
                            '+12',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // About Text Column (Right in RTL layout)
          Expanded(
            flex: 7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'نبذة عن المورد',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.supplier.description,
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.6,
                    color: isDark ? AppColors.textSecondaryDark : Colors.grey.shade700,
                  ),
                  maxLines: _isExpanded ? 10 : 4,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),

                // Collapsible Toggle Button
                InkWell(
                  onTap: () => setState(() => _isExpanded = !_isExpanded),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _isExpanded ? 'عرض أقل' : 'عرض المزيد',
                        style: TextStyle(
                          fontSize: 12,
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(
                        _isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                        color: primaryColor,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThumb(String url) {
    return Expanded(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: SizedBox(
          height: 48,
          child: url.isNotEmpty
              ? Image.network(
                  url,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey.shade300),
                )
              : Container(color: Colors.grey.shade300),
        ),
      ),
    );
  }

  // 2. Basic Info Card
  Widget _buildBasicInfoCard(BuildContext context, {required bool isDark, required Color primaryColor}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: AppRadius.rMD,
        border: Border.all(color: isDark ? AppColors.borderDark : Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'المعلومات الأساسية',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 14),
          _buildInfoRow(context, Icons.business_outlined, 'اسم الشركة', widget.supplier.name, primaryColor),
          _buildInfoRow(context, Icons.domain_outlined, 'نوع الشركة', widget.supplier.companyType, primaryColor),
          _buildInfoRow(
              context, Icons.calendar_month_outlined, 'سنة التأسيس', widget.supplier.establishedYear, primaryColor),
          _buildInfoRow(
              context, Icons.people_outline_rounded, 'عدد الموظفين', widget.supplier.employeesCount, primaryColor),
          _buildInfoRow(context, Icons.location_on_outlined, 'الموقع الرئيسي',
              '${widget.supplier.city}، ${widget.supplier.governorate}', primaryColor),
          _buildInfoRow(context, Icons.public_outlined, 'الأسواق التي نخدمها',
              widget.supplier.exportCountries.join('، '), primaryColor),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String title, String val, Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: primaryColor),
          const SizedBox(width: 8),
          Text(
            '$title:',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              val,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // 3. Product Categories Card
  Widget _buildCategoriesCard(BuildContext context, {required bool isDark, required Color primaryColor}) {
    final categories = [
      {'name': 'أقمشة قطنية', 'icon': Icons.grid_view_rounded},
      {'name': 'أقمشة بوليستر', 'icon': Icons.grid_view_rounded},
      {'name': 'أقمشة مخلوطة', 'icon': Icons.grid_view_rounded},
      {'name': 'خيوط غزل', 'icon': Icons.texture_rounded},
      {'name': 'أقمشة صباغة وطباعة', 'icon': Icons.color_lens_outlined},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: AppRadius.rMD,
        border: Border.all(color: isDark ? AppColors.borderDark : Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'فئات المنتجات',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: widget.onCategoryTap,
                child: const Text('عرض الكل', style: TextStyle(fontSize: 11)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ...categories.map((c) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: isDark ? AppColors.backgroundDark : Colors.grey.shade50,
                borderRadius: AppRadius.rSM,
                border: Border.all(color: isDark ? AppColors.borderDark : Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  Icon(c['icon'] as IconData, size: 16, color: primaryColor),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      c['name'] as String,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
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

  // 4. Ratings Summary Card
  Widget _buildRatingsSummaryCard(BuildContext context, {required bool isDark, required Color primaryColor}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: AppRadius.rMD,
        border: Border.all(color: isDark ? AppColors.borderDark : Colors.grey.shade200),
      ),
      child: Row(
        children: [
          // Rating Score & Distribution
          Expanded(
            flex: 6,
            child: Row(
              children: [
                // Star progress bars
                Expanded(
                  child: Column(
                    children: [
                      _buildRatingBar(context, '5', 89, 0.85, primaryColor),
                      _buildRatingBar(context, '4', 25, 0.20, primaryColor),
                      _buildRatingBar(context, '3', 8, 0.08, primaryColor),
                      _buildRatingBar(context, '2', 4, 0.04, primaryColor),
                      _buildRatingBar(context, '1', 2, 0.02, primaryColor),
                    ],
                  ),
                ),
                const SizedBox(width: 16),

                // Score Display
                Column(
                  children: [
                    Text(
                      widget.supplier.rating.toStringAsFixed(1),
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: List.generate(
                        5,
                        (i) => const Icon(Icons.star_rounded, color: Colors.amber, size: 14),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '(${widget.supplier.reviewsCount} تقييم)',
                      style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(width: 1, height: 90, color: isDark ? AppColors.borderDark : Colors.grey.shade300),
          const SizedBox(width: 16),

          // Testimonial Quote Box
          Expanded(
            flex: 5,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.backgroundDark : Colors.grey.shade50,
                borderRadius: AppRadius.rSM,
                border: Border.all(color: isDark ? AppColors.borderDark : Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '"جودة ممتازة والتزام بالمواعيد... نتعامل معهم منذ أكثر من 3 سنوات"',
                    style: TextStyle(
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                      height: 1.4,
                      color: isDark ? Colors.grey.shade300 : Colors.grey.shade800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.factory_outlined, size: 14, color: AppColors.primary),
                      const SizedBox(width: 4),
                      Text(
                        'مصنع النساجون',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingBar(BuildContext context, String star, int count, double percent, Color primaryColor) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Row(
            children: [
              Text(star, style: const TextStyle(fontSize: 10)),
              const Icon(Icons.star_rounded, size: 10, color: Colors.amber),
            ],
          ),
          const SizedBox(width: 6),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: percent,
                minHeight: 5,
                backgroundColor: isDark ? AppColors.backgroundDark : Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
              ),
            ),
          ),
          const SizedBox(width: 6),
          SizedBox(
            width: 20,
            child: Text(
              count.toString(),
              style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
            ),
          ),
        ],
      ),
    );
  }
}

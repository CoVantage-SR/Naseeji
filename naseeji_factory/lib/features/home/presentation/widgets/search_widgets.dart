import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/widgets/reusable_widgets.dart';
import '../providers/search_provider.dart';

/// 1. SearchAppBarWidget
class SearchAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final Widget searchField;

  const SearchAppBarWidget({super.key, required this.searchField});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_forward_rounded),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: searchField,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// 2. RecentSearchWidget
class RecentSearchWidget extends StatelessWidget {
  final List<String> recentSearches;
  final ValueChanged<String> onSelect;
  final ValueChanged<String> onDelete;

  const RecentSearchWidget({
    super.key,
    required this.recentSearches,
    required this.onSelect,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (recentSearches.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            'البحث الأخير',
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: recentSearches.length,
          itemBuilder: (context, index) {
            final query = recentSearches[index];
            return ListTile(
              leading: const Icon(Icons.history_rounded, color: Colors.grey),
              title: Text(query),
              trailing: IconButton(
                icon: const Icon(Icons.close_rounded, size: 18),
                onPressed: () => onDelete(query),
              ),
              onTap: () => onSelect(query),
            );
          },
        ),
      ],
    );
  }
}

/// 3. FilterWidget - Bottom Sheet for filter criteria
class FilterWidget extends StatefulWidget {
  final SearchFilters initialFilters;
  final ValueChanged<SearchFilters> onApply;
  final VoidCallback onReset;

  const FilterWidget({
    super.key,
    required this.initialFilters,
    required this.onApply,
    required this.onReset,
  });

  @override
  State<FilterWidget> createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  late String _selectedCategory;
  late String _selectedGov;
  late String _selectedCity;
  late double _maxPrice;
  late double _minRating;
  late double _maxMinOrder;
  late int _maxDeliveryTime;

  final List<String> _governorates = const [
    'القاهرة',
    'الجيزة',
    'الإسكندرية',
    'الغربية',
    'الدقهلية',
    'الشرقية',
  ];

  final List<String> _categories = const [
    'خيوط',
    'أقمشة',
    'إكسسوارات',
    'تطريز',
    'تغليف',
  ];

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialFilters.category;
    _selectedGov = widget.initialFilters.governorate;
    _selectedCity = widget.initialFilters.city;
    _maxPrice = widget.initialFilters.maxPrice;
    _minRating = widget.initialFilters.minRating;
    _maxMinOrder = widget.initialFilters.maxMinOrder;
    _maxDeliveryTime = widget.initialFilters.maxDeliveryTimeDays;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'تصفية النتائج',
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  widget.onReset();
                  Navigator.of(context).pop();
                },
                child: const Text('إعادة ضبط', style: TextStyle(color: AppColors.error)),
              ),
            ],
          ),
          const Divider(),
          const SizedBox(height: 12),

          // Category Dropdown
          DropdownButtonFormField<String>(
            initialValue: _selectedCategory.isEmpty ? null : _selectedCategory,
            onChanged: (val) => setState(() => _selectedCategory = val ?? ''),
            alignment: Alignment.centerRight,
            decoration: const InputDecoration(
              labelText: 'التصنيف',
              prefixIcon: Icon(Icons.category_outlined),
            ),
            items: _categories.map((cat) {
              return DropdownMenuItem<String>(
                value: cat,
                alignment: Alignment.centerRight,
                child: Text(cat),
              );
            }).toList(),
          ),
          AppSpacing.hMD,

          // Governorate Dropdown
          DropdownButtonFormField<String>(
            initialValue: _selectedGov.isEmpty ? null : _selectedGov,
            onChanged: (val) => setState(() => _selectedGov = val ?? ''),
            alignment: Alignment.centerRight,
            decoration: const InputDecoration(
              labelText: 'المحافظة',
              prefixIcon: Icon(Icons.location_on_outlined),
            ),
            items: _governorates.map((gov) {
              return DropdownMenuItem<String>(
                value: gov,
                alignment: Alignment.centerRight,
                child: Text(gov),
              );
            }).toList(),
          ),
          AppSpacing.hMD,

          // Max Price Slider
          Text('الحد الأقصى للسعر: ${_maxPrice.toInt()} ج.م', style: const TextStyle(fontWeight: FontWeight.w600)),
          Slider(
            value: _maxPrice,
            min: 0,
            max: 100000,
            divisions: 20,
            activeColor: AppColors.primary,
            onChanged: (val) => setState(() => _maxPrice = val),
          ),

          // Rating Rating
          Text('الحد الأدنى للتقييم: $_minRating ⭐', style: const TextStyle(fontWeight: FontWeight.w600)),
          Slider(
            value: _minRating,
            min: 0,
            max: 5,
            divisions: 10,
            activeColor: AppColors.secondary,
            onChanged: (val) => setState(() => _minRating = val),
          ),

          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    widget.onApply(SearchFilters(
                      category: _selectedCategory,
                      governorate: _selectedGov,
                      city: _selectedCity,
                      maxPrice: _maxPrice,
                      minRating: _minRating,
                      maxMinOrder: _maxMinOrder,
                      maxDeliveryTimeDays: _maxDeliveryTime,
                    ));
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(borderRadius: AppRadius.rMD),
                  ),
                  child: const Text('تطبيق التصفية'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 4. ProductCardWidget
class ProductCardWidget extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductCardWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    final String title = product['title'] ?? '';
    final String supplier = product['supplier'] ?? '';
    final double price = product['price'] ?? 0.0;
    final double rating = product['rating'] ?? 0.0;
    final String image = product['image'] ?? '';

    return PrimaryCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: AppRadius.rMD,
              color: isDark ? AppColors.borderDark : Colors.grey.shade100,
            ),
            alignment: Alignment.center,
            child: image.isNotEmpty
                ? ClipRRect(
                    borderRadius: AppRadius.rMD,
                    child: Image.network(
                      image,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.image_not_supported_outlined, color: Colors.grey),
                    ),
                  )
                : const Icon(Icons.image_not_supported_outlined, color: Colors.grey),
          ),
          AppSpacing.wMD,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'المورد: $supplier',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
                AppSpacing.hSM,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${price.toInt()} ج.م / وحدة',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, color: Colors.amber, size: 14),
                        const SizedBox(width: 2),
                        Text(
                          rating.toString(),
                          style: context.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

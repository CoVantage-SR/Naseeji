import 'package:flutter/material.dart';
import 'package:naseeji_factory/factory/core/constants/app_colors.dart';
import 'package:naseeji_factory/factory/core/constants/app_radius.dart';
import 'package:naseeji_factory/factory/core/extensions/context_extensions.dart';
import 'package:naseeji_factory/factory/core/widgets/reusable_widgets.dart';

import '../providers/products_provider.dart';

/// 1. ProductsAppBarWidget
class ProductsAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onSearchTap;
  final VoidCallback onFavoritesTap;
  final VoidCallback onComparisonTap;

  const ProductsAppBarWidget({
    super.key,
    required this.onSearchTap,
    required this.onFavoritesTap,
    required this.onComparisonTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('كتالوج المنتجات'),
      actions: [
        IconButton(
          icon: const Icon(Icons.search_rounded),
          tooltip: 'البحث عن منتجات',
          onPressed: onSearchTap,
        ),
        IconButton(
          icon: const Icon(Icons.favorite_rounded, color: AppColors.error),
          tooltip: 'الموردين المفضلين',
          onPressed: onFavoritesTap,
        ),
        IconButton(
          icon: const Icon(Icons.compare_arrows_rounded),
          tooltip: 'مقارنة الموردين',
          onPressed: onComparisonTap,
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// 2. SearchBarWidget
class SearchBarWidget extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final VoidCallback onFilterTap;

  const SearchBarWidget({
    super.key,
    required this.onChanged,
    required this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppSearchBar(
      hintText: 'ابحث عن خيوط، أقمشة، مستلزمات...',
      onChanged: onChanged,
      onFilterTap: onFilterTap,
    );
  }
}

/// 3. CategoriesWidget & CategoryChipWidget
class CategoriesWidget extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  const CategoriesWidget({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  final List<Map<String, String>> _categories = const [
    {'key': 'all', 'label': 'الكل'},
    {'key': 'yarn', 'label': 'خيوط'},
    {'key': 'fabric', 'label': 'أقمشة'},
    {'key': 'acc', 'label': 'إكسسوارات'},
    {'key': 'embroidery', 'label': 'تطريز'},
    {'key': 'packaging', 'label': 'تغليف'},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: _categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = _categories[index];
          final isSelected = selectedCategory == cat['key'];

          return CategoryChipWidget(
            label: cat['label']!,
            isSelected: isSelected,
            onSelected: (_) => onCategorySelected(cat['key']!),
          );
        },
      ),
    );
  }
}

class CategoryChipWidget extends StatelessWidget {
  final String label;
  final bool isSelected;
  final ValueChanged<bool> onSelected;

  const CategoryChipWidget({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: onSelected,
      selectedColor: AppColors.primary,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : context.colorScheme.onSurface,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      shape: RoundedRectangleBorder(borderRadius: AppRadius.rRound),
      showCheckmark: false,
    );
  }
}

/// 4. FeaturedBannerWidget
class FeaturedBannerWidget extends StatelessWidget {
  const FeaturedBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [AppColors.surfaceDark, AppColors.borderDark]
              : [AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: AppRadius.rLG,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const StatusChip(label: 'عروض حصرية ⚡', color: AppColors.secondary),
                const SizedBox(height: 8),
                Text(
                  'أكبر تجمع لموردي الغزل في مصر',
                  style: context.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'احصل على أسعار مخفضة وطلبات عروض حصرية الآن.',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 60),
        ],
      ),
    );
  }
}

/// 5. ProductCardWidget
class ProductCardWidget extends StatelessWidget {
  final Product product;
  final VoidCallback onFavoriteTap;
  final VoidCallback onTap;

  const ProductCardWidget({
    super.key,
    required this.product,
    required this.onFavoriteTap,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;

    return PrimaryCard(
      onTap: onTap,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image and Favorite Button
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  product.imageUrl,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 120,
                    color: isDark ? AppColors.borderDark : Colors.grey.shade100,
                    alignment: Alignment.center,
                    child: const Icon(Icons.image_not_supported_outlined, color: Colors.grey),
                  ),
                ),
              ),
              if (product.isVerifiedSupplier)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.success,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.verified_rounded, color: Colors.white, size: 10),
                        SizedBox(width: 2),
                        Text(
                          'موثق',
                          style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              Positioned(
                top: 4,
                left: 4,
                child: CircleAvatar(
                  backgroundColor: Colors.white.withValues(alpha: 0.9),
                  radius: 16,
                  child: IconButton(
                    icon: Icon(
                      product.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                      color: product.isFavorite ? AppColors.error : Colors.grey,
                      size: 16,
                    ),
                    padding: EdgeInsets.zero,
                    onPressed: onFavoriteTap,
                  ),
                ),
              ),
            ],
          ),
          // Product Details
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 1),
                Text(
                  product.supplierName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.bodySmall?.copyWith(color: Colors.grey, fontSize: 10),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${product.price.toInt()} ج.م',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, color: Colors.amber, size: 12),
                        const SizedBox(width: 2),
                        Text(
                          product.rating.toString(),
                          style: context.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, fontSize: 10),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Divider(height: 1),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'أقل طلب: ${product.moq}',
                      style: const TextStyle(fontSize: 9, color: Colors.grey, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      'البلد: ${product.countryOfOrigin}',
                      style: const TextStyle(fontSize: 9, color: Colors.grey, fontWeight: FontWeight.w600),
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

/// 6. ProductsGridWidget
class ProductsGridWidget extends StatelessWidget {
  final List<Product> products;
  final ValueChanged<String> onFavoriteToggle;
  final ValueChanged<Product> onProductTap;

  const ProductsGridWidget({
    super.key,
    required this.products,
    required this.onFavoriteToggle,
    required this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.72,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final prod = products[index];
        return ProductCardWidget(
          product: prod,
          onFavoriteTap: () => onFavoriteToggle(prod.id),
          onTap: () => onProductTap(prod),
        );
      },
    );
  }
}

/// 7. PaginationWidget
class PaginationWidget extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onPageChanged;

  const PaginationWidget({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left_rounded),
          onPressed: currentPage > 1 ? () => onPageChanged(currentPage - 1) : null,
        ),
        const SizedBox(width: 8),
        for (int i = 1; i <= totalPages; i++)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: InkWell(
              onTap: () => onPageChanged(i),
              borderRadius: BorderRadius.circular(4),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: i == currentPage ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: i == currentPage ? AppColors.primary : Colors.grey.shade400,
                  ),
                ),
                child: Text(
                  i.toString(),
                  style: TextStyle(
                    color: i == currentPage ? Colors.white : context.colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.chevron_right_rounded),
          onPressed: currentPage < totalPages ? () => onPageChanged(currentPage + 1) : null,
        ),
      ],
    );
  }
}

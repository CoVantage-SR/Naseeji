import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/reusable_widgets.dart';
import '../providers/search_provider.dart';
import '../widgets/home_widgets.dart';
import '../widgets/search_widgets.dart';

class SearchScreen extends ConsumerStatefulWidget {
  final String? initialType;
  final bool? onlyFavorites;

  const SearchScreen({
    super.key,
    this.initialType,
    this.onlyFavorites,
  });

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();
  final List<String> _recentQueries = ['خيوط قطن ممشط', 'أقمشة ملابس رياضية', 'تطريز ملابس جاهزة'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialType != null) {
        ref.read(searchNotifierProvider.notifier).updateSearchType(widget.initialType!);
      }
      if (widget.onlyFavorites == true) {
        ref.read(searchNotifierProvider.notifier).updateFilters(
          ref.read(searchNotifierProvider).filters.copyWith(minRating: 4.5),
        );
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showFilterBottomSheet(BuildContext context, SearchState state) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return FilterWidget(
          initialFilters: state.filters,
          onApply: (newFilters) =>
              ref.read(searchNotifierProvider.notifier).updateFilters(newFilters),
          onReset: () => ref.read(searchNotifierProvider.notifier).resetFilters(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchNotifierProvider);
    final searchNotifier = ref.read(searchNotifierProvider.notifier);

    return Scaffold(
      appBar: SearchAppBarWidget(
        searchField: AppSearchBar(
          controller: _searchController,
          hintText: searchState.searchType == 'suppliers'
              ? 'ابحث باسم المورد أو مجاله...'
              : 'ابحث عن منتجات، طلبات، عروض أسعار...',
          onChanged: (val) => searchNotifier.updateQuery(val),
          onFilterTap: () => _showFilterBottomSheet(context, searchState),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Categories tabs
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              color: Theme.of(context).cardColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildTabButton('products', 'منتجات', searchState.searchType),
                  _buildTabButton('suppliers', 'موردين', searchState.searchType),
                  _buildTabButton('orders', 'طلبات', searchState.searchType),
                  _buildTabButton('rfqs', 'عروض أسعار', searchState.searchType),
                ],
              ),
            ),
            const Divider(height: 1),

            Expanded(
              child: _searchController.text.isEmpty && _recentQueries.isNotEmpty
                  ? SingleChildScrollView(
                      child: RecentSearchWidget(
                        recentSearches: _recentQueries,
                        onSelect: (query) {
                          _searchController.text = query;
                          searchNotifier.updateQuery(query);
                        },
                        onDelete: (query) {
                          setState(() {
                            _recentQueries.remove(query);
                          });
                        },
                      ),
                    )
                  : searchState.results.isEmpty
                      ? const EmptyState(
                          icon: Icons.search_off_rounded,
                          title: 'لا توجد نتائج بحث مطابقة',
                          description: 'جرب استخدام كلمات بحث مختلفة أو قم بتغيير فلاتر التصفية.',
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.all(16.0),
                          itemCount: searchState.results.length,
                          separatorBuilder: (context, index) => AppSpacing.hMD,
                          itemBuilder: (context, index) {
                            final item = searchState.results[index];

                            if (searchState.searchType == 'suppliers') {
                              return SupplierCardWidget(supplier: item);
                            } else if (searchState.searchType == 'orders') {
                              return OrderCardWidget(order: item);
                            } else if (searchState.searchType == 'rfqs') {
                              return LatestRFQCardWidget(rfq: item);
                            }
                            return ProductCardWidget(product: item);
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(String type, String label, String currentType) {
    final isSelected = type == currentType;
    return TextButton(
      onPressed: () {
        ref.read(searchNotifierProvider.notifier).updateSearchType(type);
      },
      style: TextButton.styleFrom(
        foregroundColor: isSelected ? AppColors.primary : Colors.grey,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontSize: 14,
        ),
      ),
    );
  }
}



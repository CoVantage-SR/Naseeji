import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/reusable_widgets.dart';
import '../providers/comparison_provider.dart';
import '../providers/suppliers_provider.dart';
import '../widgets/favorites_widgets.dart';
import '../widgets/suppliers_widgets.dart';

class SuppliersScreen extends ConsumerStatefulWidget {
  const SuppliersScreen({super.key});

  @override
  ConsumerState<SuppliersScreen> createState() => _SuppliersScreenState();
}

class _SuppliersScreenState extends ConsumerState<SuppliersScreen> {
  String _searchQuery = '';
  String _activeSort = 'rating';

  void _showFavoriteBottomSheet(
    BuildContext context,
    String supplierId,
    String name,
    String type,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return AddToFavoritesBottomSheet(
          supplierName: name,
          supplierType: type,
          onSave: (category, note) {
            ref.read(suppliersNotifierProvider.notifier).toggleFavorite(
                  supplierId,
                  category: category,
                  note: note,
                );
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('تم إضافة المورد إلى المفضلة بنجاح!')),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final allSuppliers = ref.watch(suppliersNotifierProvider);
    final selectedComparisonIds = ref.watch(comparisonNotifierProvider);
    final comparisonNotifier = ref.read(comparisonNotifierProvider.notifier);
    final suppliersNotifier = ref.read(suppliersNotifierProvider.notifier);

    // Apply filter
    var filteredSuppliers = allSuppliers;
    if (_searchQuery.isNotEmpty) {
      filteredSuppliers = filteredSuppliers
          .where((s) => s.name.contains(_searchQuery) || s.type.contains(_searchQuery))
          .toList();
    }

    // Apply sort
    if (_activeSort == 'rating') {
      filteredSuppliers.sort((a, b) => b.rating.compareTo(a.rating));
    } else if (_activeSort == 'orders') {
      filteredSuppliers.sort((a, b) => b.completedOrders.compareTo(a.completedOrders));
    } else if (_activeSort == 'products') {
      filteredSuppliers.sort((a, b) => b.productsCount.compareTo(a.productsCount));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('الموردين والشركاء'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          if (selectedComparisonIds.isNotEmpty)
            Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.compare_arrows_rounded),
                  tooltip: 'مقارنة الموردين المحددين',
                  onPressed: () => context.push('/suppliers-comparison'),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
                    child: Text(
                      selectedComparisonIds.length.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: AppSearchBar(
                hintText: 'ابحث باسم المورد أو مجاله...',
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val;
                  });
                },
                onFilterTap: () {},
              ),
            ),
            SortWidget(
              activeSort: _activeSort,
              onSortChanged: (sort) {
                setState(() {
                  _activeSort = sort;
                });
              },
            ),
            AppSpacing.hMD,
            SuppliersHeaderWidget(totalCount: filteredSuppliers.length),
            const Divider(height: 1),
            Expanded(
              child: filteredSuppliers.isEmpty
                  ? const EmptyState(
                      icon: Icons.people_outline_rounded,
                      title: 'لا يوجد موردين مطابقين',
                      description: 'تأكد من كتابة الاسم بشكل صحيح أو ابحث بمفردات أخرى.',
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: filteredSuppliers.length,
                      separatorBuilder: (context, index) => AppSpacing.hMD,
                      itemBuilder: (context, index) {
                        final sup = filteredSuppliers[index];
                        final isCompared = selectedComparisonIds.contains(sup.id);

                        return SupplierCardWidget(
                          supplier: sup,
                          isSelectedForComparison: isCompared,
                          onComparisonToggle: () {
                            if (!isCompared && selectedComparisonIds.length >= 3) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('الحد الأقصى للمقارنة هو ٣ موردين فقط!')),
                              );
                              return;
                            }
                            comparisonNotifier.toggleSupplier(sup.id);
                          },
                          onFavoriteTap: () {
                            checkGuestAction(
                              context,
                              ref,
                              () {
                                if (sup.isFavorite) {
                                  suppliersNotifier.toggleFavorite(sup.id);
                                } else {
                                  _showFavoriteBottomSheet(context, sup.id, sup.name, sup.type);
                                }
                              },
                            );
                          },
                          onViewProfile: () => context.push('/suppliers/${sup.id}'),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

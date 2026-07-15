import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/reusable_widgets.dart';
import '../../providers/comparison_provider.dart';
import '../../providers/suppliers_provider.dart';
import '../favorites_widgets.dart';
import '../suppliers_widgets.dart';

class SuppliersBody extends ConsumerStatefulWidget {
  const SuppliersBody({super.key});

  @override
  ConsumerState<SuppliersBody> createState() => _SuppliersBodyState();
}

class _SuppliersBodyState extends ConsumerState<SuppliersBody> {
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

    return Column(
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
    );
  }
}

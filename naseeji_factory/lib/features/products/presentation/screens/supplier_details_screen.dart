import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/reusable_widgets.dart';
import '../providers/products_provider.dart';
import '../providers/suppliers_provider.dart';
import '../widgets/favorites_widgets.dart';
import '../widgets/supplier_details/supplier_details_body.dart';

class SupplierDetailsScreen extends ConsumerWidget {
  final String supplierId;

  const SupplierDetailsScreen({super.key, required this.supplierId});

  void _showFavoriteBottomSheet(
    BuildContext context,
    WidgetRef ref,
    String id,
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
                  id,
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
  Widget build(BuildContext context, WidgetRef ref) {
    final supplier = ref.watch(suppliersNotifierProvider.notifier).getSupplierById(supplierId);
    final allProducts = ref.watch(productsNotifierProvider);
    final suppliersNotifier = ref.read(suppliersNotifierProvider.notifier);

    if (supplier == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('المورد غير موجود.')),
      );
    }

    final supplierProducts = allProducts.where((p) => p.supplierId == supplier.id).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('الملف التعريفي للمورد'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              supplier.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: supplier.isFavorite ? AppColors.error : null,
            ),
            onPressed: () {
              checkGuestAction(
                context,
                ref,
                () {
                  if (supplier.isFavorite) {
                    suppliersNotifier.toggleFavorite(supplier.id);
                  } else {
                    _showFavoriteBottomSheet(context, ref, supplier.id, supplier.name, supplier.type);
                  }
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم نسخ رابط الملف الشخصي للمورد!')),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SupplierDetailsBody(
          supplier: supplier,
          supplierProducts: supplierProducts,
        ),
      ),
    );
  }
}

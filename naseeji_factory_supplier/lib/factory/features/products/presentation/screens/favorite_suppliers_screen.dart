import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/reusable_widgets.dart';
import '../providers/suppliers_provider.dart';
import '../widgets/favorite_suppliers_widgets.dart';

class FavoriteSuppliersScreen extends ConsumerWidget {
  const FavoriteSuppliersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allSuppliers = ref.watch(suppliersNotifierProvider);
    final notifier = ref.read(suppliersNotifierProvider.notifier);

    final favorites = allSuppliers.where((s) => s.isFavorite).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('الموردين المفضلين'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: favorites.isEmpty
            ? const EmptyState(
                icon: Icons.favorite_border_rounded,
                title: 'قائمة الموردين المفضلين فارغة',
                description: 'قم بإضافة الموردين المميزين للمفضلة للوصول إليهم وإرسال طلبات عروض أسعار سريعة في أي وقت.',
              )
            : ListView.separated(
                padding: const EdgeInsets.all(16.0),
                itemCount: favorites.length,
                separatorBuilder: (context, index) => AppSpacing.hMD,
                itemBuilder: (context, index) {
                  final sup = favorites[index];
                  return FavoriteSupplierCardWidget(
                    supplier: sup,
                    onSendRfq: () => context.push('/request-product?id=prod_1'),
                    onRemove: () {
                      notifier.toggleFavorite(sup.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('تم إزالة المورد من المفضلة.')),
                      );
                    },
                  );
                },
              ),
      ),
    );
  }
}


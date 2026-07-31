import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_spacing.dart';
import '../providers/purchases_provider.dart';
import '../widgets/favorite_suppliers_widgets.dart';
import '../widgets/purchase_history_widgets.dart';

class FavoriteSuppliersScreen extends ConsumerStatefulWidget {
  const FavoriteSuppliersScreen({super.key});

  @override
  ConsumerState<FavoriteSuppliersScreen> createState() => _FavoriteSuppliersScreenState();
}

class _FavoriteSuppliersScreenState extends ConsumerState<FavoriteSuppliersScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    ref.watch(purchasesNotifierProvider);
    final notifier = ref.read(purchasesNotifierProvider.notifier);

    var favorites = notifier.getFavorites().where((s) => s.isFavorite).toList();

    if (_searchQuery.isNotEmpty) {
      favorites = favorites.where((s) {
        final q = _searchQuery.toLowerCase();
        return s.name.toLowerCase().contains(q) || s.type.toLowerCase().contains(q);
      }).toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('الموردين المفضلين'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FavoriteSuppliersHeaderWidget(count: favorites.length),
              AppSpacing.hMD,
              SearchWidget(
                onChanged: (val) => setState(() => _searchQuery = val),
                hint: 'بحث في الموردين المفضلين...',
              ),
              AppSpacing.hMD,
              FavoriteSuppliersListWidget(
                suppliers: favorites,
                onViewProfile: (id) => () => context.push('/products/suppliers/$id'),
                onSendRFQ: (id) => () => context.push('/rfq/create'),
                onStartChat: (id) => () => context.push('/chat'),
                onRemoveFavorite: (id) => () {
                  notifier.toggleFavorite(id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تم إزالة المورد من المفضلة.')),
                  );
                },
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}


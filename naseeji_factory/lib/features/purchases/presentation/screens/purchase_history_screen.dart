import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../orders/presentation/providers/orders_provider.dart';
import '../providers/purchases_provider.dart';
import '../widgets/purchase_history_widgets.dart';

class PurchaseHistoryScreen extends ConsumerStatefulWidget {
  const PurchaseHistoryScreen({super.key});

  @override
  ConsumerState<PurchaseHistoryScreen> createState() => _PurchaseHistoryScreenState();
}

class _PurchaseHistoryScreenState extends ConsumerState<PurchaseHistoryScreen> {
  final List<String> _tabs = ['الكل', 'مكتملة', 'ملغاة', 'مرتجعة', 'استبدال'];
  int _selectedTab = 0;
  String _searchQuery = '';

  static const List<String> _filters = ['الأحدث أولاً', 'الأقدم أولاً', 'الأعلى قيمة'];
  String _selectedFilter = 'الأحدث أولاً';

  @override
  Widget build(BuildContext context) {
    final orders = ref.watch(ordersNotifierProvider);
    final notifier = ref.read(purchasesNotifierProvider.notifier);

    List<PurchaseModel> purchases = notifier.getPurchases(orders);

    // Tab filter
    if (_selectedTab == 1) {
      purchases = purchases.where((p) => p.status == 'completed').toList();
    } else if (_selectedTab == 2) {
      purchases = purchases.where((p) => p.status == 'cancelled').toList();
    } else if (_selectedTab == 3) {
      purchases = purchases.where((p) => p.status == 'returned').toList();
    } else if (_selectedTab == 4) {
      purchases = purchases.where((p) => p.status == 'replacement').toList();
    }

    // Search filter
    if (_searchQuery.isNotEmpty) {
      purchases = purchases.where((p) {
        final q = _searchQuery.toLowerCase();
        return p.order.productName.toLowerCase().contains(q) ||
            p.order.supplierName.toLowerCase().contains(q) ||
            p.order.id.toLowerCase().contains(q) ||
            p.invoiceNumber.toLowerCase().contains(q);
      }).toList();
    }

    // Sorting
    if (_selectedFilter == 'الأعلى قيمة') {
      purchases.sort((a, b) => b.order.finalPrice.compareTo(a.order.finalPrice));
    }

    return Scaffold(
      appBar: PurchaseHistoryAppBarWidget(
        onFilterTap: () => _showFilterSheet(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchWidget(
                onChanged: (val) => setState(() => _searchQuery = val),
                hint: 'بحث في المشتريات والفواتير...',
              ),
              AppSpacing.hMD,
              StatusTabsWidget(
                tabs: _tabs,
                selectedIndex: _selectedTab,
                onTabChanged: (i) => setState(() => _selectedTab = i),
              ),
              AppSpacing.hMD,
              PurchaseHistoryListWidget(
                purchases: purchases,
                onViewDetails: (id) => context.push('/purchases/$id'),
                onReorder: (id) => context.push('/purchases/$id/reorder'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('ترتيب القائمة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 16),
              FilterWidget(
                filters: _filters,
                selected: _selectedFilter,
                onFilterChanged: (val) {
                  setState(() => _selectedFilter = val);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

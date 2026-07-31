import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naseeji_factory/supplier/core/theme/app_colors.dart';
import 'package:naseeji_factory/supplier/features/dashboard/presentation/screens/drawer/navigation_drawer_view.dart';
import '../controllers/orders_controller.dart';
import 'widgets/rfq_stats_grid.dart';
import 'widgets/orders_screen_widgets.dart';

class OrdersScreen extends ConsumerStatefulWidget {
  const OrdersScreen({super.key});

  @override
  ConsumerState<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen> {
  String? selectedFilterStatus;
  String selectedSort = 'الافتراضي'; // 'الافتراضي', 'الأحدث', 'الأقدم', 'الكمية (أعلى)', 'الكمية (أقل)'
  String selectedMaterial = 'الكل'; // 'الكل', 'Cotton', 'Polyester', 'Linen', 'Wool', 'Nylon'

  double _parseQuantity(String qty) {
    final clean = qty.replaceAll(RegExp(r'[^0-9]'), '');
    return double.tryParse(clean) ?? 0.0;
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'تصفية طلبات الأسعار',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'نوع الخامة',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.outline,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: ['الكل', 'Cotton', 'Polyester', 'Linen', 'Wool', 'Nylon'].map((mat) {
                  final isSelected = selectedMaterial == mat;
                  return ChoiceChip(
                    label: Text(mat),
                    selected: isSelected,
                    onSelected: (val) {
                      if (val) {
                        setState(() {
                          selectedMaterial = mat;
                        });
                        Navigator.pop(ctx);
                      }
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _showSortBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'ترتيب حسب',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 16),
              ...['الافتراضي', 'الأحدث', 'الأقدم', 'الكمية (أعلى)', 'الكمية (أقل)'].map((opt) {
                final isSelected = selectedSort == opt;
                return ListTile(
                  trailing: isSelected ? const Icon(Icons.check, color: AppColors.primary) : null,
                  title: Text(
                    opt,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      selectedSort = opt;
                    });
                    Navigator.pop(ctx);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    final stateAsync = ref.watch(ordersControllerProvider);

    return Scaffold(
      key: scaffoldKey,
      drawer: const NavigationDrawerView(),
      appBar: RfqAppBar(scaffoldKey: scaffoldKey),
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: stateAsync.when(
          loading: () => Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
          error: (err, stack) => Center(child: Text('خطأ: $err')),
          data: (stateData) {
            // Apply filtering
            var filteredItems = stateData.items;
            if (selectedFilterStatus != null) {
              filteredItems = filteredItems.where((element) => element.status == selectedFilterStatus).toList();
            }
            if (selectedMaterial != 'الكل') {
              filteredItems = filteredItems.where((element) => element.material.toLowerCase().contains(selectedMaterial.toLowerCase())).toList();
            }

            // Apply sorting
            if (selectedSort == 'الأحدث') {
              filteredItems.sort((a, b) => b.rfqNumber.compareTo(a.rfqNumber));
            } else if (selectedSort == 'الأقدم') {
              filteredItems.sort((a, b) => a.rfqNumber.compareTo(b.rfqNumber));
            } else if (selectedSort == 'الكمية (أعلى)') {
              filteredItems.sort((a, b) => _parseQuantity(b.quantity).compareTo(_parseQuantity(a.quantity)));
            } else if (selectedSort == 'الكمية (أقل)') {
              filteredItems.sort((a, b) => _parseQuantity(a.quantity).compareTo(_parseQuantity(b.quantity)));
            }

            return RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () =>
                  ref.read(ordersControllerProvider.notifier).refreshOrders(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 80.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    RfqStatsGrid(
                      stats: stateData.stats,
                      selectedStatus: selectedFilterStatus,
                      onStatusSelected: (status) {
                        setState(() {
                          selectedFilterStatus = status;
                        });
                      },
                    ),
                    SizedBox(height: 12),
                    RfqFilterSortRow(
                      onFilterPressed: () => _showFilterBottomSheet(context),
                      onSortPressed: () => _showSortBottomSheet(context),
                    ),
                    SizedBox(height: 20),
                    RfqItemsList(items: filteredItems),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}


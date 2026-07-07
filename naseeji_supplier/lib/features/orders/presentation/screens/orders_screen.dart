import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import 'package:naseeji_supplier/core/widgets/app_bottom_navigation_bar.dart';
import 'package:naseeji_supplier/features/dashboard/presentation/screens/drawer/navigation_drawer_view.dart';
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

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    final stateAsync = ref.watch(ordersControllerProvider);

    return Scaffold(
      key: scaffoldKey,
      drawer: const NavigationDrawerView(),
      appBar: RfqAppBar(scaffoldKey: scaffoldKey),
      body: Container(
        color: const Color(0xFFF8F9FF),
        child: stateAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
          error: (err, stack) => Center(child: Text('خطأ: $err')),
          data: (stateData) {
            final filteredItems = selectedFilterStatus == null
                ? stateData.items
                : stateData.items.where((element) => element.status == selectedFilterStatus).toList();

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
                    const SizedBox(height: 12),
                    const RfqFilterSortRow(),
                    const SizedBox(height: 20),
                    RfqItemsList(items: filteredItems),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: const AppBottomNavigationBar(currentIndex: 2),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import 'package:naseeji_supplier/features/dashboard/presentation/screens/drawer/navigation_drawer_view.dart';
import '../controllers/orders_controller.dart';
import 'widgets/rfq_stats_grid.dart';
import 'widgets/orders_screen_widgets.dart';

class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    final stateAsync = ref.watch(ordersControllerProvider);

    return Scaffold(
      key: scaffoldKey,
      endDrawer: const NavigationDrawerView(),
      appBar: RfqAppBar(scaffoldKey: scaffoldKey),
      body: Container(
        color: const Color(0xFFF8F9FF),
        child: stateAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
          error: (err, stack) => Center(child: Text('خطأ: $err')),
          data: (stateData) {
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
                    RfqStatsGrid(stats: stateData.stats),
                    const SizedBox(height: 20),
                    const RfqSearchBar(),
                    const SizedBox(height: 16),
                    const RfqFilterSortRow(),
                    const SizedBox(height: 20),
                    RfqItemsList(items: stateData.items),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: const RfqBottomNavigationBar(),
    );
  }
}

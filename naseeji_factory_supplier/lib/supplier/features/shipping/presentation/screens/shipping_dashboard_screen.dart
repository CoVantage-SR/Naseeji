import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_factory/supplier/core/theme/app_colors.dart';
import 'package:naseeji_factory/supplier/features/dashboard/presentation/screens/drawer/navigation_drawer_view.dart';
import '../../domain/entities/shipment.dart';
import '../controllers/shipping_controller.dart';
import '../widgets/shipping_summary_grid.dart';
import '../widgets/shipment_list_card.dart';

class ShippingDashboardScreen extends ConsumerStatefulWidget {
  const ShippingDashboardScreen({super.key});

  @override
  ConsumerState<ShippingDashboardScreen> createState() => _ShippingDashboardScreenState();
}

class _ShippingDashboardScreenState extends ConsumerState<ShippingDashboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<String> _tabs = ['الكل', 'جاهز للشحن', 'في الطريق', 'تم التسليم', 'بلاغات متأخرة'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stateAsync = ref.watch(shippingControllerProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: const NavigationDrawerView(),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: 0.5,
          centerTitle: true,
          title: Text(
            'لوجستيات الشحن والتسليم',
            style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 15),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onSurface),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/home');
              }
            },
          ),
          bottom: TabBar(
            controller: _tabController,
            isScrollable: true,
            labelColor: const Color(0xFF0040E0),
            unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant,
            indicatorColor: const Color(0xFF0040E0),
            labelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            tabs: _tabs.map((title) => Tab(text: title)).toList(),
          ),
        ),
        body: stateAsync.when(
          loading: () => Center(child: CircularProgressIndicator(color: AppColors.primary)),
          error: (e, _) => Center(child: Text('خطأ في التحميل: $e')),
          data: (shipments) {
            final filtered = _filterShipments(shipments, _tabController.index);

            return RefreshIndicator(
              onRefresh: () => ref.read(shippingControllerProvider.notifier).refresh(),
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  // Top Summary Grid
                  ShippingSummaryGrid(shipments: shipments),
                  SizedBox(height: 16),
                  
                  // Shipment List Title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'إجمالي الشحنات (${filtered.length})',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Theme.of(context).colorScheme.onSurface),
                      ),
                      IconButton(
                        icon: const Icon(Icons.sync_outlined, size: 18, color: AppColors.outline),
                        onPressed: () => ref.read(shippingControllerProvider.notifier).refresh(),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),

                  if (filtered.isEmpty)
                    _buildEmptyState()
                  else
                    ...filtered.map((s) => ShipmentListCard(s: s)),
                  SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  List<Shipment> _filterShipments(List<Shipment> list, int tabIndex) {
    switch (tabIndex) {
      case 1:
        return list.where((s) => s.status == ShipmentStatus.ready || s.status == ShipmentStatus.loaded).toList();
      case 2:
        return list.where((s) => s.status == ShipmentStatus.pickedUp || s.status == ShipmentStatus.inTransit || s.status == ShipmentStatus.arrived).toList();
      case 3:
        return list.where((s) => s.status == ShipmentStatus.delivered || s.status == ShipmentStatus.paymentPending || s.status == ShipmentStatus.completed).toList();
      case 4:
        return list.where((s) => s.issueReported != null).toList();
      default:
        return list;
    }
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(Icons.local_shipping_outlined, size: 48, color: AppColors.outlineVariant),
          SizedBox(height: 12),
          Text('لا يوجد شحنات مطابقة لتصفية التبويب المحدد', style: TextStyle(color: AppColors.outline, fontSize: 12)),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../widgets/details_tab_view.dart';
import '../widgets/timeline_tab_view.dart';
import '../widgets/media_docs_tab_view.dart';
import '../widgets/shipment_bottom_action_bar.dart';
import '../controllers/shipping_controller.dart';

class ShipmentDetailsScreen extends ConsumerStatefulWidget {
  final String shipmentId;

  const ShipmentDetailsScreen({super.key, required this.shipmentId});

  @override
  ConsumerState<ShipmentDetailsScreen> createState() => _ShipmentDetailsScreenState();
}

class _ShipmentDetailsScreenState extends ConsumerState<ShipmentDetailsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = ['التفاصيل والمالية', 'الخط الزمني', 'الصور والمستندات'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
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
      child: stateAsync.when(
        loading: () => const Scaffold(body: Center(child: CircularProgressIndicator(color: AppColors.primary))),
        error: (e, _) => Scaffold(body: Center(child: Text('خطأ: $e'))),
        data: (shipments) {
          final shipmentIndex = shipments.indexWhere((s) => s.id == widget.shipmentId);
          if (shipmentIndex == -1) {
            return const Scaffold(body: Center(child: Text('الشحنة غير موجودة')));
          }
          final s = shipments[shipmentIndex];

          return Scaffold(
            backgroundColor: const Color(0xFFF8F9FF),
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0.5,
              centerTitle: true,
              title: Column(
                children: [
                  Text(
                    'تفاصيل الشحنة ${s.id}',
                    style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'طلب: ${s.orderNumber} • مصنع: ${s.factoryName}',
                    style: const TextStyle(color: AppColors.outline, fontSize: 10),
                  ),
                ],
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.onSurfaceVariant, size: 20),
                onPressed: () => context.pop(),
              ),
              bottom: TabBar(
                controller: _tabController,
                labelColor: const Color(0xFF0040E0),
                unselectedLabelColor: AppColors.onSurfaceVariant,
                indicatorColor: const Color(0xFF0040E0),
                labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                tabs: _tabs.map((title) => Tab(text: title)).toList(),
              ),
            ),
            body: TabBarView(
              controller: _tabController,
              children: [
                DetailsTabView(s: s),
                TimelineTabView(s: s),
                MediaDocsTabView(s: s),
              ],
            ),
            bottomNavigationBar: ShipmentBottomActionBar(s: s),
          );
        },
      ),
    );
  }
}

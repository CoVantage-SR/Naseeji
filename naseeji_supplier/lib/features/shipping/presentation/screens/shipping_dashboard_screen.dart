import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import 'package:naseeji_supplier/core/widgets/app_bottom_navigation_bar.dart';
import 'package:naseeji_supplier/features/dashboard/presentation/screens/drawer/navigation_drawer_view.dart';
import '../../domain/entities/shipment.dart';
import '../controllers/shipping_controller.dart';

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
        endDrawer: const NavigationDrawerView(),
        backgroundColor: const Color(0xFFF8F9FF),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          centerTitle: true,
          title: const Text(
            'لوجستيات الشحن والتسليم',
            style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 15),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.menu, color: AppColors.onSurfaceVariant),
              onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            isScrollable: true,
            labelColor: const Color(0xFF0040E0),
            unselectedLabelColor: AppColors.onSurfaceVariant,
            indicatorColor: const Color(0xFF0040E0),
            labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            tabs: _tabs.map((title) => Tab(text: title)).toList(),
          ),
        ),
        body: stateAsync.when(
          loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
          error: (e, _) => Center(child: Text('خطأ في التحميل: $e')),
          data: (shipments) {
            final filtered = _filterShipments(shipments, _tabController.index);

            return RefreshIndicator(
              onRefresh: () => ref.read(shippingControllerProvider.notifier).refresh(),
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  // Top Summary Cards
                  _buildSummaryGrid(shipments),
                  const SizedBox(height: 16),
                  
                  // Shipment List Title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'إجمالي الشحنات (${filtered.length})',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.onSurface),
                      ),
                      IconButton(
                        icon: const Icon(Icons.sync_outlined, size: 18, color: AppColors.outline),
                        onPressed: () => ref.read(shippingControllerProvider.notifier).refresh(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  if (filtered.isEmpty)
                    _buildEmptyState()
                  else
                    ...filtered.map((s) => _buildShipmentCard(context, s)),
                  const SizedBox(height: 80),
                ],
              ),
            );
          },
        ),
        bottomNavigationBar: const Directionality(
          textDirection: TextDirection.ltr,
          child: AppBottomNavigationBar(currentIndex: 2), // Maps to Orders tab index
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

  Widget _buildSummaryGrid(List<Shipment> shipments) {
    final pending = shipments.where((s) => s.status == ShipmentStatus.ready).length;
    final ready = shipments.where((s) => s.status == ShipmentStatus.loaded).length;
    final transit = shipments.where((s) => s.status == ShipmentStatus.pickedUp || s.status == ShipmentStatus.inTransit || s.status == ShipmentStatus.arrived).length;
    final delivered = shipments.where((s) => s.status == ShipmentStatus.delivered || s.status == ShipmentStatus.paymentPending || s.status == ShipmentStatus.completed).length;
    final delayed = shipments.where((s) => s.issueReported != null && s.status != ShipmentStatus.completed).length;
    const cancelled = 0; // Mock count

    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      childAspectRatio: 1.3,
      children: [
        _buildSummaryCard('معلقة شحن', '$pending', Colors.blue),
        _buildSummaryCard('جاهزة للتحميل', '$ready', Colors.indigo),
        _buildSummaryCard('في الطريق', '$transit', Colors.orange),
        _buildSummaryCard('تم تسليمها', '$delivered', Colors.green),
        _buildSummaryCard('تأخير وبلاغات', '$delayed', Colors.red),
        _buildSummaryCard('ملغية', '$cancelled', Colors.grey),
      ],
    );
  }

  Widget _buildSummaryCard(String label, String value, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border(right: BorderSide(color: color, width: 3)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 4, offset: const Offset(0, 1))],
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: const TextStyle(fontSize: 9, color: AppColors.outline, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: color)),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      alignment: Alignment.center,
      child: const Column(
        children: [
          Icon(Icons.local_shipping_outlined, size: 48, color: AppColors.outlineVariant),
          SizedBox(height: 12),
          Text('لا يوجد شحنات مطابقة لتصفية التبويب المحدد', style: TextStyle(color: AppColors.outline, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildShipmentCard(BuildContext context, Shipment s) {
    Color statusColor = Colors.grey;
    String statusText = '';
    
    switch (s.status) {
      case ShipmentStatus.ready:
        statusColor = Colors.blue.shade700;
        statusText = 'جاهز للشحن';
        break;
      case ShipmentStatus.loaded:
        statusColor = Colors.indigo;
        statusText = 'تم التحميل للناقل';
        break;
      case ShipmentStatus.pickedUp:
        statusColor = Colors.orange;
        statusText = 'تم الاستلام';
        break;
      case ShipmentStatus.inTransit:
        statusColor = Colors.orange.shade700;
        statusText = 'في الطريق';
        break;
      case ShipmentStatus.arrived:
        statusColor = Colors.teal;
        statusText = 'وصلت الميناء/المستودع';
        break;
      case ShipmentStatus.delivered:
        statusColor = Colors.green;
        statusText = 'تم التسليم للمشتري';
        break;
      case ShipmentStatus.paymentPending:
        statusColor = Colors.purple;
        statusText = 'قيد الإفراج المالي';
        break;
      case ShipmentStatus.completed:
        statusColor = Colors.green.shade800;
        statusText = 'مكتملة ومسواة';
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header info
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
            child: Row(
              children: [
                // Factory logo
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Color(s.factoryLogoBgColorValue),
                  child: Text(s.factoryLogoText, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(s.factoryName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.onSurface)),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text('طلب: ${s.orderNumber}', style: const TextStyle(fontSize: 10, color: AppColors.outline)),
                          const SizedBox(width: 8),
                          Text('RFQ #${s.rfqNumber}', style: const TextStyle(fontSize: 10, color: AppColors.outline)),
                        ],
                      ),
                    ],
                  ),
                ),
                // Priority Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: s.priority == 'عالي جداً' ? Colors.red.shade50 : AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    s.priority,
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                      color: s.priority == 'عالي جداً' ? Colors.red.shade700 : AppColors.outline,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.surfaceContainerLow),

          // Content body
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s.productName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: AppColors.onSurfaceVariant)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Text('الكمية: ', style: TextStyle(fontSize: 11, color: AppColors.outline)),
                    Text('${s.quantity} ${s.unit}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
                    const Spacer(),
                    const Text('الناقل: ', style: TextStyle(fontSize: 11, color: AppColors.outline)),
                    Text(s.shippingCompany.isNotEmpty ? s.shippingCompany : 'بانتظار الاختيار', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
                  ],
                ),
                if (s.trackingNumber.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Text('رقم التتبع: ', style: TextStyle(fontSize: 11, color: AppColors.outline)),
                      Text(s.trackingNumber, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary)),
                      const Spacer(),
                      const Text('التوصيل المتوقع: ', style: TextStyle(fontSize: 11, color: AppColors.outline)),
                      Text(s.estimatedDelivery, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
                    ],
                  ),
                ],
                const SizedBox(height: 8),
                
                // Status tag & Progress bar
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        statusText,
                        style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: statusColor),
                      ),
                    ),
                    if (s.issueReported != null) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(6)),
                        child: Text('بلاغ نشط', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.red.shade700)),
                      ),
                    ],
                    const Spacer(),
                    Text('${(s.progress * 100).toInt()}%', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: statusColor)),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: s.progress,
                    color: statusColor,
                    backgroundColor: AppColors.surfaceContainerLow,
                    minHeight: 4,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'آخر تحديث: ${s.lastUpdate}',
                  style: const TextStyle(fontSize: 9, color: AppColors.outline, fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.surfaceContainerLow),

          // Actions
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: () => context.push('/shipping/tracking/${s.id}'),
                    icon: const Icon(Icons.map_outlined, size: 14),
                    label: const Text('تتبع الشحنة', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                    style: TextButton.styleFrom(foregroundColor: AppColors.primary, padding: EdgeInsets.zero),
                  ),
                ),
                Expanded(
                  child: TextButton.icon(
                    onPressed: () => context.push('/shipping/documents/${s.id}'),
                    icon: const Icon(Icons.description_outlined, size: 14),
                    label: const Text('المستندات', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                    style: TextButton.styleFrom(foregroundColor: AppColors.secondary, padding: EdgeInsets.zero),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => context.push('/shipping/details/${s.id}'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0040E0),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      minimumSize: const Size(0, 32),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: EdgeInsets.zero,
                    ),
                    child: const Text('التفاصيل', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

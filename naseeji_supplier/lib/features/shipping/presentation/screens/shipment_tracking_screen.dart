import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../widgets/tracking_map_view.dart';
import '../widgets/tracking_transit_step.dart';
import '../controllers/shipping_controller.dart';

class ShipmentTrackingScreen extends ConsumerWidget {
  final String shipmentId;

  const ShipmentTrackingScreen({super.key, required this.shipmentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateAsync = ref.watch(shippingControllerProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          centerTitle: true,
          title: Text(
            'تتبع الشحنة $shipmentId',
            style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.onSurfaceVariant, size: 20),
            onPressed: () => context.pop(),
          ),
        ),
        body: stateAsync.when(
          loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
          error: (e, _) => Center(child: Text('خطأ: $e')),
          data: (shipments) {
            final shipmentIndex = shipments.indexWhere((s) => s.id == shipmentId);
            if (shipmentIndex == -1) {
              return const Center(child: Text('الشحنة غير موجودة'));
            }
            final s = shipments[shipmentIndex];

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Tracking Header Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      boxShadow: [BoxShadow(color: Color(0x05000000), blurRadius: 10)],
                    ),
                    child: Column(
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.pin_drop, color: AppColors.primary, size: 24),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('آخر موقع مرصود للشحنة', style: TextStyle(fontSize: 10, color: AppColors.outline)),
                                  SizedBox(height: 2),
                                  Text('طريق الرياض - الدمام السريع • مركز المراقبة والوزن اللوجستي', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.onSurface)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 20, color: AppColors.surfaceContainerLow),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildInfoColumn('شركة الشحن', s.shippingCompany),
                            _buildInfoColumn('رقم التتبع', s.trackingNumber.isNotEmpty ? s.trackingNumber : 'بانتظار التحديث'),
                            _buildInfoColumn('الوصول المتوقع', s.estimatedDelivery),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // GPS Interactive Map Card
                  const TrackingMapView(),
                  const SizedBox(height: 16),

                  // Interactive Timeline progress
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      boxShadow: [BoxShadow(color: Color(0x05000000), blurRadius: 10)],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('تفاصيل التتبع والرحلة والعبور اللوجستي', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.onSurface)),
                        const SizedBox(height: 16),
                        TrackingTransitStep(title: 'تم تسليم الشحنة للمشتري', desc: 'مستودع مصنع الرياض - البوابة الرئيسية', time: '2026-07-06 04:30 م', completed: s.progress >= 0.95),
                        TrackingTransitStep(title: 'مركبة النقل في ترانزيت الطريق السريع', desc: 'طريق الرياض - الدمام السريع', time: '2026-07-05 10:15 ص', completed: s.progress >= 0.65),
                        TrackingTransitStep(title: 'تم استلام الشحنة من المورد وجاري التحميل', desc: 'مستودع المورد نسيجي - الرياض', time: '2026-07-05 08:30 ص', completed: s.progress >= 0.40),
                        TrackingTransitStep(title: 'تم جدولة وإصدار بوليصة أرامكس', desc: 'النظام الموحد نسيجي', time: '2026-07-04 02:00 م', completed: true),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoColumn(String label, String val) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 9, color: AppColors.outline)),
        const SizedBox(height: 2),
        Text(val, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.onSurface)),
      ],
    );
  }
}

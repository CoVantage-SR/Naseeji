import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
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
        backgroundColor: const Color(0xFFF8F9FF),
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
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10)]),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.pin_drop, color: AppColors.primary, size: 24),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('آخر موقع مرصود للشحنة', style: TextStyle(fontSize: 10, color: AppColors.outline)),
                                  const SizedBox(height: 2),
                                  const Text('طريق الرياض - الدمام السريع • مركز المراقبة والوزن اللوجستي', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.onSurface)),
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
                  Container(
                    height: 220,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade300),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10)],
                    ),
                    child: Stack(
                      children: [
                        // Map Network Preview
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              'https://images.unsplash.com/photo-1524661135-423995f22d0b?auto=format&fit=crop&w=600&q=80',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        // Start point indicator
                        Positioned(
                          bottom: 40,
                          right: 60,
                          child: _buildMapMarker('نقطة البدء (الرياض)', Colors.blue),
                        ),
                        // Current location indicator
                        Positioned(
                          top: 100,
                          left: 120,
                          child: _buildMapMarker('الشحنة حالياً', Colors.orange, isCurrent: true),
                        ),
                        // Destination indicator
                        Positioned(
                          top: 30,
                          right: 180,
                          child: _buildMapMarker('الوجهة (الدمام)', Colors.green),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Interactive Timeline progress
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10)]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('تفاصيل التتبع والرحلة والعبور اللوجستي', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.onSurface)),
                        const SizedBox(height: 16),
                        _buildTransitStep('تم تسليم الشحنة للمشتري', 'مستودع مصنع الرياض - البوابة الرئيسية', '2026-07-06 04:30 م', completed: s.progress >= 0.95),
                        _buildTransitStep('مركبة النقل في ترانزيت الطريق السريع', 'طريق الرياض - الدمام السريع', '2026-07-05 10:15 ص', completed: s.progress >= 0.65),
                        _buildTransitStep('تم استلام الشحنة من المورد وجاري التحميل', 'مستودع المورد نسيجي - الرياض', '2026-07-05 08:30 ص', completed: s.progress >= 0.40),
                        _buildTransitStep('تم جدولة وإصدار بوليصة أرامكس', 'النظام الموحد نسيجي', '2026-07-04 02:00 م', completed: true),
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

  Widget _buildMapMarker(String label, Color color, {bool isCurrent = false}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
          ),
          child: Text(label, style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 2),
        Icon(
          isCurrent ? Icons.local_shipping : Icons.location_on,
          color: color,
          size: isCurrent ? 24 : 20,
        ),
      ],
    );
  }

  Widget _buildTransitStep(String title, String desc, String time, {required bool completed}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: completed ? const Color(0xFF0040E0) : Colors.grey.shade300,
                shape: BoxShape.circle,
              ),
              child: completed ? const Icon(Icons.check, size: 10, color: Colors.white) : null,
            ),
            Container(
              width: 2,
              height: 40,
              color: completed ? const Color(0xFF0040E0) : Colors.grey.shade300,
            ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: completed ? AppColors.onSurface : AppColors.outline),
              ),
              const SizedBox(height: 2),
              Text(desc, style: const TextStyle(fontSize: 9, color: AppColors.outline)),
            ],
          ),
        ),
        Text(time, style: const TextStyle(fontSize: 9, color: AppColors.outline)),
      ],
    );
  }
}

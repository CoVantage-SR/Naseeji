import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_factory/core/theme/app_colors.dart';
import '../../domain/entities/shipment.dart';
import '../controllers/shipping_controller.dart';

class ShipmentBottomActionBar extends ConsumerWidget {
  final Shipment s;

  const ShipmentBottomActionBar({super.key, required this.s});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (s.status == ShipmentStatus.ready) {
      return Container(
        color: Theme.of(context).colorScheme.surface,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => context.push('/shipping/company-selector/${s.id}'),
                style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.outline), minimumSize: const Size(0, 48)),
                child: Text('اختيار شركة الشحن', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: () => _showSchedulePickupDialog(context, ref, s),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0040E0), foregroundColor: Colors.white, minimumSize: const Size(0, 48)),
                child: Text('جدولة استلام السائق', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      );
    }

    if (s.status == ShipmentStatus.loaded) {
      return Container(
        color: Theme.of(context).colorScheme.surface,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => ref.read(shippingControllerProvider.notifier).updateStatus(s.id, ShipmentStatus.pickedUp),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0040E0), foregroundColor: Colors.white, minimumSize: const Size(0, 48)),
                child: Text('تأكيد استلام السائق الفعلي الشحنة', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      );
    }

    if (s.status == ShipmentStatus.pickedUp || s.status == ShipmentStatus.inTransit || s.status == ShipmentStatus.arrived) {
      return Container(
        color: Theme.of(context).colorScheme.surface,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => context.push('/shipping/issue/${s.id}'),
                icon: const Icon(Icons.warning_amber_rounded, size: 18),
                label: Text('إبلاغ عن تأخر/تلف', style: TextStyle(fontWeight: FontWeight.bold)),
                style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.red), foregroundColor: Colors.red, minimumSize: const Size(0, 48)),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => context.push('/shipping/tracking/${s.id}'),
                icon: const Icon(Icons.map_outlined, size: 18),
                label: Text('تتبع حي GPS', style: TextStyle(fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0040E0), foregroundColor: Colors.white, minimumSize: const Size(0, 48)),
              ),
            ),
          ],
        ),
      );
    }

    if (s.status == ShipmentStatus.delivered) {
      return Container(
        color: Theme.of(context).colorScheme.surface,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('راجع تقرير فحص المصنع المرفق بالأسفل.')));
                },
                style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.outline), minimumSize: const Size(0, 48)),
                child: Text('معاينة الفحص والاستلام', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  if (s.issueReported != null) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('لا يمكن الإفراج المالي طالما هناك بلاغ/نزاع مفتوح.')));
                  } else {
                    ref.read(shippingControllerProvider.notifier).updateStatus(s.id, ShipmentStatus.paymentPending);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('جاري مراجعة تسوية الإفراج المالي.')));
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: s.issueReported != null ? Colors.grey : const Color(0xFF0040E0),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(0, 48),
                ),
                child: Text('طلب تسوية الإفراج المالي', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      );
    }

    if (s.status == ShipmentStatus.paymentPending) {
      return Container(
        color: Theme.of(context).colorScheme.surface,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => ref.read(shippingControllerProvider.notifier).updateStatus(s.id, ShipmentStatus.completed),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade700, foregroundColor: Colors.white, minimumSize: const Size(0, 48)),
                child: Text('إفراج الحوالة المالية بنجاح (مكتمل)', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink(); // For completed shipments, no action bar needed
  }

  void _showSchedulePickupDialog(BuildContext context, WidgetRef ref, Shipment s) {
    final driverController = TextEditingController(text: 'محمد العتيبي');
    final phoneController = TextEditingController(text: '+٩٦٦ ٥٠ ١٢٣ ٤٥٦٧');
    final vehicleController = TextEditingController(text: 'أ ب ج ١٢٣٤');

    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: Text('جدولة استلام الشحنة وتعيين السائق', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: driverController, decoration: const InputDecoration(labelText: 'اسم السائق الناقل')),
              TextField(controller: phoneController, decoration: const InputDecoration(labelText: 'رقم جوال السائق')),
              TextField(controller: vehicleController, decoration: const InputDecoration(labelText: 'رقم لوحة الشاحنة/المركبة')),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: Text('إلغاء')),
            ElevatedButton(
              onPressed: () {
                ref.read(shippingControllerProvider.notifier).scheduleCarrierPickup(
                  s.id,
                  driverName: driverController.text,
                  driverPhone: phoneController.text,
                  vehicleNum: vehicleController.text,
                );
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تمت جدولة السائق وتأكيد استلام سمسا/أرامكس للشحنة.')));
              },
              child: Text('تأكيد الجدول والتعيين'),
            ),
          ],
        ),
      ),
    );
  }
}




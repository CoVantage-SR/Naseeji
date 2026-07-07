import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../../domain/entities/shipment.dart';
import '../controllers/shipping_controller.dart';

class ShipmentDocumentsScreen extends ConsumerWidget {
  final String shipmentId;

  const ShipmentDocumentsScreen({super.key, required this.shipmentId});

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
            'مستندات الشحنة $shipmentId',
            style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 13),
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

            final allDocs = s.documents;

            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10)]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.info_outline, color: AppColors.primary, size: 20),
                          const SizedBox(width: 8),
                          Text('نظام إدارة الوثائق والإصدارات للطلب ${s.orderNumber}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'يدعم النظام أرشفة وحفظ الإصدارات التراكمية للمستندات لضمان التتبع والتدقيق المالي والتخليص الجمركي بنجاح.',
                        style: TextStyle(fontSize: 10, color: AppColors.outline, height: 1.4),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('الملفات المرفوعة (${allDocs.length})', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.onSurfaceVariant)),
                    ElevatedButton.icon(
                      onPressed: () => _showUploadDocDialog(context, ref, s),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0040E0),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(0, 32),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      icon: const Icon(Icons.add, size: 14),
                      label: const Text('إرفاق مستند جديد', style: TextStyle(fontSize: 11)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                if (allDocs.isEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    alignment: Alignment.center,
                    child: const Column(
                      children: [
                        Icon(Icons.description_outlined, size: 48, color: AppColors.outlineVariant),
                        SizedBox(height: 8),
                        Text('لا يوجد مستندات رسمية مرفوعة بعد لهذه الشحنة.', style: TextStyle(color: AppColors.outline, fontSize: 11)),
                      ],
                    ),
                  )
                else
                  ...allDocs.map((doc) => _buildDocCard(context, ref, s, doc)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildDocCard(BuildContext context, WidgetRef ref, Shipment s, ShipmentDocument doc) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.surfaceContainerLow),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.01), blurRadius: 6)],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const CircleAvatar(
                backgroundColor: Color(0xFFFFF2EC),
                radius: 18,
                child: Icon(Icons.description_outlined, color: Colors.orange, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(doc.type, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.onSurface)),
                    const SizedBox(height: 2),
                    Text(doc.name, style: const TextStyle(fontSize: 10, color: AppColors.outline)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: const Color(0xFFF3F2FF), borderRadius: BorderRadius.circular(4)),
                child: Text('إصدار v${doc.version}', style: const TextStyle(fontSize: 8, color: AppColors.primary, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const Divider(height: 20, color: AppColors.surfaceContainerLow),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('تاريخ الرفع: ${doc.uploadedAt}', style: const TextStyle(fontSize: 9, color: AppColors.outline)),
              Row(
                children: [
                  TextButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تم تنزيل ${doc.name} بنجاح.')));
                    },
                    icon: const Icon(Icons.download_outlined, size: 14),
                    label: const Text('تنزيل', style: TextStyle(fontSize: 10)),
                  ),
                  const SizedBox(width: 4),
                  TextButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تم إرسال رابط مشاركة المستند ${doc.type}')));
                    },
                    icon: const Icon(Icons.share_outlined, size: 14),
                    label: const Text('مشاركة', style: TextStyle(fontSize: 10)),
                    style: TextButton.styleFrom(foregroundColor: AppColors.secondary),
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    icon: const Icon(Icons.sync_outlined, size: 16, color: AppColors.primary),
                    onPressed: () => _showUploadDocDialog(context, ref, s, initialType: doc.type),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showUploadDocDialog(BuildContext context, WidgetRef ref, Shipment s, {String? initialType}) {
    final typeController = TextEditingController(text: initialType ?? 'الفاتورة التجارية');
    final nameController = TextEditingController(text: 'Commercial_Invoice_v2.pdf');

    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text('رفع مستند رسمي للشحنة', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: typeController,
                decoration: const InputDecoration(labelText: 'نوع المستند'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'اسم الملف الجديد'),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
            ElevatedButton(
              onPressed: () {
                ref.read(shippingControllerProvider.notifier).uploadCommercialDoc(
                  s.id,
                  typeController.text,
                  nameController.text,
                  'https://naseeji.com/docs/updated_doc.pdf',
                );
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم رفع وحفظ مستند الإصدار بنجاح.')));
              },
              child: const Text('تأكيد وحفظ'),
            ),
          ],
        ),
      ),
    );
  }
}

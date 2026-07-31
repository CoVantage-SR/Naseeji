import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_factory/core/theme/app_colors.dart';
import '../../domain/entities/shipment.dart';
import '../controllers/shipping_controller.dart';
import '../widgets/document_item_card.dart';

class ShipmentDocumentsScreen extends ConsumerWidget {
  final String shipmentId;

  const ShipmentDocumentsScreen({super.key, required this.shipmentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateAsync = ref.watch(shippingControllerProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: 0.5,
          centerTitle: true,
          title: Text(
            'مستندات الشحنة $shipmentId',
            style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 13),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: AppColors.onSurfaceVariant, size: 20),
            onPressed: () => context.pop(),
          ),
        ),
        body: stateAsync.when(
          loading: () => Center(child: CircularProgressIndicator(color: AppColors.primary)),
          error: (e, _) => Center(child: Text('خطأ: $e')),
          data: (shipments) {
            final shipmentIndex = shipments.indexWhere((s) => s.id == shipmentId);
            if (shipmentIndex == -1) {
              return Center(child: Text('الشحنة غير موجودة'));
            }
            final s = shipments[shipmentIndex];

            final allDocs = s.documents;

            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    boxShadow: [BoxShadow(color: Color(0x05000000), blurRadius: 10)],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.info_outline, color: AppColors.primary, size: 20),
                          SizedBox(width: 8),
                          Text('نظام إدارة الوثائق والإصدارات للطلب ${s.orderNumber}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                        ],
                      ),
                      SizedBox(height: 6),
                      Text(
                        'يدعم النظام أرشفة وحفظ الإصدارات التراكمية للمستندات لضمان التتبع والتدقيق المالي والتخليص الجمركي بنجاح.',
                        style: TextStyle(fontSize: 10, color: AppColors.outline, height: 1.4),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('الملفات المرفوعة (${allDocs.length})', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                    ElevatedButton.icon(
                      onPressed: () => _showUploadDocDialog(context, ref, s),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0040E0),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(0, 32),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      icon: const Icon(Icons.add, size: 14),
                      label: Text('إرفاق مستند جديد', style: TextStyle(fontSize: 11)),
                    ),
                  ],
                ),
                SizedBox(height: 12),

                if (allDocs.isEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Icon(Icons.description_outlined, size: 48, color: AppColors.outlineVariant),
                        SizedBox(height: 8),
                        Text('لا يوجد مستندات رسمية مرفوعة بعد لهذه الشحنة.', style: TextStyle(color: AppColors.outline, fontSize: 11)),
                      ],
                    ),
                  )
                else
                  ...allDocs.map((doc) => DocumentItemCard(
                    s: s,
                    doc: doc,
                    onReplace: () => _showUploadDocDialog(context, ref, s, initialType: doc.type),
                  )),
              ],
            );
          },
        ),
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
          title: Text('رفع مستند رسمي للشحنة', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: typeController,
                decoration: const InputDecoration(labelText: 'نوع المستند'),
              ),
              SizedBox(height: 8),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'اسم الملف الجديد'),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: Text('إلغاء')),
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
              child: Text('تأكيد وحفظ'),
            ),
          ],
        ),
      ),
    );
  }
}



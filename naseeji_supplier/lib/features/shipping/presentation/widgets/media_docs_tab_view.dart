import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../../domain/entities/shipment.dart';
import '../controllers/shipping_controller.dart';
import 'document_item_card.dart';

class MediaDocsTabView extends ConsumerWidget {
  final Shipment s;

  const MediaDocsTabView({super.key, required this.s});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // Commercial Documents Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('مستندات وأوراق الشحن الرسمية', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Theme.of(context).colorScheme.onSurface)),
            IconButton(
              icon: const Icon(Icons.add_circle_outline, color: AppColors.primary, size: 20),
              onPressed: () => _showUploadDocDialog(context, ref, s),
            ),
          ],
        ),
        SizedBox(height: 8),

        if (s.documents.isEmpty)
          Center(child: Text('لا توجد مستندات مرفوعة حالياً', style: TextStyle(fontSize: 11, color: AppColors.outline)))
        else
          ...s.documents.map((doc) => DocumentItemCard(
            s: s,
            doc: doc,
            onReplace: () => _showUploadDocDialog(context, ref, s, initialType: doc.type),
          )),
        SizedBox(height: 24),

        // Media Gallery before / after loading
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('صور وإثباتات الشحن والتحميل', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Theme.of(context).colorScheme.onSurface)),
            IconButton(
              icon: const Icon(Icons.add_a_photo_outlined, color: AppColors.primary, size: 20),
              onPressed: () => _showUploadMediaDialog(context, ref, s),
            ),
          ],
        ),
        SizedBox(height: 8),
        
        _buildMediaCategorySection(context, s, 'قبل الشحن (المنتجات والتعبئة)', 'beforeShipment'),
        SizedBox(height: 12),
        _buildMediaCategorySection(context, s, 'أثناء التحميل (مندوب سمسا/أرامكس)', 'loading'),
        SizedBox(height: 12),
        _buildMediaCategorySection(context, s, 'بعد التسليم ومطابقة الجودة', 'afterShipment'),
      ],
    );
  }

  Widget _buildMediaCategorySection(BuildContext context, Shipment s, String title, String category) {
    final list = s.media[category] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.outline)),
        SizedBox(height: 6),
        if (list.isEmpty)
          Container(
            height: 60,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerLow, borderRadius: BorderRadius.circular(8)),
            child: Text('لم يتم رفع صور/فيديوهات لهذه المرحلة', style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
          )
        else
          SizedBox(
            height: 70,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: list.length,
              itemBuilder: (ctx, i) => Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 8),
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(image: NetworkImage(list[i]), fit: BoxFit.cover),
                    ),
                  ),
                  Positioned(
                    top: 2,
                    right: 10,
                    child: InkWell(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم مسح إثبات الصورة اللوجستية.')));
                      },
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, shape: BoxShape.circle),
                        child: const Icon(Icons.close, size: 10, color: Colors.red),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  void _showUploadDocDialog(BuildContext context, WidgetRef ref, Shipment s, {String? initialType}) {
    final typeController = TextEditingController(text: initialType ?? 'فاتورة تجارية');
    final nameController = TextEditingController(text: 'Invoice_New.pdf');

    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: Text('رفع مستند رسمي جديد', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: typeController,
                decoration: const InputDecoration(labelText: 'نوع المستند (مثل: بوليصة شحن، فاتورة جمركية)'),
              ),
              SizedBox(height: 8),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'اسم الملف المرفوع'),
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
                  'https://naseeji.com/docs/new_doc.pdf',
                );
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم رفع المستند وتحديث الإصدار v2 بنجاح.')));
              },
              child: Text('رفع المستند'),
            ),
          ],
        ),
      ),
    );
  }

  void _showUploadMediaDialog(BuildContext context, WidgetRef ref, Shipment s) {
    String category = 'beforeShipment';
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: Text('رفع إثبات صور الشحنة', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('اختر تصنيف صور التحميل والإثبات:', style: TextStyle(fontSize: 11)),
                SizedBox(height: 8),
                DropdownButton<String>(
                  value: category,
                  isExpanded: true,
                  items: const [
                    DropdownMenuItem(value: 'beforeShipment', child: Text('قبل الشحن (التعبئة والتغليف)')),
                    DropdownMenuItem(value: 'loading', child: Text('أثناء التحميل (مندوب سمسا/أرامكس)')),
                    DropdownMenuItem(value: 'afterShipment', child: Text('بعد التسليم ومطابقة الجودة')),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      setDialogState(() {
                        category = val;
                      });
                    }
                  },
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: Text('إلغاء')),
              ElevatedButton(
                onPressed: () {
                  ref.read(shippingControllerProvider.notifier).uploadProofMedia(
                    s.id,
                    category,
                    'https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?auto=format&fit=crop&w=300&q=80',
                  );
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم رفع صورة إثبات الشحن بنجاح.')));
                },
                child: Text('رفع صورة'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

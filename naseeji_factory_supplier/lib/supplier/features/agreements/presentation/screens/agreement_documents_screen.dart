import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_factory/core/theme/app_colors.dart';
import '../controllers/agreements_controller.dart';
import '../widgets/agreement_document_card.dart';

class AgreementDocumentsScreen extends ConsumerWidget {
  final String agreementId;

  const AgreementDocumentsScreen({super.key, required this.agreementId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateAsync = ref.watch(agreementsControllerProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: 0.5,
          centerTitle: true,
          title: Text(
            'مستندات اتفاقية الشراكة $agreementId',
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
          data: (agreements) {
            final agreementIndex = agreements.indexWhere((a) => a.id == agreementId);
            if (agreementIndex == -1) {
              return Center(child: Text('الاتفاقية غير موجودة'));
            }
            final a = agreements[agreementIndex];

            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                // Informational Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    boxShadow: [BoxShadow(color: Color(0x05000000), blurRadius: 10)],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.folder_open, color: AppColors.primary, size: 22),
                          SizedBox(width: 8),
                          Text('مركز أرشفة وثائق العقد للطلب ${a.orderNumber}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                        ],
                      ),
                      SizedBox(height: 6),
                      Text(
                        'يتضمن هذا القسم كافة الوثائق الرسمية، الفواتير الجمركية، بوالص الشحن، وشهادات فحص الجودة الموقعة والمعتمدة إلكترونياً من الطرفين بنسيجي.',
                        style: TextStyle(fontSize: 10, color: AppColors.outline, height: 1.4),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),

                // Upload button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('الوثائق الحالية (${a.documents.length})', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                    ElevatedButton.icon(
                      onPressed: () => _showUploadDocDialog(context, ref, a.id),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0040E0),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(0, 32),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      icon: const Icon(Icons.add, size: 14),
                      label: Text('إرفاق ملف رسمي جديد', style: TextStyle(fontSize: 10)),
                    ),
                  ],
                ),
                SizedBox(height: 12),

                if (a.documents.isEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    alignment: Alignment.center,
                    child: Text('لا توجد مستندات رسمية مرفوعة حالياً', style: TextStyle(color: AppColors.outline, fontSize: 11)),
                  )
                else
                  ...a.documents.map((doc) => AgreementDocumentCard(
                    doc: doc,
                    onReplace: () => _showUploadDocDialog(context, ref, a.id, initialType: doc.type),
                  )),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showUploadDocDialog(BuildContext context, WidgetRef ref, String id, {String? initialType}) {
    final typeController = TextEditingController(text: initialType ?? 'عقد التوريد الأساسي');
    final nameController = TextEditingController(text: 'Contract_Updated.pdf');

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
                decoration: const InputDecoration(labelText: 'نوع الوثيقة'),
              ),
              SizedBox(height: 8),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'اسم الملف'),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: Text('إلغاء')),
            ElevatedButton(
              onPressed: () {
                ref.read(agreementsControllerProvider.notifier).uploadDoc(
                  id,
                  typeController.text,
                  nameController.text,
                  'https://naseeji.com/docs/new_doc.pdf',
                );
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم رفع وتحديث مستند الاتفاقية بنجاح.')));
              },
              child: Text('تأكيد وحفظ الملف'),
            ),
          ],
        ),
      ),
    );
  }
}



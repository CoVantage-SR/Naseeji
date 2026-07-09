import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../../domain/entities/agreement_model.dart';
import '../controllers/agreements_controller.dart';

class AgreementActionButtons extends ConsumerWidget {
  final B2BAgreement a;

  const AgreementActionButtons({super.key, required this.a});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Pending Approval
    if (a.status == AgreementStatus.pendingApproval) {
      return Container(
        color: Theme.of(context).colorScheme.surface,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => _showRejectDialog(context, ref, a.id),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  minimumSize: const Size(0, 42),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text('رفض وإلغاء', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: OutlinedButton(
                onPressed: () => _showModificationDialog(context, ref, a.id),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  minimumSize: const Size(0, 42),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text('طلب تعديل البنود', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  await ref.read(agreementsControllerProvider.notifier).approve(a.id);
                  messenger.showSnackBar(const SnackBar(content: Text('تم توقيع واعتماد الاتفاقية من جانبك كمورد بنجاح.')));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0040E0),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(0, 42),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text('توقيع واعتماد العقد', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      );
    }

    // 2. Active
    if (a.status == AgreementStatus.active) {
      return Container(
        color: Theme.of(context).colorScheme.surface,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  context.push('/chat/business-chat?factoryName=${Uri.encodeComponent(a.factoryInfo.factoryName)}');
                },
                icon: const Icon(Icons.chat_outlined, size: 14),
                label: Text('محادثة المشتري', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  minimumSize: const Size(0, 42),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  context.push('/shipping');
                },
                icon: const Icon(Icons.local_shipping_outlined, size: 14),
                label: Text('تفاصيل الشحن', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.secondary,
                  side: const BorderSide(color: AppColors.secondary),
                  minimumSize: const Size(0, 42),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم تنزيل العقد المعتمد والموثق كملف PDF.')));
                },
                icon: const Icon(Icons.download_outlined, size: 14),
                label: Text('تنزيل العقد الموثق', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0040E0),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(0, 42),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // 3. Completed
    if (a.status == AgreementStatus.completed) {
      return Container(
        color: Theme.of(context).colorScheme.surface,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => _showRatingDialog(context, a.factoryInfo.factoryName),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  minimumSize: const Size(0, 44),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text('تقييم المشتري والمصنع', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم بدء طلب إعادة توريد بنفس بنود الاتفاقية.')));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(0, 44),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text('إعادة طلب التوريد (Reorder)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
              ),
            ),
          ],
        ),
      );
    }

    // 4. Cancelled / Expired
    if (a.status == AgreementStatus.cancelled) {
      return Container(
        color: Theme.of(context).colorScheme.surface,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  context.push('/chat/business-chat?factoryName=${Uri.encodeComponent(a.factoryInfo.factoryName)}');
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  minimumSize: const Size(0, 44),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text('الاتصال بالمشتري للتسوية', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
              ),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }

  void _showRejectDialog(BuildContext context, WidgetRef ref, String id) {
    final reasonController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: Text('رفض وتجميد الاتفاقية', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          content: TextField(
            controller: reasonController,
            decoration: const InputDecoration(labelText: 'سبب الرفض والتراجع عن الاتفاقية'),
            maxLines: 2,
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: Text('إلغاء')),
            ElevatedButton(
              onPressed: () async {
                if (reasonController.text.isNotEmpty) {
                  final messenger = ScaffoldMessenger.of(context);
                  final nav = Navigator.of(ctx);
                  await ref.read(agreementsControllerProvider.notifier).reject(id, reasonController.text);
                  nav.pop();
                  messenger.showSnackBar(const SnackBar(content: Text('تم رفض وإلغاء مسودة الاتفاقية.')));
                }
              },
              child: Text('تأكيد الرفض'),
            ),
          ],
        ),
      ),
    );
  }

  void _showModificationDialog(BuildContext context, WidgetRef ref, String id) {
    final notesController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: Text('طلب تعديل بنود العقد والاتفاقية', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          content: TextField(
            controller: notesController,
            decoration: const InputDecoration(labelText: 'الملاحظات والبنود المراد تعديلها'),
            maxLines: 3,
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: Text('إلغاء')),
            ElevatedButton(
              onPressed: () async {
                if (notesController.text.isNotEmpty) {
                  final messenger = ScaffoldMessenger.of(context);
                  final nav = Navigator.of(ctx);
                  await ref.read(agreementsControllerProvider.notifier).modify(id, notesController.text);
                  nav.pop();
                  messenger.showSnackBar(const SnackBar(content: Text('تم إرسال طلب التعديل للمشتري وتحديث نسخة المسودة.')));
                }
              },
              child: Text('إرسال طلب التعديل'),
            ),
          ],
        ),
      ),
    );
  }

  void _showRatingDialog(BuildContext context, String name) {
    double rating = 5.0;
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: Text('تقييم المشتري: $name', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) => IconButton(
                icon: Icon(index < rating ? Icons.star : Icons.star_border, color: Colors.amber),
                onPressed: () {
                  setDialogState(() {
                    rating = (index + 1).toDouble();
                  });
                },
              )),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: Text('إلغاء')),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('شكرًا لتقييمك لمصنع المشتري في نسيجي.')));
                },
                child: Text('تقديم التقييم'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

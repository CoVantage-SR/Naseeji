import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/agreement_model.dart';
import '../../domain/services/agreement_service.dart';
import '../controllers/agreements_controller.dart';

class AgreementActionButtons extends ConsumerWidget {
  final B2BAgreement a;

  const AgreementActionButtons({super.key, required this.a});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final service = ref.watch(agreementServiceProvider);

    // 1. Awaiting Supplier Signature
    if (a.status == AgreementStatus.awaitingSupplierSignature) {
      return Container(
        color: Theme.of(context).colorScheme.surface,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => _showRejectDialog(context, service, a.id, ref),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  minimumSize: const Size(0, 42),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('رفض وإلغاء', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  await service.signAgreementBySupplier(
                    a.id,
                    supplierUserId: 'SUP-100',
                    supplierUserName: a.supplierInfo.supplierName,
                  );
                  ref.invalidate(agreementsControllerProvider);
                  ref.invalidate(agreementDetailsProvider(a.id));
                  messenger.showSnackBar(
                    const SnackBar(content: Text('تم توقيع الاتفاقية بنجاح وفي انتظار توقيع المصنع.')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(0, 42),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('توقيع الاتفاقية', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
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
                  context.push('/messages');
                },
                icon: const Icon(Icons.chat_outlined, size: 14),
                label: const Text('محادثة المصنع', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  minimumSize: const Size(0, 42),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () async {
                  await service.startProduction(a.id);
                  ref.invalidate(agreementsControllerProvider);
                  ref.invalidate(agreementDetailsProvider(a.id));
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('بدأت خطة التصنيع والإنتاج الفعلي بنجاح! 🚀')),
                    );
                  }
                },
                icon: const Icon(Icons.precision_manufacturing_outlined, size: 14),
                label: const Text('بدء التصنيع', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B5CF6),
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
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تم تنزيل النسخة المؤرشفة للعقد بنجاح.')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF16A34A),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(0, 44),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('تنزيل العقد المكتمل PDF', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
              ),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }

  void _showRejectDialog(BuildContext context, AgreementService service, String id, WidgetRef ref) {
    final reasonController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text('إلغاء الاتفاقية', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          content: TextField(
            controller: reasonController,
            decoration: const InputDecoration(labelText: 'سبب الإلغاء والتراجع'),
            maxLines: 2,
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
            ElevatedButton(
              onPressed: () async {
                if (reasonController.text.isNotEmpty) {
                  final messenger = ScaffoldMessenger.of(context);
                  final nav = Navigator.of(ctx);
                  await service.cancelAgreement(id, reasonController.text);
                  ref.invalidate(agreementsControllerProvider);
                  ref.invalidate(agreementDetailsProvider(id));
                  nav.pop();
                  messenger.showSnackBar(const SnackBar(content: Text('تم إلغاء الاتفاقية بنجاح.')));
                }
              },
              child: const Text('تأكيد الإلغاء'),
            ),
          ],
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naseeji_factory/supplier/features/deals/domain/entities/deal_model.dart';
import 'package:naseeji_factory/supplier/features/deals/presentation/controllers/deals_controller.dart';

class QualityWidget extends ConsumerWidget {
  final DealModel deal;

  const QualityWidget({super.key, required this.deal});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final qual = deal.quality;

    final isAccepted = qual?.isAccepted ?? false;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isAccepted ? Colors.green.shade50 : Colors.amber.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isAccepted ? Colors.green.shade300 : Colors.amber.shade300),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      isAccepted ? Icons.check_circle_rounded : Icons.fact_check_outlined,
                      color: isAccepted ? Colors.green : Colors.amber.shade900,
                      size: 20,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'نتيجة فحص المعايرة والجودة بالمنشأة',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isAccepted ? Colors.green.shade900 : Colors.amber.shade900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  qual?.statusText ?? 'المصنع يقوم بفحص جودة الخيوط/الأقمشة وااختبار المعايرة حالياً.',
                  style: const TextStyle(fontSize: 11, color: Colors.black87, fontWeight: FontWeight.bold),
                ),
                if (qual?.notes != null) ...[
                  const SizedBox(height: 4),
                  Text('ملاحظات الفحص: ${qual!.notes}', style: const TextStyle(fontSize: 10, color: Colors.black54)),
                ],
                const SizedBox(height: 12),

                if (!isAccepted)
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _confirmQuality(context, ref, true),
                          icon: const Icon(Icons.check_rounded, size: 16),
                          label: const Text('تأكيد قبول الجودة وإتاحة الدفع'),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Standard quality compliance card
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('معايير فحص الجودة المعتمدة بالمنصة:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                SizedBox(height: 6),
                Text('• مطابقة نسبة القطن/الصوف والوزن لشهادة الفحص.', style: TextStyle(fontSize: 9.5, height: 1.3)),
                Text('• خلو الأثواب من أي عيوب غزل أو انسلاح أو التواء عرضي.', style: TextStyle(fontSize: 9.5, height: 1.3)),
                Text('• ثبات ألوان الغسيل الاحترافي لدرجة 40 مئوية.', style: TextStyle(fontSize: 9.5, height: 1.3)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmQuality(BuildContext context, WidgetRef ref, bool accepted) async {
    final success = await ref.read(dealsControllerProvider.notifier).updateQuality(
          dealId: deal.id,
          isAccepted: accepted,
          inspectionPhotoUrls: [],
          notes: accepted ? 'تم قبول نتائج المعايرة وتأكيد مطابقة الجودة 100%' : 'تم تقديم ملاحظات عدم مطابقة',
        );

    if (context.mounted && success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم تأكيد قبول الجودة! تحولت الصفقة لمرحلة "بانتظار الدفع" 💳'), backgroundColor: Colors.green),
      );
    }
  }
}



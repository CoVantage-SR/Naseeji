import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naseeji_supplier/features/deals/domain/entities/deal_model.dart';
import 'package:naseeji_supplier/features/deals/presentation/controllers/deals_controller.dart';

class AgreementWidget extends ConsumerWidget {
  final DealModel deal;

  const AgreementWidget({super.key, required this.deal});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final ag = deal.agreement;

    final supplierSigned = ag?.supplierSigned ?? false;
    final factorySigned = ag?.factorySigned ?? false;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.history_edu_rounded, size: 18, color: colorScheme.primary),
                    const SizedBox(width: 6),
                    Text(
                      'العقد والاتفاق المعتمد إلكترونياً (Contract Agreement)',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: colorScheme.primary),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'رقم الاتفاق: ${ag?.agreementNumber ?? 'AGR-PENDING'}',
                  style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
                ),
                const SizedBox(height: 10),

                // Signature Status Boxes
                Row(
                  children: [
                    Expanded(
                      child: _buildSignatureBox(
                        context,
                        title: 'توقيع المورد (منشأتك)',
                        isSigned: supplierSigned,
                        signedAt: ag?.supplierSignedAt,
                        onSign: () => _signAgreement(context, ref),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildSignatureBox(
                        context,
                        title: 'توقيع المصنع (المشتري)',
                        isSigned: factorySigned,
                        signedAt: ag?.factorySignedAt,
                        onSign: null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Document Terms Preview Box
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.3)),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('شروط عقد التوريد الأساسية:', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text('• يتعهد المورد بتوريد خامة مطابقة للمواصفات المعملية المرفقة بالكتالوج.', style: TextStyle(fontSize: 9, height: 1.3)),
                      Text('• يتم حجز الدفعة المدمجة بالضمان البنكي الإلكتروني لمنصة نسيجي (Escrow).', style: TextStyle(fontSize: 9, height: 1.3)),
                      Text('• يتم الإفراج عن المستحقات فور فحص الجودة وتأكيد القبول.', style: TextStyle(fontSize: 9, height: 1.3)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignatureBox(
    BuildContext context, {
    required String title,
    required bool isSigned,
    required DateTime? signedAt,
    required VoidCallback? onSign,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isSigned ? const Color(0xFFDCFCE7) : const Color(0xFFFEF3C7),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isSigned ? Colors.green : Colors.amber),
      ),
      child: Column(
        children: [
          Icon(
            isSigned ? Icons.verified_rounded : Icons.pending_actions_rounded,
            color: isSigned ? Colors.green.shade800 : Colors.amber.shade900,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          const SizedBox(height: 2),
          Text(
            isSigned ? 'تم التوقيع الإلكتروني' : 'بانتظار الاعتماد',
            style: TextStyle(fontSize: 8.5, color: isSigned ? Colors.green.shade900 : Colors.amber.shade900, fontWeight: FontWeight.bold),
          ),
          if (isSigned && signedAt != null)
            Text(
              '${signedAt.day}/${signedAt.month}/${signedAt.year}',
              style: TextStyle(fontSize: 8, color: colorScheme.outline),
            ),
          if (!isSigned && onSign != null) ...[
            const SizedBox(height: 6),
            ElevatedButton(
              onPressed: onSign,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text('توقيع الآن ✍️', style: TextStyle(fontSize: 9)),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _signAgreement(BuildContext context, WidgetRef ref) async {
    final success = await ref.read(dealsControllerProvider.notifier).signAgreement(deal.id);
    if (context.mounted && success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم توقيع العقد بنجاح! يمكن بدء الإنتاج الآن 🏭'), backgroundColor: Colors.green),
      );
    }
  }
}

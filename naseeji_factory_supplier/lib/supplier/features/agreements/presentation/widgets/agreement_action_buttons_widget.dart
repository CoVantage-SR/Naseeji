import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/agreement_model.dart';
import '../controllers/agreements_controller.dart';

class AgreementActionButtonsWidget extends ConsumerWidget {
  final B2BAgreement agreement;

  const AgreementActionButtonsWidget({super.key, required this.agreement});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
        border: Border(
          top: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Primary Action Button depending on status
            if (agreement.canSupplierSign) ...[
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('يرجى الموافقة على مربع التعهد بالأسفل وتوقيع العقد.'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.draw_outlined, size: 18),
                  label: const Text('توقيع الاتفاقية الآن'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(0, 46),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ] else if (agreement.status == AgreementStatus.active) ...[
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final service = ref.read(agreementServiceProvider);
                    await service.startProduction(agreement.id);
                    ref.invalidate(agreementsControllerProvider);
                    ref.invalidate(agreementDetailsProvider(agreement.id));
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('تم بدء التصنيع والإنتاج الفعلي بنجاح! 🚀'),
                          backgroundColor: Colors.purple,
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.precision_manufacturing_outlined, size: 18),
                  label: const Text('بدء التصنيع والإنتاج'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B5CF6),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(0, 46),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],

            // Secondary PDF Download Action
            OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('جاري تحميل نسخة PDF الموثقة للاتفاقية رقم ${agreement.id}...'),
                  ),
                );
              },
              icon: const Icon(Icons.download_outlined, size: 18),
              label: const Text('تحميل العقد PDF'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(0, 46),
                foregroundColor: colorScheme.onSurface,
                side: BorderSide(color: colorScheme.outlineVariant),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Go to Chat / RFQ Action
            IconButton.filledTonal(
              onPressed: () {
                context.push('/rfq-details?rfqId=${agreement.rfqNumber}');
              },
              icon: const Icon(Icons.visibility_outlined, size: 20),
              tooltip: 'عرض طلب RFQ الأصلي',
            ),
          ],
        ),
      ),
    );
  }
}




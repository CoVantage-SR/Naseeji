import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/agreement_model.dart';
import '../controllers/agreements_controller.dart';

class AgreementSignatureWidget extends ConsumerWidget {
  final B2BAgreement agreement;

  const AgreementSignatureWidget({super.key, required this.agreement});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final isAgreed = ref.watch(agreementSignatureControllerProvider(agreement.id));
    final canSign = agreement.canSupplierSign;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
          ),
        ],
        border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.draw_outlined, color: AppColors.primary, size: 18),
              const SizedBox(width: 8),
              Text(
                'القسم السابع: التوقيع الرقمي والاعتماد الرسمي',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(height: 1),
          const SizedBox(height: 12),

          // Supplier Signature Card Log
          _buildSignatureLogCard(
            context,
            title: 'توقيع المورد (الطرف الأول)',
            sig: agreement.supplierSignature,
            defaultName: agreement.supplierInfo.supplierName,
          ),
          const SizedBox(height: 10),

          // Factory Signature Card Log
          _buildSignatureLogCard(
            context,
            title: 'توقيع المصنع (الطرف الثاني)',
            sig: agreement.factorySignature,
            defaultName: agreement.factoryInfo.contactPerson,
          ),
          const SizedBox(height: 14),

          // Checkbox Consent & Action Button for Supplier Signing
          if (canSign) ...[
            Material(
              color: AppColors.primary.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(10),
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: AppColors.primary.withValues(alpha: 0.2)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                dense: true,
                value: isAgreed,
                onChanged: (val) {
                  ref
                      .read(agreementSignatureControllerProvider(agreement.id).notifier)
                      .toggleAgreementConsent(val);
                },
                title: Text(
                  'أوافق على جميع بنود وشروط هذا الاتفاق وأتعهد بالالتزام التام بالإنتاج والتوريد.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                activeColor: AppColors.primary,
                controlAffinity: ListTileControlAffinity.leading,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: isAgreed
                    ? () async {
                        final success = await ref
                            .read(agreementSignatureControllerProvider(agreement.id).notifier)
                            .signAgreement(
                              supplierUserId: 'SUP-100',
                              supplierUserName: agreement.supplierInfo.supplierName,
                            );
                        if (success && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'تم توقيع الاتفاقية بنجاح! وتم تحويل الحالة إلى "بانتظار توقيع المصنع".',
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      }
                    : null,
                icon: const Icon(Icons.drive_file_rename_outline, size: 18),
                label: const Text(
                  'توقيع الاتفاق رسمياً',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(0, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSignatureLogCard(
    BuildContext context, {
    required String title,
    required SignatureInfo? sig,
    required String defaultName,
  }) {
    final theme = Theme.of(context);
    final isSigned = sig?.isSigned == true;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isSigned
            ? const Color(0xFF16A34A).withValues(alpha: 0.05)
            : theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isSigned
              ? const Color(0xFF16A34A).withValues(alpha: 0.3)
              : theme.colorScheme.outlineVariant,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isSigned ? Icons.verified : Icons.hourglass_empty,
            color: isSigned ? const Color(0xFF16A34A) : theme.colorScheme.outline,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: isSigned ? const Color(0xFF16A34A) : Colors.orange,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        isSigned ? 'تم التوقيع' : 'في الانتظار',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                if (isSigned) ...[
                  Text(
                    'تم التوقيع بواسطة: ${sig?.userName} (مُعرف: ${sig?.userId})',
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'في: ${sig?.date} • الساعة: ${sig?.time}',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.outline,
                      fontSize: 9,
                    ),
                  ),
                ] else ...[
                  Text(
                    'بانتظار توقيع $defaultName...',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}




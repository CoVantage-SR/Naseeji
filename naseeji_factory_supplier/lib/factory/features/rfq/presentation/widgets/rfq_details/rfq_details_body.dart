import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_factory/core/constants/app_colors.dart';
import 'package:naseeji_factory/core/constants/app_radius.dart';
import 'package:naseeji_factory/core/constants/app_spacing.dart';
import 'package:naseeji_factory/core/extensions/context_extensions.dart';
import 'package:naseeji_factory/core/widgets/reusable_widgets.dart';

import '../../providers/rfq_provider.dart';
import '../rfq_details_widgets.dart';

class RFQDetailsBody extends ConsumerWidget {
  final RFQ rfq;

  const RFQDetailsBody({super.key, required this.rfq});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(rFQNotifierProvider.notifier);
    final isDark = context.theme.brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RFQStatusHeaderWidget(rfq: rfq),
          AppSpacing.hMD,
          RFQTimelineWidget(status: rfq.status),
          AppSpacing.hMD,
          ProductInformationWidget(rfq: rfq),
          AppSpacing.hMD,
          // Attachments
          if (rfq.attachments.isNotEmpty) ...[
            PrimaryCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ملفات التوريد المرفقة',
                    style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  AppSpacing.hSM,
                  for (final att in rfq.attachments)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: InkWell(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('تحميل ملف: $att')),
                          );
                        },
                        borderRadius: AppRadius.rMD,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.borderDark : Colors.grey.shade100,
                            borderRadius: AppRadius.rMD,
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.insert_drive_file_outlined, color: AppColors.primary, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  att,
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const Icon(Icons.download_rounded, color: Colors.grey, size: 18),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            AppSpacing.hMD,
          ],
          // Delivery Location Card
          PrimaryCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'شروط وعنوان التوصيل المحددة',
                  style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                const Divider(),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, color: AppColors.primary, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      '${rfq.deliveryCity}، ${rfq.deliveryGovernorate}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.only(right: 24.0),
                  child: Text(
                    rfq.deliveryAddress,
                    style: const TextStyle(color: Colors.grey, fontSize: 11),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.calendar_month_outlined, color: AppColors.primary, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      'تاريخ التوصيل النهائي المطلوبة: ${rfq.deliveryDate}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Action Buttons
          Row(
            children: [
              if (rfq.status != 'rejected') ...[
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      notifier.cancelRFQ(rfq.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('تم إلغاء طلب عرض السعر هذا بنجاح.')),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: AppColors.error),
                      foregroundColor: AppColors.error,
                      shape: RoundedRectangleBorder(borderRadius: AppRadius.rMD),
                    ),
                    child: const Text('إلغاء طلب الـ RFQ'),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              if (rfq.receivedQuotesCount > 0)
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => context.push('/rfq/${rfq.id}/quotations'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: AppRadius.rMD),
                    ),
                    child: Text('استعراض العروض (${rfq.receivedQuotesCount})'),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}




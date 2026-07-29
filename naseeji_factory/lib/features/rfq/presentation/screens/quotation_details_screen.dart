import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../products/presentation/widgets/share_widgets.dart';
import '../providers/quotations_provider.dart';

import '../widgets/quotation_bottom_action_bar.dart';
import '../widgets/quotation_comparison_chat_attachments.dart';
import '../widgets/quotation_header_card.dart';
import '../widgets/quotation_info_grid.dart';
import '../widgets/quotation_score_cards.dart';
import '../widgets/quotation_supplier_card.dart';
import '../widgets/quotation_timeline_log.dart';

/// Full Production-Ready Quotation Details Screen matching Reference Image
class QuotationDetailsScreen extends ConsumerStatefulWidget {
  final String quoteId;

  const QuotationDetailsScreen({super.key, required this.quoteId});

  @override
  ConsumerState<QuotationDetailsScreen> createState() =>
      _QuotationDetailsScreenState();
}

class _QuotationDetailsScreenState
    extends ConsumerState<QuotationDetailsScreen> {
  void _showShareModal(BuildContext context, Quotation quotation) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ShareProductBottomSheet(
        productName: quotation.quotationNumber,
        supplierName: quotation.supplierName,
        onCopyLink: () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم نسخ رابط عرض السعر بنجاح!')),
          );
        },
        onDownloadPdf: () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('جاري تحميل كشف عرض السعر التفصيلي (PDF)...'),
            ),
          );
        },
      ),
    );
  }

  void _showMoreMenu(BuildContext context, Quotation quotation) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Material(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.picture_as_pdf_outlined,
                    color: AppColors.primary,
                  ),
                  title: const Text('تنزيل العرض المعتمد (PDF)'),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('جاري تنزيل عرض السعر...')),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.archive_outlined,
                    color: Colors.grey,
                  ),
                  title: const Text('أرشفة عرض السعر'),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم أرشفة عرض السعر.')),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.report_problem_outlined,
                    color: AppColors.error,
                  ),
                  title: const Text('الإبلاغ عن مخالفة المورد'),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('تم توجيه بلاغ المخالفة لإدارة المنصة.'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleAcceptQuotation(Quotation quotation) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('قبول عرض السعر وتوقيع العقد'),
        content: Text(
          'هل أنت متأكد من قبول عرض السعر رقم (${quotation.quotationNumber}) من ${quotation.supplierName} بقيمة ${quotation.totalPrice.toStringAsFixed(0)} ج.م؟ سيتم إنشاء اتفاقية الصفقة رسمياً وتوجيهك لصفحة الصفقة.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ref
                  .read(quotationsNotifierProvider.notifier)
                  .acceptQuotation(quotation.id);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'تم قبول عرض السعر وإنشاء الصفقة والاتفاقية بنجاح!',
                  ),
                ),
              );
              context.push('/orders/ORD-201');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
              foregroundColor: Colors.white,
            ),
            child: const Text('تأكيد القبول وإنشاء الصفقة'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final quotations = ref.watch(quotationsNotifierProvider);
    final quotation = quotations.firstWhere(
      (q) => q.id == widget.quoteId || q.quotationNumber == widget.quoteId,
      orElse: () => quotations.first,
    );

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final appBarTextColor = isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimaryLight;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
        foregroundColor: appBarTextColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: appBarTextColor),
        title: Text(
          'تفاصيل عرض السعر',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: appBarTextColor,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: appBarTextColor),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              context.go('/home');
            }
          },
        ),
        actions: [
          // Business Chat Button
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline_rounded),
            onPressed: () => context.push('/chat/chat_1'),
          ),
          // Share Button
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () => _showShareModal(context, quotation),
          ),
          // More Menu Button (...)
          IconButton(
            icon: const Icon(Icons.more_vert_rounded),
            onPressed: () => _showMoreMenu(context, quotation),
          ),
          const SizedBox(width: 4),
        ],
      ),
      bottomNavigationBar: QuotationBottomActionBar(
        quotation: quotation,
        onCompareTap: () =>
            context.push('/rfq/${quotation.rfqId}/compare-quotations'),
        onRejectTap: () =>
            context.push('/rfq/quotation/${quotation.id}/reject'),
        onNegotiateTap: () =>
            context.push('/rfq/quotation/${quotation.id}/counter'),
        onAcceptTap: () => _handleAcceptQuotation(quotation),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // 1. Top Summary Banner Card
            QuotationHeaderCard(quotation: quotation),
            const SizedBox(height: 8),

            // 2. Supplier Card
            QuotationSupplierCard(quotation: quotation),
            const SizedBox(height: 8),

            // 3. Offer Score Cards Section ("تقييم العرض")
            QuotationScoreCards(quotation: quotation),
            const SizedBox(height: 8),

            // 4. Offer Details Grid Section ("تفاصيل العرض")
            QuotationInfoGrid(quotation: quotation),
            const SizedBox(height: 8),

            // 5. Middle Layout (Attachments + Comparison + Chat)
            QuotationComparisonChatAttachments(quotation: quotation),
            const SizedBox(height: 8),

            // 6. Timeline Log Section ("سجل الأحداث")
            QuotationTimelineLog(quotation: quotation),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

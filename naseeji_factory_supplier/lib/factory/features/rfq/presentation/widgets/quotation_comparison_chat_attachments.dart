import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../products/presentation/widgets/product_details/documents_widget.dart';
import '../providers/quotations_provider.dart';

/// Middle Layout matching Reference Image:
/// Left: Attachments Card (4 Files + Download All)
/// Right: Comparison Card + Business Chat Card
class QuotationComparisonChatAttachments extends StatelessWidget {
  final Quotation quotation;

  const QuotationComparisonChatAttachments({super.key, required this.quotation});

  void _openPdfModal(BuildContext context, String docTitle) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PdfViewerModal(
        docTitle: docTitle,
        docType: 'مستند عرض سعر معتمد PDF',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Column (In RTL): Attachments Card
        Expanded(
          flex: 5,
          child: _buildAttachmentsCard(context, isDark: isDark, primaryColor: primaryColor),
        ),
        const SizedBox(width: 12),

        // Right Column (In RTL): Comparison Card + Chat Card
        Expanded(
          flex: 5,
          child: Column(
            children: [
              _buildComparisonCard(context, isDark: isDark, primaryColor: primaryColor),
              const SizedBox(height: 12),
              _buildChatCard(context, isDark: isDark, primaryColor: primaryColor),
            ],
          ),
        ),
      ],
    );
  }

  // Attachments Card (Left in RTL)
  Widget _buildAttachmentsCard(BuildContext context, {required bool isDark, required Color primaryColor}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: AppRadius.rMD,
        border: Border.all(color: isDark ? AppColors.borderDark : Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('المرفقات (4)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              Text('عرض الكل (4)', style: TextStyle(fontSize: 10, color: primaryColor, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 10),

          ...quotation.docAttachments.map((doc) {
            final isPdf = doc.type == 'PDF';
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: InkWell(
                onTap: () => _openPdfModal(context, doc.name),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: (isPdf ? Colors.red : Colors.orange).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Icon(
                        isPdf ? Icons.picture_as_pdf_outlined : Icons.folder_zip_outlined,
                        size: 16,
                        color: isPdf ? Colors.red : Colors.orange.shade800,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            doc.name,
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '${doc.type} • ${doc.size}',
                            style: TextStyle(fontSize: 9, color: Colors.grey.shade500),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 8),

          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('جاري تحميل جميع ملفات العرض (ZIP)...')),
                );
              },
              icon: Icon(Icons.download_rounded, size: 16, color: primaryColor),
              label: Text('تحميل الكل', style: TextStyle(fontSize: 11, color: primaryColor, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  // Comparison Card (Right Top in RTL)
  Widget _buildComparisonCard(BuildContext context, {required bool isDark, required Color primaryColor}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: AppRadius.rMD,
        border: Border.all(color: isDark ? AppColors.borderDark : Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('مقارنة بالعروض الأخرى', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              Text('عرض الكل', style: TextStyle(fontSize: 10, color: primaryColor, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 10),

          // Price range metric
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: primaryColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                child: Icon(Icons.bar_chart_rounded, size: 16, color: primaryColor),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('نطاق السعر للوحدة', style: TextStyle(fontSize: 9, color: Colors.grey.shade500)),
                    Text(quotation.priceRange, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Rank metric
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                child: const Icon(Icons.military_tech_rounded, size: 16, color: AppColors.success),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ترتيب هذا العرض', style: TextStyle(fontSize: 9, color: Colors.grey.shade500)),
                    Text(quotation.offerRank, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.success)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => context.push('/rfq/${quotation.rfqId}/compare-quotations'),
              style: OutlinedButton.styleFrom(
                foregroundColor: primaryColor,
                side: BorderSide(color: primaryColor.withValues(alpha: 0.5)),
                padding: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              ),
              child: const Text('مقارنة العروض', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  // Business Chat Card (Right Bottom in RTL)
  Widget _buildChatCard(BuildContext context, {required bool isDark, required Color primaryColor}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: AppRadius.rMD,
        border: Border.all(color: isDark ? AppColors.borderDark : Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('المحادثة مع المورد', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text('استفسر أو تفاوض مع المورد مباشرة', style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => context.push('/chat/chat_1'),
              icon: const Icon(Icons.chat_bubble_outline_rounded, size: 14),
              label: const Text('فتح المحادثة', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              style: OutlinedButton.styleFrom(
                foregroundColor: primaryColor,
                side: BorderSide(color: primaryColor.withValues(alpha: 0.5)),
                padding: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



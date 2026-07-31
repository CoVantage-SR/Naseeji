import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_radius.dart';

/// Available documents section matching reference screenshot:
/// - Header: "المستندات المتاحة" with "عرض الكل"
/// - Cards: "تقرير اختبار القماش", "شهادة الجودة", "دليل المواصفات" with PDF icon
/// - Tap opens interactive PDF Viewer Modal with view, download, share options
class AvailableDocumentsWidget extends StatelessWidget {
  final String productId;
  final VoidCallback? onViewAll;

  const AvailableDocumentsWidget({
    super.key,
    required this.productId,
    this.onViewAll,
  });

  void _openPdfViewer(BuildContext context, String docTitle, String docType) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PdfViewerModal(
        docTitle: docTitle,
        docType: docType,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    final docs = [
      {'title': 'تقرير اختبار القماش', 'type': 'PDF', 'size': '1.2 MB'},
      {'title': 'شهادة الجودة', 'type': 'PDF', 'size': '850 KB'},
      {'title': 'دليل المواصفات', 'type': 'PDF', 'size': '2.4 MB'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'المستندات المتاحة',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
            TextButton(
              onPressed: onViewAll,
              style: TextButton.styleFrom(
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
              ),
              child: Text(
                'عرض الكل',
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        // Horizontal Scrollable Cards
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: docs.map((doc) {
              return GestureDetector(
                onTap: () => _openPdfViewer(context, doc['title']!, doc['type']!),
                child: Container(
                  width: 155,
                  margin: const EdgeInsets.only(left: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surfaceDark : Colors.blue.shade50.withValues(alpha: 0.4),
                    borderRadius: AppRadius.rSM,
                    border: Border.all(
                      color: isDark ? AppColors.borderDark : Colors.blue.shade100,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              doc['title']!,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: isDark ? AppColors.textPrimaryDark : Colors.grey.shade900,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              doc['type']!,
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.picture_as_pdf_outlined,
                          color: Colors.blue,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

/// Interactive PDF Viewer Bottom Sheet / Modal with simulated document viewer, download & share
class PdfViewerModal extends StatelessWidget {
  final String docTitle;
  final String docType;

  const PdfViewerModal({
    super.key,
    required this.docTitle,
    required this.docType,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isDark ? AppColors.borderDark : Colors.grey.shade200,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.picture_as_pdf_rounded, color: Colors.red, size: 24),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            docTitle,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'وثيقة رسمية معتمدة • PDF',
                            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.share_outlined),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('تم تجهيز رابط الوثيقة للمشاركة')),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              // Document Simulated Canvas
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.backgroundDark : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'NASEEJI CERTIFIED DOCUMENT',
                              style: TextStyle(
                                letterSpacing: 1.2,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                                fontSize: 11,
                              ),
                            ),
                            Text(
                              'تاريخ الاصدار: 2026/01/15',
                              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                        const Divider(height: 24),
                        Center(
                          child: Text(
                            docTitle,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'هذا التقرير الفني المعتمد يوضح نتائج الاختبارات المعملية والفحوصات القياسية للمنتج وفقاً للمواصفات القياسية المصرية والدولية ISO 9001.',
                          style: TextStyle(fontSize: 13, height: 1.5),
                        ),
                        const SizedBox(height: 20),
                        // Mock Spec Table inside PDF
                        Table(
                          border: TableBorder.all(color: Colors.grey.shade300),
                          children: const [
                            TableRow(
                              decoration: BoxDecoration(color: Color(0xFFF1F5F9)),
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('الاختبار', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('النتيجة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('الحالة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                Padding(padding: EdgeInsets.all(8.0), child: Text('ثبات الألوان بعد الغسيل', style: TextStyle(fontSize: 12))),
                                Padding(padding: EdgeInsets.all(8.0), child: Text('درجة 4-5 (ممتاز)', style: TextStyle(fontSize: 12))),
                                Padding(padding: EdgeInsets.all(8.0), child: Text('مطابق ✅', style: TextStyle(fontSize: 12, color: Colors.green))),
                              ],
                            ),
                            TableRow(
                              children: [
                                Padding(padding: EdgeInsets.all(8.0), child: Text('نسبة التمدد والانكماش', style: TextStyle(fontSize: 12))),
                                Padding(padding: EdgeInsets.all(8.0), child: Text('< 2.1%', style: TextStyle(fontSize: 12))),
                                Padding(padding: EdgeInsets.all(8.0), child: Text('مطابق ✅', style: TextStyle(fontSize: 12, color: Colors.green))),
                              ],
                            ),
                            TableRow(
                              children: [
                                Padding(padding: EdgeInsets.all(8.0), child: Text('قوة تحمل الشد والتمزق', style: TextStyle(fontSize: 12))),
                                Padding(padding: EdgeInsets.all(8.0), child: Text('420 Newton', style: TextStyle(fontSize: 12))),
                                Padding(padding: EdgeInsets.all(8.0), child: Text('مطابق ✅', style: TextStyle(fontSize: 12, color: Colors.green))),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('توقيع المختبر المعتمد', style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                                const SizedBox(height: 6),
                                const Text('أ.د/ مدير الجودة والفحص', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                              ],
                            ),
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.primary, width: 2),
                              ),
                              child: const Center(
                                child: Text('خاتم\nالجودة', textAlign: TextAlign.center, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.primary)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Bottom Action Button
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('جارٍ تحميل ملف $docTitle...')),
                      );
                    },
                    icon: const Icon(Icons.download_rounded),
                    label: Text('تحميل المستند ($docType)'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

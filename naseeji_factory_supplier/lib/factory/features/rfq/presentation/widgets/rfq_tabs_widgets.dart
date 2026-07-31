import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../products/presentation/widgets/product_details/documents_widget.dart';
import '../providers/rfq_provider.dart';

/// -------------------------------------------------------------------
/// Tab 1: Overview & RFQ Description Tab ("تفاصيل الطلب")
/// -------------------------------------------------------------------
class RFQDetailsTab extends StatelessWidget {
  final RFQ rfq;

  const RFQDetailsTab({super.key, required this.rfq});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          borderRadius: AppRadius.rMD,
          border: Border.all(color: isDark ? AppColors.borderDark : Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'نبذة عن الطلب',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              rfq.description,
              style: TextStyle(
                fontSize: 13,
                height: 1.6,
                color: isDark ? Colors.grey.shade300 : Colors.grey.shade800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// -------------------------------------------------------------------
/// Tab 2: Specifications Tab ("المواصفات")
/// -------------------------------------------------------------------
class RFQSpecsTab extends StatelessWidget {
  final RFQ rfq;

  const RFQSpecsTab({super.key, required this.rfq});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          borderRadius: AppRadius.rMD,
          border: Border.all(color: isDark ? AppColors.borderDark : Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('المواصفات الفنية المعتمدة', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 14),
            _buildSpecRow('الخامة الرئيسية', rfq.material),
            _buildSpecRow('اللون المطلوب', rfq.color),
            _buildSpecRow('المقاس / العرض / الوزن', rfq.size),
            _buildSpecRow('مستوى الجودة والتصنيع', rfq.qualityLevel),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecRow(String label, String val) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
          Text(val, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

/// -------------------------------------------------------------------
/// Tab 3: Attachments Tab ("المرفقات")
/// -------------------------------------------------------------------
class RFQAttachmentsTab extends StatelessWidget {
  final RFQ rfq;

  const RFQAttachmentsTab({super.key, required this.rfq});

  void _openPdfModal(BuildContext context, String docTitle) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PdfViewerModal(
        docTitle: docTitle,
        docType: 'مستند مواصفات RFQ معتمد PDF',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final attachments = rfq.attachments.isNotEmpty
        ? rfq.attachments
        : ['مواصفات_القماش_القياسية.pdf', 'رسم_توضيحي_للتركيب_النسيجي.pdf'];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: attachments.length,
      itemBuilder: (context, index) {
        final att = attachments[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : Colors.white,
            borderRadius: AppRadius.rMD,
            border: Border.all(color: isDark ? AppColors.borderDark : Colors.grey.shade200),
          ),
          child: Row(
            children: [
              const Icon(Icons.picture_as_pdf_outlined, color: AppColors.error, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(att, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              ),
              IconButton(
                icon: const Icon(Icons.download_rounded, color: AppColors.primary),
                onPressed: () => _openPdfModal(context, att),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// -------------------------------------------------------------------
/// Tab 4: Terms Tab ("شروط الطلب")
/// -------------------------------------------------------------------
class RFQTermsTab extends StatelessWidget {
  final RFQ rfq;

  const RFQTermsTab({super.key, required this.rfq});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          borderRadius: AppRadius.rMD,
          border: Border.all(color: isDark ? AppColors.borderDark : Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('الشروط التجارية والقانونية', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 14),
            _buildTermItem('شروط الدفع المعتمدة:', rfq.paymentTerms),
            _buildTermItem('العملة المستخدمة:', rfq.currency),
            _buildTermItem('مكان وعنوان التسليم:', rfq.deliveryAddress),
            _buildTermItem('تاريخ التسليم المتوقع:', rfq.deliveryDate),
            _buildTermItem('تاريخ إغلاق الطلب:', rfq.closingDate),
          ],
        ),
      ),
    );
  }

  Widget _buildTermItem(String label, String val) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
          Text(val, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

/// -------------------------------------------------------------------
/// Tab 5: Activity Tab ("النشاط")
/// -------------------------------------------------------------------
class RFQActivityTab extends StatelessWidget {
  final RFQ rfq;

  const RFQActivityTab({super.key, required this.rfq});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final activities = [
      {'title': 'تم استلام عرض سعر جديد من القاهرة للغزل والنسيج', 'date': '13 مايو 2024 - 02:20 م', 'actor': 'المورد'},
      {'title': 'تم استلام عرض سعر جديد من النساجون المصريون', 'date': '12 مايو 2024 - 11:40 ص', 'actor': 'المورد'},
      {'title': 'تم استلام عرض سعر من مصر للغزل والنسيج (أفضل عرض)', 'date': '12 مايو 2024 - 09:15 ص', 'actor': 'المورد'},
      {'title': 'تم إنشاء وإرسال طلب عرض السعر رقم #RFQ-2024-0045 إلى 8 موردين', 'date': '10 مايو 2024 - 11:30 ص', 'actor': 'المصنع'},
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: activities.length,
      itemBuilder: (context, index) {
        final a = activities[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : Colors.white,
            borderRadius: AppRadius.rMD,
            border: Border.all(color: isDark ? AppColors.borderDark : Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(a['title'] as String, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('المسؤول: ${a['actor']}', style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                  Text(a['date'] as String, style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}




import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_factory/factory/core/constants/app_colors.dart';
import 'package:naseeji_factory/factory/core/constants/app_spacing.dart';
import 'package:naseeji_factory/factory/features/orders/presentation/providers/orders_provider.dart';
import 'package:naseeji_factory/factory/features/quality/presentation/widgets/quality_reusable_widgets.dart';
import '../../providers/quality_provider.dart';
import '../issue_report_widgets.dart';

class IssueReportForm extends ConsumerStatefulWidget {
  final OrderModel order;

  const IssueReportForm({super.key, required this.order});

  @override
  ConsumerState<IssueReportForm> createState() => _IssueReportFormState();
}

class _IssueReportFormState extends ConsumerState<IssueReportForm> {
  String _selectedType = 'منتجات تالفة ومكسورة (Damaged Products)';
  String _description = '';
  final List<String> _uploadedImages = [];
  final List<String> _uploadedVideos = [];
  final List<String> _uploadedDocuments = [];

  final List<String> _issueTypes = const [
    'منتجات تالفة ومكسورة (Damaged Products)',
    'المنتج غير مطابق للطلب (Wrong Product)',
    'الخامة غير مطابقة للعينة (Wrong Material)',
    'اللون غير مطابق للتصميم (Wrong Color)',
    'المقاسات والأبعاد غير دقيقة (Wrong Size)',
    'نقص في كميات الطرود والقطع (Quantity Missing)',
    'مشكلة في التغليف والحشو الفني (Packaging Problem)',
    'أسباب أخرى فنية أو لوجستية (Other)',
  ];

  void _simulateUploadImage() {
    setState(() {
      _uploadedImages.add('https://images.unsplash.com/photo-1541099649105-f69ad21f3246');
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تم تحميل صورة إثبات العيب رقم ${_uploadedImages.length} بنجاح.')),
    );
  }

  void _simulateUploadVideo() {
    setState(() {
      final index = _uploadedVideos.length + 1;
      _uploadedVideos.add('فيديو_إثبات_الخلل_$index.mp4');
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تم تحميل فيديو المعاينة بنجاح.')),
    );
  }

  void _simulateUploadDocument() {
    setState(() {
      final index = _uploadedDocuments.length + 1;
      _uploadedDocuments.add('تقرير_المطابقة_الفني_الخارجي_$index.pdf');
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تم إرسال الملف الداعم بنجاح.')),
    );
  }

  void _submitIssue() {
    if (_description.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى إدخال شرح تفصيلي للمشكلة أولاً.')),
      );
      return;
    }

    ref.read(qualityNotifierProvider.notifier).submitIssueReport(
          widget.order.id,
          issueType: _selectedType,
          description: _description,
          evidenceFiles: [..._uploadedImages, ..._uploadedVideos, ..._uploadedDocuments],
        );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تم رفع بلاغ النزاع للمورد حول ($_selectedType) بنجاح.')),
    );

    _showDisputeActionDialog();
  }

  void _showDisputeActionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('تم فتح نزاع الشحنة', style: TextStyle(fontWeight: FontWeight.bold)),
          content: const Text(
            'تم تسجيل بلاغ العيوب رسمياً وإشعار المورد. كيف ترغب في حل هذا النزاع التجاري؟',
            style: TextStyle(fontSize: 12),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.go('/orders/${widget.order.id}');
              },
              child: const Text('متابعة الطلب لاحقاً'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.push('/orders/${widget.order.id}/replacement-request');
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
              child: const Text('طلب استبدال البضائع'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.push('/orders/${widget.order.id}/return-request');
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade700, foregroundColor: Colors.white),
              child: const Text('طلب إرجاع واسترداد'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IssueHeaderWidget(order: widget.order),
          AppSpacing.hMD,
          IssueTypeWidget(
            selectedType: _selectedType,
            issueTypes: _issueTypes,
            onChanged: (val) => setState(() => _selectedType = val),
          ),
          AppSpacing.hMD,
          PhotoUploaderWidget(
            images: _uploadedImages,
            onUpload: _simulateUploadImage,
            onRemove: (idx) => setState(() => _uploadedImages.removeAt(idx)),
          ),
          AppSpacing.hMD,
          VideoUploaderWidget(
            videos: _uploadedVideos,
            onUpload: _simulateUploadVideo,
            onRemove: (idx) => setState(() => _uploadedVideos.removeAt(idx)),
          ),
          AppSpacing.hMD,
          DescriptionWidget(
            description: _description,
            onChanged: (val) => setState(() => _description = val),
          ),
          AppSpacing.hMD,
          EvidenceWidget(
            files: _uploadedDocuments,
            onUpload: _simulateUploadDocument,
            onRemove: (idx) => setState(() => _uploadedDocuments.removeAt(idx)),
          ),
          AppSpacing.hLG,
          SubmitWidget(
            onSubmit: _submitIssue,
            onSaveDraft: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم حفظ مسودة البلاغ بنجاح في سجلات المصنع المحلية.')),
              );
              context.pop();
            },
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}


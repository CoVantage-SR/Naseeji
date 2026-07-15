import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../orders/presentation/providers/orders_provider.dart';
import '../../providers/quality_provider.dart';
import '../delivery_receipt_widgets.dart';
import '../reject_delivery_widgets.dart';

class RejectDeliveryForm extends ConsumerStatefulWidget {
  final Order order;

  const RejectDeliveryForm({super.key, required this.order});

  @override
  ConsumerState<RejectDeliveryForm> createState() => _RejectDeliveryFormState();
}

class _RejectDeliveryFormState extends ConsumerState<RejectDeliveryForm> {
  String _selectedReason = 'شحنة تالفة بالكامل (Damaged Shipment)';
  String _comments = '';
  bool _confirmReject = false;

  final List<String> _uploadedImages = [];
  final List<String> _uploadedVideos = [];

  final List<String> _rejectReasons = const [
    'شحنة تالفة بالكامل (Damaged Shipment)',
    'المنتج الواصل غير المطلوب تماماً (Wrong Product)',
    'تأخير شديد في تسليم الشحنة (Late Delivery)',
    'نقص كبير في عدد الطرود أو الوزن (Missing Items)',
    'جودة متدنية جداً ولا تصلح للاستخدام (Poor Quality)',
    'أسباب فنية أخرى (Other)',
  ];

  void _simulateUploadImage() {
    setState(() {
      _uploadedImages.add('https://images.unsplash.com/photo-1541099649105-f69ad21f3246');
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم إرفاق صورة إثبات عيب الرفض.')),
    );
  }

  void _simulateUploadVideo() {
    setState(() {
      _uploadedVideos.add('فيديو_معاينة_تلف_الشحنة_${_uploadedVideos.length + 1}.mp4');
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم إرفاق فيديو إثبات الرفض.')),
    );
  }

  void _submitRejection() {
    if (_comments.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى كتابة تعليقات تفصيلية حول سبب الرفض.')),
      );
      return;
    }
    if (_uploadedImages.isEmpty && _uploadedVideos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى إرفاق دليل مصور واحد على الأقل (صورة أو فيديو) لإثبات التلف.')),
      );
      return;
    }
    if (!_confirmReject) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يجب الموافقة على إقرار رفض استلام الشحنة أولاً.')),
      );
      return;
    }

    ref.read(qualityNotifierProvider.notifier).rejectDelivery(
          widget.order.id,
          reason: _selectedReason,
          comments: _comments,
          evidenceFiles: [..._uploadedImages, ..._uploadedVideos],
        );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تم رفض الشحنة بنجاح وفتح نزاع تجاري حول ($_selectedReason).')),
    );

    _showResolutionDialog();
  }

  void _showResolutionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('تم رفض الشحنة بنجاح', style: TextStyle(fontWeight: FontWeight.bold)),
          content: const Text(
            'تم إرجاع الشحنة وفتح نزاع مالي تلقائياً. كيف ترغب في معالجة الطلب الآن؟',
            style: TextStyle(fontSize: 12),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.go('/orders/${widget.order.id}');
              },
              child: const Text('رجوع للطلب'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.push('/orders/${widget.order.id}/replacement-request');
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber.shade700, foregroundColor: Colors.white),
              child: const Text('طلب توريد بديل'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.push('/orders/${widget.order.id}/return-request');
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade700, foregroundColor: Colors.white),
              child: const Text('طلب إرجاع واسترداد مالي'),
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
          RejectHeaderWidget(order: widget.order),
          AppSpacing.hMD,
          OrderSummaryWidget(order: widget.order),
          AppSpacing.hMD,
          ReasonSelectorWidget(
            selectedReason: _selectedReason,
            reasons: _rejectReasons,
            onChanged: (val) => setState(() => _selectedReason = val),
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
            description: _comments,
            onChanged: (val) => setState(() => _comments = val),
          ),
          AppSpacing.hMD,
          DeclarationWidget(
            isChecked: _confirmReject,
            onChanged: (val) => setState(() => _confirmReject = val ?? false),
          ),
          AppSpacing.hLG,
          RejectButtonWidget(
            onReject: _submitRejection,
            isEnabled: _confirmReject && _comments.trim().isNotEmpty && (_uploadedImages.isNotEmpty || _uploadedVideos.isNotEmpty),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

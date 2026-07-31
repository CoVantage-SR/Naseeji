import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../orders/presentation/providers/orders_provider.dart';
import '../providers/quality_provider.dart';
import '../widgets/return_request_widgets.dart';
import '../widgets/quality_reusable_widgets.dart';

class ReturnRequestScreen extends ConsumerStatefulWidget {
  final String orderId;

  const ReturnRequestScreen({super.key, required this.orderId});

  @override
  ConsumerState<ReturnRequestScreen> createState() => _ReturnRequestScreenState();
}

class _ReturnRequestScreenState extends ConsumerState<ReturnRequestScreen> {
  int _quantity = 1;
  String _selectedReason = 'عدم مطابقة البضائع بالكامل للمواصفات المتفق عليها (Not Matching Specs)';
  String _selectedRefundOption = 'محفظة الحساب الإلكترونية (Wallet Balance)';
  String _comments = '';

  final List<String> _uploadedImages = [];
  final List<String> _uploadedVideos = [];

  final List<String> _returnReasons = const [
    'عدم مطابقة البضائع بالكامل للمواصفات المتفق عليها (Not Matching Specs)',
    'تلف وتكسير كبير في الطرود والقطع (Severely Damaged Products)',
    'الخامة تختلف جذرياً عن العينات المعتمدة (Wrong Material)',
    'الكميات الواصلة ناقصة بنسبة لا يمكن قبولها (Severe Shortage)',
    'أسباب أخرى فنية أو تعاقدية (Other)',
  ];

  final List<String> _refundOptions = const [
    'محفظة الحساب الإلكترونية (Wallet Balance)',
    'تحويل بنكي مباشر للحساب المصرفي (Bank Transfer)',
    'استرداد لنفس طريقة الدفع الأصلية (Original Payment Method)',
  ];

  void _simulateUploadImage() {
    setState(() {
      _uploadedImages.add('https://images.unsplash.com/photo-1541099649105-f69ad21f3246');
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم إرفاق صورة إثبات الإرجاع.')),
    );
  }

  void _simulateUploadVideo() {
    setState(() {
      _uploadedVideos.add('فيديو_إثبات_الإرجاع_${_uploadedVideos.length + 1}.mp4');
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم إرفاق فيديو إثبات الإرجاع.')),
    );
  }

  void _submitReturnRequest(OrderModel order) {
    if (_comments.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى إدخال تعليقات توضيحية لطلب الإرجاع.')),
      );
      return;
    }

    ref.read(qualityNotifierProvider.notifier).submitReturnRequest(
          widget.orderId,
          productName: order.productName,
          quantity: _quantity,
          reason: _selectedReason,
          refundMethod: _selectedRefundOption,
          comments: _comments,
          evidenceFiles: [..._uploadedImages, ..._uploadedVideos],
        );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تم تقديم طلب إرجاع لعدد $_quantity قطعة واسترداد القيمة عبر ($_selectedRefundOption) بنجاح.')),
    );

    context.go('/orders/${widget.orderId}');
  }

  @override
  Widget build(BuildContext context) {
    final order = ref.watch(ordersNotifierProvider.notifier).getOrderById(widget.orderId);

    if (order == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('خطأ')),
        body: const Center(child: Text('الطلب المطلوب غير موجود.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('طلب إرجاع سلع'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ReturnHeaderWidget(order: order),
              AppSpacing.hMD,
              ItemsSelectorWidget(
                order: order,
                selectedQuantity: _quantity,
                onQuantityChanged: (val) => setState(() => _quantity = val),
                title: 'تحديد السلع المراد إرجاعها والكمية',
                quantityLabel: 'الكمية المطلوب إرجاعها:',
              ),
              AppSpacing.hMD,
              ReplacementReasonWidget(
                selectedReason: _selectedReason,
                reasons: _returnReasons,
                onChanged: (val) => setState(() => _selectedReason = val),
                title: 'سبب طلب الإرجاع بالتفصيل',
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
              RefundInformationWidget(
                selectedOption: _selectedRefundOption,
                refundOptions: _refundOptions,
                onChanged: (val) => setState(() => _selectedRefundOption = val),
              ),
              AppSpacing.hLG,
              SubmitWidget(
                onSubmit: () => _submitReturnRequest(order),
                onCancel: () => context.pop(),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}



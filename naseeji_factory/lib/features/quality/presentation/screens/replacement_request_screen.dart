import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../orders/presentation/providers/orders_provider.dart';
import '../providers/quality_provider.dart';
import '../widgets/replacement_request_widgets.dart';
import '../widgets/quality_reusable_widgets.dart';

class ReplacementRequestScreen extends ConsumerStatefulWidget {
  final String orderId;

  const ReplacementRequestScreen({super.key, required this.orderId});

  @override
  ConsumerState<ReplacementRequestScreen> createState() => _ReplacementRequestScreenState();
}

class _ReplacementRequestScreenState extends ConsumerState<ReplacementRequestScreen> {
  int _quantity = 1;
  String _selectedReason = 'بعض القطع بها عيوب تصنيع ظاهرية (Manufacturing Defects)';
  String _comments = '';
  String _shippingAddress = '';

  final List<String> _uploadedImages = [];
  final List<String> _uploadedVideos = [];

  final List<String> _replacementReasons = const [
    'بعض القطع بها عيوب تصنيع ظاهرية (Manufacturing Defects)',
    'الخامة تختلف عن العينة الأصلية المعتمدة (Wrong Material)',
    'تضرر القطع أثناء النقل والتحميل (Damaged in Transit)',
    'وصول مقاسات أو أبعاد خاطئة (Wrong Size)',
    'المنتج غير مطابق للألوان المحددة (Wrong Color)',
    'أسباب فنية أخرى (Other)',
  ];

  @override
  void initState() {
    super.initState();
    // Pre-populate with order address
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final order = ref.read(ordersNotifierProvider.notifier).getOrderById(widget.orderId);
      if (order != null) {
        setState(() {
          _shippingAddress = order.address;
        });
      }
    });
  }

  void _simulateUploadImage() {
    setState(() {
      _uploadedImages.add('https://images.unsplash.com/photo-1541099649105-f69ad21f3246');
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم إرفاق صورة إثبات الاستبدال.')),
    );
  }

  void _simulateUploadVideo() {
    setState(() {
      _uploadedVideos.add('فيديو_إثبات_الاستبدال_${_uploadedVideos.length + 1}.mp4');
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم إرفاق فيديو إثبات الاستبدال.')),
    );
  }

  void _submitReplacementRequest(OrderModel order) {
    if (_comments.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى إدخال تعليقات توضيحية لطلب الاستبدال.')),
      );
      return;
    }
    if (_shippingAddress.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى إدخال عنوان الشحن لتوصيل السلع البديلة.')),
      );
      return;
    }

    ref.read(qualityNotifierProvider.notifier).submitReplacementRequest(
          widget.orderId,
          productName: order.productName,
          quantity: _quantity,
          reason: _selectedReason,
          comments: _comments,
          evidenceFiles: [..._uploadedImages, ..._uploadedVideos],
          shippingAddress: _shippingAddress,
        );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تم إرسال طلب استبدال لعدد $_quantity قطعة للمورد بنجاح.')),
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
        title: const Text('طلب استبدال منتجات'),
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
              ReplacementHeaderWidget(order: order),
              AppSpacing.hMD,
              ItemsSelectorWidget(
                order: order,
                selectedQuantity: _quantity,
                onQuantityChanged: (val) => setState(() => _quantity = val),
              ),
              AppSpacing.hMD,
              ReplacementReasonWidget(
                selectedReason: _selectedReason,
                reasons: _replacementReasons,
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
              AddressWidget(
                address: _shippingAddress,
                onChanged: (val) => setState(() => _shippingAddress = val),
              ),
              AppSpacing.hLG,
              SubmitWidget(
                onSubmit: () => _submitReplacementRequest(order),
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

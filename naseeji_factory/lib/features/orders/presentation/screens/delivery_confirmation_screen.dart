import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../providers/orders_provider.dart';
import '../widgets/delivery_confirmation_widgets.dart';

class DeliveryConfirmationScreen extends ConsumerStatefulWidget {
  final String orderId;

  const DeliveryConfirmationScreen({super.key, required this.orderId});

  @override
  ConsumerState<DeliveryConfirmationScreen> createState() => _DeliveryConfirmationScreenState();
}

class _DeliveryConfirmationScreenState extends ConsumerState<DeliveryConfirmationScreen> {
  bool _isChecked = false;
  bool _showProblemForm = false;
  final _formKey = GlobalKey<FormState>();

  final _reasonController = TextEditingController();
  final _descController = TextEditingController();
  final List<String> _uploadedFiles = [];

  @override
  void dispose() {
    _reasonController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _showRatingDialog() {
    double rating = 5;
    final commentController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('تقييم المورد والخدمة', style: TextStyle(fontWeight: FontWeight.bold)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('شكراً لتأكيد الاستلام! يرجى تقييم جودة المنتج والتزام المورد بمواعيد التسليم:'),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      final starValue = index + 1;
                      return IconButton(
                        icon: Icon(
                          rating >= starValue ? Icons.star_rounded : Icons.star_border_rounded,
                          color: Colors.amber,
                          size: 32,
                        ),
                        onPressed: () {
                          setDialogState(() {
                            rating = starValue.toDouble();
                          });
                        },
                      );
                    }),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: commentController,
                    decoration: const InputDecoration(
                      labelText: 'ملاحظات إضافية حول جودة التوريد...',
                      prefixIcon: Icon(Icons.rate_review_rounded),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _executeConfirmation();
                  },
                  child: const Text('تخطي التقييم'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('شكراً لك! تم تسجيل تقييمك بمعدل $rating/5 نجوم للمورد.')),
                    );
                    _executeConfirmation();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('إرسال التقييم والإنهاء'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _executeConfirmation() {
    ref.read(ordersNotifierProvider.notifier).confirmDelivery(widget.orderId);
    context.go('/orders');
  }

  void _confirmReceipt() {
    if (!_isChecked) return;
    _showRatingDialog();
  }

  void _reportDispute() {
    if (_formKey.currentState!.validate()) {
      ref.read(ordersNotifierProvider.notifier).reportProblem(
            widget.orderId,
            _reasonController.text.trim(),
            _descController.text.trim(),
          );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.error,
          content: const Text('تم فتح نزاع جودة وإخطار المورد فورياً للمراجعة.'),
        ),
      );
      context.go('/orders');
    }
  }

  @override
  Widget build(BuildContext context) {
    final order = ref.watch(ordersNotifierProvider.notifier).getOrderById(widget.orderId);

    if (order == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('الطلب المطلوب غير موجود.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('تأكيد مطابقة واستلام الشحنة'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DeliverySummaryWidget(order: order),
              AppSpacing.hMD,
              const ShipmentPreviewWidget(),
              AppSpacing.hMD,
              if (!_showProblemForm) ...[
                ConfirmationWidget(
                  isChecked: _isChecked,
                  onChecked: (val) {
                    setState(() {
                      _isChecked = val ?? false;
                    });
                  },
                ),
                AppSpacing.hLG,
                ActionButtonsWidget(
                  confirmEnabled: _isChecked,
                  onConfirm: _confirmReceipt,
                  onReport: () {
                    setState(() {
                      _showProblemForm = true;
                    });
                  },
                ),
              ] else ...[
                ProblemReportWidget(
                  formKey: _formKey,
                  reasonController: _reasonController,
                  descController: _descController,
                  uploadedFiles: _uploadedFiles,
                  onUploadImage: () {
                    setState(() {
                      _uploadedFiles.add('صورة_العيوب_${_uploadedFiles.length + 1}.jpg');
                    });
                  },
                  onUploadVideo: () {
                    setState(() {
                      _uploadedFiles.add('فيديو_الخلل_${_uploadedFiles.length + 1}.mp4');
                    });
                  },
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _showProblemForm = false;
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: AppRadius.rMD),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('رجوع للتأكيد'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _reportDispute,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.error,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: AppRadius.rMD),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.gavel_rounded, size: 18),
                            SizedBox(width: 8),
                            Text('فتح نزاع جودة رسمي', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

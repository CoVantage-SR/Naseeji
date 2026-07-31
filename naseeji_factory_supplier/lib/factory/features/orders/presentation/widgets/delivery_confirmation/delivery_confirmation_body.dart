import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_factory/factory/core/constants/app_colors.dart';
import 'package:naseeji_factory/factory/core/constants/app_radius.dart';
import 'package:naseeji_factory/factory/core/constants/app_spacing.dart';
import '../../providers/orders_provider.dart';
import '../delivery_confirmation_widgets.dart';
import 'delivery_rating_dialog.dart';

class DeliveryConfirmationBody extends ConsumerStatefulWidget {
  final OrderModel order;

  const DeliveryConfirmationBody({super.key, required this.order});

  @override
  ConsumerState<DeliveryConfirmationBody> createState() => _DeliveryConfirmationBodyState();
}

class _DeliveryConfirmationBodyState extends ConsumerState<DeliveryConfirmationBody> {
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
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return DeliveryRatingDialog(
          onSkip: () {
            Navigator.of(context).pop();
            _executeConfirmation();
          },
          onConfirm: (rating, comment) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('شكراً لك! تم تسجيل تقييمك بمعدل $rating/5 نجوم للمورد.')),
            );
            _executeConfirmation();
          },
        );
      },
    );
  }

  void _executeConfirmation() {
    ref.read(ordersNotifierProvider.notifier).confirmDelivery(widget.order.id);
    context.go('/orders');
  }

  void _confirmReceipt() {
    if (!_isChecked) return;
    _showRatingDialog();
  }

  void _reportDispute() {
    if (_formKey.currentState!.validate()) {
      ref.read(ordersNotifierProvider.notifier).reportProblem(
            widget.order.id,
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DeliverySummaryWidget(order: widget.order),
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
    );
  }
}


import 'package:flutter/material.dart';
import 'package:naseeji_factory/core/constants/app_colors.dart';

class DeliveryRatingDialog extends StatefulWidget {
  final Function(double, String) onConfirm;
  final VoidCallback onSkip;

  const DeliveryRatingDialog({
    super.key,
    required this.onConfirm,
    required this.onSkip,
  });

  @override
  State<DeliveryRatingDialog> createState() => _DeliveryRatingDialogState();
}

class _DeliveryRatingDialogState extends State<DeliveryRatingDialog> {
  double _rating = 5;
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  _rating >= starValue ? Icons.star_rounded : Icons.star_border_rounded,
                  color: Colors.amber,
                  size: 32,
                ),
                onPressed: () {
                  setState(() {
                    _rating = starValue.toDouble();
                  });
                },
              );
            }),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _commentController,
            decoration: const InputDecoration(
              labelText: 'ملاحظات إضافية حول جودة التوريد...',
              prefixIcon: Icon(Icons.rate_review_rounded),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: widget.onSkip,
          child: const Text('تخطي التقييم'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onConfirm(_rating, _commentController.text.trim());
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
          child: const Text('إرسال التقييم والإنهاء'),
        ),
      ],
    );
  }
}



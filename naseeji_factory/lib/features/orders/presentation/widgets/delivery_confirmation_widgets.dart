import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/widgets/reusable_widgets.dart';
import '../providers/orders_provider.dart';
import 'orders_reusable_widgets.dart';

class DeliverySummaryWidget extends StatelessWidget {
  final OrderModel order;

  const DeliverySummaryWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return InformationCard(
      title: 'ملخص البضاعة والكميات المستلمة',
      items: [
        {'label': 'رقم أمر الشراء المعني', 'value': order.id},
        {'label': 'المنتج المطلوب مطابقتة', 'value': order.productName},
        {'label': 'المورد الفعلي', 'value': order.supplierName},
        {'label': 'الكمية المستلمة', 'value': '${order.quantity} وحدة'},
        {'label': 'قيمة الصفقة المعتمدة', 'value': '${order.finalPrice.toInt()} ج.م'},
      ],
    );
  }
}

class ShipmentPreviewWidget extends StatelessWidget {
  const ShipmentPreviewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final images = [
      'https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d',
      'https://images.unsplash.com/photo-1578575437130-527eed3abbec',
    ];

    return PrimaryCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'معاينة صور التعبئة والتحميل المرسلة من المورد',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: images.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius: AppRadius.rMD,
                  child: Image.network(
                    images[index],
                    width: 140,
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ConfirmationWidget extends StatelessWidget {
  final ValueChanged<bool?> onChecked;
  final bool isChecked;

  const ConfirmationWidget({
    super.key,
    required this.onChecked,
    required this.isChecked,
  });

  @override
  Widget build(BuildContext context) {
    return PrimaryCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: isChecked,
            onChanged: onChecked,
            activeColor: AppColors.primary,
          ),
          const Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text(
                'أقر أنا المفوض عن مصنع نسيجي باستلام كامل الطرود والكميات المذكورة أعلاه، ومطابقتها للمواصفات الفنية المعتمدة وجودة التصنيع المتفق عليها دون أي تحفظات.',
                style: TextStyle(fontSize: 10, height: 1.5, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProblemReportWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController reasonController;
  final TextEditingController descController;
  final VoidCallback onUploadImage;
  final VoidCallback onUploadVideo;
  final List<String> uploadedFiles;

  const ProblemReportWidget({
    super.key,
    required this.formKey,
    required this.reasonController,
    required this.descController,
    required this.onUploadImage,
    required this.onUploadVideo,
    required this.uploadedFiles,
  });

  @override
  Widget build(BuildContext context) {
    return PrimaryCard(
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'الإبلاغ عن عيب تصنيع أو عجز في الكمية',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.error),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: 'سبب الإشكال الرئيسي (مثال: عيب غزل، كمية ناقصة)',
                prefixIcon: Icon(Icons.error_outline_rounded),
              ),
              validator: (val) => val == null || val.isEmpty ? 'يرجى كتابة سبب الإشكال' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: descController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'تفاصيل الخلل والعيوب الفنية المرصودة...',
                prefixIcon: Icon(Icons.notes_rounded),
              ),
              validator: (val) => val == null || val.isEmpty ? 'يرجى كتابة الشرح التفصيلي للخلل' : null,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                  ).apply(
                    child: OutlinedButton(
                      onPressed: onUploadImage,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.photo_library_outlined, size: 18),
                          SizedBox(width: 8),
                          Text('إرفاق صور العيوب', style: TextStyle(fontSize: 10)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                  ).apply(
                    child: OutlinedButton(
                      onPressed: onUploadVideo,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.videocam_outlined, size: 18),
                          SizedBox(width: 8),
                          Text('إرفاق فيديو الخلل', style: TextStyle(fontSize: 10)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (uploadedFiles.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: uploadedFiles.map((file) {
                  return Chip(
                    label: Text(file, style: const TextStyle(fontSize: 9)),
                    onDeleted: () {},
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class ActionButtonsWidget extends StatelessWidget {
  final VoidCallback onConfirm;
  final VoidCallback onReport;
  final bool confirmEnabled;

  const ActionButtonsWidget({
    super.key,
    required this.onConfirm,
    required this.onReport,
    required this.confirmEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SecondaryButton(
            label: 'إبلاغ وفتح نزاع تجاري',
            icon: Icons.gavel_rounded,
            color: AppColors.error,
            onPressed: onReport,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: confirmEnabled ? onConfirm : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.grey.shade300,
              shape: RoundedRectangleBorder(borderRadius: AppRadius.rMD),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle_rounded, size: 18),
                SizedBox(width: 8),
                Text('تأكيد الاستلام النهائي', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

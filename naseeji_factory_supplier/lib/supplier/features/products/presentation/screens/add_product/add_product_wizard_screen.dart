import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/features/products/presentation/controllers/add_product_controller.dart';
import 'widgets/wizard_progress_header.dart';
import 'widgets/wizard_navigation_bar.dart';
import 'steps/step1_basic_info_widget.dart';
import 'steps/step2_tech_specs_widget.dart';
import 'steps/step3_images_widget.dart';
import 'steps/step4_video_widget.dart';
import 'steps/step5_documents_widget.dart';
import 'steps/step6_pricing_tiers_widget.dart';
import 'steps/step7_manufacturing_pickup_widget.dart';
import 'steps/step8_review_publish_widget.dart';

class AddProductWizardScreen extends ConsumerWidget {
  const AddProductWizardScreen({super.key});

  Widget _buildActiveStepWidget(int step, dynamic formData) {
    switch (step) {
      case 1:
        return Step1BasicInfoWidget(formData: formData);
      case 2:
        return Step2TechSpecsWidget(formData: formData);
      case 3:
        return Step3ImagesWidget(formData: formData);
      case 4:
        return Step4VideoWidget(formData: formData);
      case 5:
        return Step5DocumentsWidget(formData: formData);
      case 6:
        return Step6PricingTiersWidget(formData: formData);
      case 7:
        return Step7ManufacturingPickupWidget(formData: formData);
      case 8:
        return Step8ReviewPublishWidget(formData: formData);
      default:
        return Step1BasicInfoWidget(formData: formData);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formData = ref.watch(addProductControllerProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'معالج إضافة منتج جديد',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => context.pop(),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.help_outline_rounded),
              tooltip: 'المساعدة وإرشادات المعالج',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('إرشادات معالج إضافة المنتجات'),
                    content: const Text(
                      'تم تصميم هذا المعالج خطوة بخطوة لمساعدتك في رفع كافة تفاصيل النسيج والأسعار دون تعقيد.\n\nتتم العملية عبر ٨ خطوات بسيطة مع حفظ تلقائي للمسودة في كل خطوة.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('فهمت ذلك'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            // Top Step Progress Header
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
              child: WizardProgressHeader(formData: formData),
            ),
            const SizedBox(height: 12),

            // Middle Active Step Form Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14.0),
                child: _buildActiveStepWidget(formData.currentStep, formData),
              ),
            ),

            // Bottom Navigation Bar (Previous, Save Draft, Next/Publish)
            WizardNavigationBar(formData: formData),
          ],
        ),
      ),
    );
  }
}

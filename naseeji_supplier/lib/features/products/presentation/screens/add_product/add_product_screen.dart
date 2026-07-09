import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../../controllers/add_product_controller.dart';
import 'widgets/product_horizontal_stepper.dart';
import 'widgets/product_identity_form.dart';
import 'widgets/product_progress_stepper.dart';
import 'widgets/supplier_tip_card.dart';
import 'widgets/product_technical_specs_form.dart';
import 'widgets/product_pricing_form.dart';
import 'widgets/product_success_summary.dart';

class AddNewProductScreen extends ConsumerWidget {
  const AddNewProductScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 900;
    
    // Watch current form state (e.g. currentStep)
    final formData = ref.watch(addProductControllerProvider);

    Widget buildStepContent(int step) {
      switch (step) {
        case 1:
          return const Column(
            children: [
              ProductIdentityForm(),
              SizedBox(height: 24),
              SupplierTipCard(),
            ],
          );
        case 2:
          return const ProductTechnicalSpecsForm();
        case 3:
          return const ProductPricingForm();
        case 4:
          return const ProductSuccessSummary();
        default:
          return const ProductIdentityForm();
      }
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        title: const Text(
          'Naseeji',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.onSurfaceVariant),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 32.0 : 16.0,
            vertical: 24.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Page Header
              const Text(
                'إضافة منتج جديد',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'أدخل التفاصيل الأساسية للمنسوجات الخاصة بك للبدء',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 32),

              // Layout Grid
              if (isDesktop)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Form Content & Tips
                    Expanded(
                      flex: 3,
                      child: buildStepContent(formData.currentStep),
                    ),
                    const SizedBox(width: 32),
                    // Progress Stepper (Right side for RTL)
                    if (formData.currentStep < 4)
                      SizedBox(
                        width: 250,
                        child: ProductProgressStepper(currentStep: formData.currentStep),
                      ),
                  ],
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (formData.currentStep < 4) ...[
                      ProductHorizontalStepper(currentStep: formData.currentStep),
                      const SizedBox(height: 24),
                    ],
                    buildStepContent(formData.currentStep),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

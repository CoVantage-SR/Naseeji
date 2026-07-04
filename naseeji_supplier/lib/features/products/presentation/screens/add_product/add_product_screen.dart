import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../../controllers/add_product_controller.dart';
import 'widgets/product_horizontal_stepper.dart';
import 'widgets/product_identity_form.dart';
import 'widgets/product_progress_stepper.dart';
import 'widgets/supplier_tip_card.dart';

class AddNewProductScreen extends ConsumerWidget {
  const AddNewProductScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 900;
    
    // Watch current form state (e.g. currentStep)
    final formData = ref.watch(addProductControllerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
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
                      child: Column(
                        children: [
                          const ProductIdentityForm(),
                          const SizedBox(height: 24),
                          const SupplierTipCard(),
                        ],
                      ),
                    ),
                    const SizedBox(width: 32),
                    // Progress Stepper (Right side for RTL)
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
                    ProductHorizontalStepper(currentStep: formData.currentStep),
                    const SizedBox(height: 24),
                    const ProductIdentityForm(),
                    const SizedBox(height: 24),
                    const SupplierTipCard(),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

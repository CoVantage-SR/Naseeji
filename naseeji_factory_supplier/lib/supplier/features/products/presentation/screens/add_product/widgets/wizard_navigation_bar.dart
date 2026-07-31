import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naseeji_supplier/features/products/domain/entities/product_form_data.dart';
import 'package:naseeji_supplier/features/products/presentation/controllers/add_product_controller.dart';

class WizardNavigationBar extends ConsumerWidget {
  final ProductFormData formData;

  const WizardNavigationBar({
    super.key,
    required this.formData,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final controller = ref.read(addProductControllerProvider.notifier);
    final isFirstStep = formData.currentStep == 1;
    final isLastStep = formData.currentStep == 8;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Previous Step Button
            if (!isFirstStep)
              OutlinedButton.icon(
                onPressed: () => controller.previousStep(),
                icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                label: const Text('السابق'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  minimumSize: const Size(0, 42),
                ),
              ),
            if (!isFirstStep) const SizedBox(width: 8),

            // Save Draft Manual Button
            TextButton.icon(
              onPressed: () => controller.saveDraftManual(context),
              icon: const Icon(Icons.bookmark_add_outlined, size: 16),
              label: const Text('حفظ كمسودة'),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                foregroundColor: colorScheme.onSurfaceVariant,
                minimumSize: const Size(0, 42),
              ),
            ),

            const Spacer(),

            // Next Step or Publish Button
            ElevatedButton.icon(
              onPressed: () {
                if (isLastStep) {
                  controller.publishProduct(context);
                } else {
                  controller.nextStep(context);
                }
              },
              icon: Icon(
                isLastStep ? Icons.rocket_launch_rounded : Icons.arrow_back_rounded,
                size: 18,
              ),
              label: Text(
                isLastStep ? 'نشر المنتج الآن' : 'التالي',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: isLastStep ? const Color(0xFF2E7D32) : colorScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                minimumSize: const Size(0, 42),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

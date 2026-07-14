import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../orders/presentation/providers/orders_provider.dart';
import 'quality_reusable_widgets.dart';

class ReplacementHeaderWidget extends StatelessWidget {
  final OrderModel order;

  const ReplacementHeaderWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: AppRadius.rMD,
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          const Icon(Icons.swap_horiz_rounded, color: AppColors.primary, size: 36),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'طلب استبدال السلع التالفة أو المخالفة',
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'طلب رقم: ${order.id} | المورد: ${order.supplierName}',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ItemsSelectorWidget extends StatelessWidget {
  final OrderModel order;
  final int selectedQuantity;
  final ValueChanged<int> onQuantityChanged;

  const ItemsSelectorWidget({
    super.key,
    required this.order,
    required this.selectedQuantity,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    final maxQuantity = order.quantity;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.rMD,
        side: BorderSide(
          color: context.theme.brightness == Brightness.dark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'تحديد السلع المراد استبدالها والكمية',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary),
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: ClipRRect(
                borderRadius: AppRadius.rSM,
                child: Image.network(
                  order.productImage,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported_rounded),
                ),
              ),
              title: Text(
                order.productName,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
              subtitle: Text(
                'الكمية الإجمالية المستلمة: ${order.quantity} وحدة',
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'الكمية المطلوب استبدالها:',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline_rounded, color: AppColors.primary),
                      onPressed: selectedQuantity > 1 ? () => onQuantityChanged(selectedQuantity - 1) : null,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                        borderRadius: AppRadius.rSM,
                      ),
                      child: Text(
                        '$selectedQuantity',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline_rounded, color: AppColors.primary),
                      onPressed: selectedQuantity < maxQuantity ? () => onQuantityChanged(selectedQuantity + 1) : null,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ReplacementReasonWidget extends StatelessWidget {
  final String selectedReason;
  final ValueChanged<String> onChanged;
  final List<String> reasons;

  const ReplacementReasonWidget({
    super.key,
    required this.selectedReason,
    required this.onChanged,
    required this.reasons,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.rMD,
        side: BorderSide(
          color: context.theme.brightness == Brightness.dark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'سبب طلب الاستبدال بالتفصيل',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary),
            ),
            const SizedBox(height: 12),
            for (final reason in reasons)
              RadioListTile<String>(
                title: Text(reason, style: const TextStyle(fontSize: 12)),
                value: reason,
                groupValue: selectedReason,
                activeColor: AppColors.primary,
                onChanged: (val) => onChanged(val ?? ''),
                contentPadding: EdgeInsets.zero,
                dense: true,
              ),
          ],
        ),
      ),
    );
  }
}

class AddressWidget extends StatelessWidget {
  final String address;
  final ValueChanged<String> onChanged;

  const AddressWidget({
    super.key,
    required this.address,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: address);
    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: controller.text.length),
    );

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.rMD,
        side: BorderSide(
          color: context.theme.brightness == Brightness.dark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'عنوان شحن واستلام السلع البديلة',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primary),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              maxLines: 2,
              decoration: const InputDecoration(
                hintText: 'أدخل العنوان التفصيلي لتوصيل القطع البديلة...',
                prefixIcon: Icon(Icons.location_on_rounded, size: 18),
                contentPadding: EdgeInsets.all(12),
              ),
              style: const TextStyle(fontSize: 12),
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}

class SubmitWidget extends StatelessWidget {
  final VoidCallback onSubmit;
  final VoidCallback onCancel;

  const SubmitWidget({
    super.key,
    required this.onSubmit,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PrimaryButton(
          label: 'تقديم طلب الاستبدال للمورد',
          icon: Icons.swap_horiz_rounded,
          onPressed: onSubmit,
        ),
        const SizedBox(height: 10),
        SecondaryButton(
          label: 'إلغاء وتراجع',
          icon: Icons.close_rounded,
          color: Colors.grey,
          onPressed: onCancel,
        ),
      ],
    );
  }
}

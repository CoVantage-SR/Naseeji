import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/reusable_widgets.dart';
import '../providers/quotations_provider.dart';

/// 1. ComparisonCardWidget
class ComparisonCardWidget extends StatelessWidget {
  final Quotation quotation;
  final VoidCallback onRemove;

  const ComparisonCardWidget({
    super.key,
    required this.quotation,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return PrimaryCard(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            children: [
              SupplierAvatar(name: quotation.supplierName, size: 40),
              const SizedBox(height: 8),
              Text(
                quotation.supplierName,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
              ),
              const SizedBox(height: 2),
              Text(
                'QTE-${quotation.id}',
                style: const TextStyle(color: Colors.grey, fontSize: 9),
              ),
            ],
          ),
          Positioned(
            top: -12,
            left: -12,
            child: CircleAvatar(
              backgroundColor: Colors.grey.shade200,
              radius: 10,
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.close_rounded, size: 12, color: Colors.black),
                onPressed: onRemove,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 2. ChooseQuotationButtonWidget
class ChooseQuotationButtonWidget extends StatelessWidget {
  final VoidCallback onTap;

  const ChooseQuotationButtonWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.rMD,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isDark ? AppColors.borderDark : Colors.grey.shade300,
            style: BorderStyle.solid,
            width: 1.5,
          ),
          borderRadius: AppRadius.rMD,
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add_rounded, color: AppColors.primary, size: 24),
            const SizedBox(height: 4),
            const Text(
              'أضف عرض سعر',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 3. ComparisonRowWidget
class ComparisonRowWidget extends StatelessWidget {
  final String label;
  final List<String> values;
  final List<bool>? highlightBest;

  const ComparisonRowWidget({
    super.key,
    required this.label,
    required this.values,
    this.highlightBest,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: isDark ? AppColors.borderDark : Colors.grey.shade200),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 11),
            ),
          ),
          for (int i = 0; i < values.length; i++)
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Text(
                  values[i],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: highlightBest != null && highlightBest![i]
                        ? AppColors.success
                        : context.colorScheme.onSurface,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

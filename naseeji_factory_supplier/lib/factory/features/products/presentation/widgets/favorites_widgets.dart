import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/reusable_widgets.dart';

class AddToFavoritesBottomSheet extends StatefulWidget {
  final String supplierName;
  final String supplierType;
  final void Function(String category, String note) onSave;

  const AddToFavoritesBottomSheet({
    super.key,
    required this.supplierName,
    required this.supplierType,
    required this.onSave,
  });

  @override
  State<AddToFavoritesBottomSheet> createState() => _AddToFavoritesBottomSheetState();
}

class _AddToFavoritesBottomSheetState extends State<AddToFavoritesBottomSheet> {
  final _categoryController = TextEditingController();
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _categoryController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'إضافة المورد إلى المفضلة',
            style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          AppSpacing.hMD,
          // Supplier Preview Widget
          Row(
            children: [
              SupplierAvatar(name: widget.supplierName, size: 40),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.supplierName, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(widget.supplierType, style: const TextStyle(color: Colors.grey, fontSize: 10)),
                ],
              ),
            ],
          ),
          AppSpacing.hLG,
          // Category Widget
          TextField(
            controller: _categoryController,
            decoration: const InputDecoration(
              labelText: 'تصنيف المفضلة (اختياري)',
              hintText: 'مثال: خيوط قطن، أقمشة شتوية...',
              prefixIcon: Icon(Icons.label_outline_rounded),
            ),
          ),
          AppSpacing.hMD,
          // Notes Widget
          TextField(
            controller: _noteController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'ملاحظاتك الخاصة (اختياري)',
              hintText: 'اكتب أي ملاحظة لتذكيرك بجودة المورد أو شروط تعامله...',
              prefixIcon: Icon(Icons.rate_review_outlined),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: AppColors.primary),
                    foregroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: AppRadius.rMD),
                  ),
                  child: const Text('إلغاء'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    widget.onSave(
                      _categoryController.text.trim(),
                      _noteController.text.trim(),
                    );
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: AppRadius.rMD),
                  ),
                  child: const Text('حفظ'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}




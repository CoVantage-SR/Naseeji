import 'package:flutter/material.dart';
import 'package:naseeji_factory/factory/core/constants/app_colors.dart';
import 'package:naseeji_factory/factory/core/constants/app_radius.dart';
import 'package:naseeji_factory/factory/core/constants/app_spacing.dart';
import '../product_search_widgets.dart';

class ProductFilterSheet extends StatefulWidget {
  final String initialCategory;
  final String initialGov;
  final double initialMaxPrice;
  final bool initialVerifiedOnly;
  final double initialMinRating;
  final Function(String, String, double, bool, double) onApply;

  const ProductFilterSheet({
    super.key,
    required this.initialCategory,
    required this.initialGov,
    required this.initialMaxPrice,
    required this.initialVerifiedOnly,
    required this.initialMinRating,
    required this.onApply,
  });

  @override
  State<ProductFilterSheet> createState() => _ProductFilterSheetState();
}

class _ProductFilterSheetState extends State<ProductFilterSheet> {
  late String _selectedCategory;
  late String _selectedGov;
  late double _maxPrice;
  late bool _verifiedOnly;
  late double _minRating;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
    _selectedGov = widget.initialGov;
    _maxPrice = widget.initialMaxPrice;
    _verifiedOnly = widget.initialVerifiedOnly;
    _minRating = widget.initialMinRating;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('تصفية متقدمة للمنتجات', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              TextButton(
                onPressed: () {
                  widget.onApply('', '', 200000, false, 0);
                  Navigator.of(context).pop();
                },
                child: const Text('إعادة ضبط', style: TextStyle(color: AppColors.error)),
              ),
            ],
          ),
          const Divider(),
          const SizedBox(height: 12),
          FilterSectionWidget(
            title: 'التصنيف الرئيسي',
            child: DropdownButtonFormField<String>(
              initialValue: _selectedCategory.isEmpty ? null : _selectedCategory,
              onChanged: (val) => setState(() => _selectedCategory = val ?? ''),
              decoration: const InputDecoration(hintText: 'اختر التصنيف'),
              items: const [
                DropdownMenuItem(value: 'yarn', child: Text('خيوط وتريكو')),
                DropdownMenuItem(value: 'fabric', child: Text('أقمشة وصباغة')),
              ],
            ),
          ),
          AppSpacing.hMD,
          FilterSectionWidget(
            title: 'محافظة المورد',
            child: DropdownButtonFormField<String>(
              initialValue: _selectedGov.isEmpty ? null : _selectedGov,
              onChanged: (val) => setState(() => _selectedGov = val ?? ''),
              decoration: const InputDecoration(hintText: 'اختر المحافظة'),
              items: const [
                DropdownMenuItem(value: 'الغربية', child: Text('الغربية (المحلة)')),
                DropdownMenuItem(value: 'الشرقية', child: Text('الشرقية (العاشر)')),
              ],
            ),
          ),
          AppSpacing.hMD,
          FilterSectionWidget(
            title: 'الحد الأقصى للسعر: ${_maxPrice.toInt()} ج.م',
            child: Slider(
              value: _maxPrice,
              min: 0,
              max: 200000,
              divisions: 20,
              activeColor: AppColors.primary,
              onChanged: (val) => setState(() => _maxPrice = val),
            ),
          ),
          FilterSectionWidget(
            title: 'الحد الأدنى لتقييم المورد: ${_minRating.toInt()} ⭐',
            child: Slider(
              value: _minRating,
              min: 0,
              max: 5,
              divisions: 5,
              activeColor: AppColors.secondary,
              onChanged: (val) => setState(() => _minRating = val),
            ),
          ),
          SwitchListTile(
            title: const Text('موردين موثقين فقط', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            value: _verifiedOnly,
            activeThumbColor: AppColors.primary,
            onChanged: (val) => setState(() => _verifiedOnly = val),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              widget.onApply(_selectedCategory, _selectedGov, _maxPrice, _verifiedOnly, _minRating);
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(borderRadius: AppRadius.rMD),
            ),
            child: const Text('تطبيق التصفية'),
          ),
        ],
      ),
    );
  }
}

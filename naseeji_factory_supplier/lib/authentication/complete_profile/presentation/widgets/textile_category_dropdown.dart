import 'package:flutter/material.dart';
import '../../../../shared/enums/user_role.dart';

class TextileCategoryDropdown extends StatelessWidget {
  final UserRole role;
  final String? selectedCategory;
  final String? errorText;
  final ValueChanged<String?> onChanged;

  const TextileCategoryDropdown({
    super.key,
    required this.role,
    this.selectedCategory,
    this.errorText,
    required this.onChanged,
  });

  static const List<String> factoryCategories = [
    'ملابس جاهزة (رجالي / حريمي / أطفال)',
    'غزول وأقمشة منسوجة',
    'مفروشات ومنسوجات منزلية',
    'تطريز وطباعة أقمشة',
    'صباغة وتجهيز أقمشة',
    'ملحقات وإكسسوارات ملابس',
    'منسوجات تقنية وصناعية',
  ];

  static const List<String> supplierCategories = [
    'مورد خامات وغزول قطنية وصناعية',
    'مورد أقمشة بالجملة والدرجات',
    'مورد ماكينات وخيوط نسيج',
    'مورد قطع غيار ومستلزمات صيانة',
    'مورد كيميائيات ومواد صباغة وتجهيز',
    'مورد أزرار وسوست وإكسسوارات',
    'مورد كراتين ومواد تغليف وتعبئة',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final categories =
        role == UserRole.factory ? factoryCategories : supplierCategories;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          role == UserRole.factory ? 'تخصص المصنع *' : 'تخصص المورد *',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          key: ValueKey(selectedCategory),
          initialValue: categories.contains(selectedCategory) ? selectedCategory : null,
          onChanged: onChanged,
          isExpanded: true,
          decoration: InputDecoration(
            hintText: 'اختر تخصصك الرئيسي',
            prefixIcon: Icon(
              Icons.category_outlined,
              color: colorScheme.outline,
            ),
            errorText: errorText,
          ),
          items: categories.map((cat) {
            return DropdownMenuItem<String>(
              value: cat,
              child: Text(
                cat,
                style: const TextStyle(fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

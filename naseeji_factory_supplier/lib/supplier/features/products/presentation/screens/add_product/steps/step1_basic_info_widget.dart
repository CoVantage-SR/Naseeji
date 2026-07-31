import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naseeji_factory/supplier/features/products/domain/entities/product_form_data.dart';
import 'package:naseeji_factory/supplier/features/products/presentation/controllers/add_product_controller.dart';

class Step1BasicInfoWidget extends ConsumerWidget {
  final ProductFormData formData;

  const Step1BasicInfoWidget({super.key, required this.formData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final controller = ref.read(addProductControllerProvider.notifier);

    const List<String> categories = [
      'خيوط ونُسُج',
      'أقمشة ملابس',
      'أقمشة راقية',
      'منسوجات منزلية ومفروشات',
      'مستلزمات ومعدات إنتاج',
    ];

    const List<String> subCategories = [
      'خيوط قطن غزل دائرية',
      'أقمشة سادة قطن تريكو',
      'أقمشة صوف مخلوط',
      'خيوط بوليستر سداء',
      'أقمشة كتان معالجة',
    ];

    const List<String> countries = [
      'جمهورية مصر العربية',
      'تركيا',
      'الهند',
      'الصين',
      'إيطاليا',
    ];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'المعلومات التعريفية للمنتج',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'أدخل الاسم التجاري والتصنيف لمساعدة المصانع في الوصول لمنتجك بسهولة في محرك البحث.',
            style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 16),

          // Product Name Input
          TextFormField(
            initialValue: formData.name,
            onChanged: (val) => controller.updateBasicInfo(name: val),
            decoration: const InputDecoration(
              labelText: 'اسم المنتج التجاري *',
              hintText: 'مثال: خيوط غزل القطن الفاخر الممشط 30/1',
              prefixIcon: Icon(Icons.inventory_2_outlined),
            ),
          ),
          const SizedBox(height: 14),

          // Main & Sub Category Dropdowns Row
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  isExpanded: true,
                  initialValue: categories.contains(formData.category) ? formData.category : categories.first,
                  onChanged: (val) => controller.updateBasicInfo(category: val),
                  items: categories
                      .map((c) => DropdownMenuItem(
                            value: c,
                            child: Text(
                              c,
                              style: const TextStyle(fontSize: 12.5),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ))
                      .toList(),
                  decoration: const InputDecoration(
                    labelText: 'الفئة الرئيسية *',
                    prefixIcon: Icon(Icons.category_outlined),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: DropdownButtonFormField<String>(
                  isExpanded: true,
                  initialValue: subCategories.contains(formData.subCategory) ? formData.subCategory : subCategories.first,
                  onChanged: (val) => controller.updateBasicInfo(subCategory: val),
                  items: subCategories
                      .map((c) => DropdownMenuItem(
                            value: c,
                            child: Text(
                              c,
                              style: const TextStyle(fontSize: 12.5),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ))
                      .toList(),
                  decoration: const InputDecoration(
                    labelText: 'الفئة الفرعية *',
                    prefixIcon: Icon(Icons.account_tree_outlined),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Brand & Country Row
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  isExpanded: true,
                  initialValue: countries.contains(formData.countryOfOrigin) ? formData.countryOfOrigin : countries.first,
                  onChanged: (val) => controller.updateBasicInfo(countryOfOrigin: val),
                  items: countries
                      .map((c) => DropdownMenuItem(
                            value: c,
                            child: Text(
                              c,
                              style: const TextStyle(fontSize: 12.5),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ))
                      .toList(),
                  decoration: const InputDecoration(
                    labelText: 'بلد المنشأ *',
                    prefixIcon: Icon(Icons.flag_outlined),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  initialValue: formData.brand,
                  onChanged: (val) => controller.updateBasicInfo(brand: val),
                  decoration: const InputDecoration(
                    labelText: 'العلامة التجارية *',
                    hintText: 'مثال: مصانع المحلة',
                    prefixIcon: Icon(Icons.branding_watermark_outlined),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Short Description
          TextFormField(
            initialValue: formData.shortDescription,
            onChanged: (val) => controller.updateBasicInfo(shortDescription: val),
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: 'وصف مختصر للمنتج (يظهر في نتائج البحث) *',
              hintText: 'اكتب وصفاً موجزاً في سطرين لخصائص النسيج والخامة...',
              prefixIcon: Icon(Icons.description_outlined),
            ),
          ),
          const SizedBox(height: 14),

          // Full Description
          TextFormField(
            initialValue: formData.fullDescription,
            onChanged: (val) => controller.updateBasicInfo(fullDescription: val),
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'الوصف التفصيلي الشامل للمنتج',
              hintText: 'اذكر كافة تفاصيل النسيج، المعالجات الكيميائية، ومجالات الاستخدام...',
              alignLabelWithHint: true,
            ),
          ),
        ],
      ),
    );
  }
}


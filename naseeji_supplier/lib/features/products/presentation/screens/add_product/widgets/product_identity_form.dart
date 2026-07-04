import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../../../controllers/add_product_controller.dart';

class ProductIdentityForm extends ConsumerStatefulWidget {
  const ProductIdentityForm({super.key});

  @override
  ConsumerState<ProductIdentityForm> createState() => _ProductIdentityFormState();
}

class _ProductIdentityFormState extends ConsumerState<ProductIdentityForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descController;

  final List<String> _categories = [
    'خيوط طبيعية',
    'أقمشة قطنية',
    'حرير طبيعي',
    'منسوجات صناعية',
  ];

  @override
  void initState() {
    super.initState();
    final initialData = ref.read(addProductControllerProvider);
    _nameController = TextEditingController(text: initialData.name);
    _descController = TextEditingController(text: initialData.description);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formData = ref.watch(addProductControllerProvider);
    final controller = ref.read(addProductControllerProvider.notifier);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Section Title: Identity
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  'هوية المنتج',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.info_outline, color: AppColors.primary, size: 20),
              ],
            ),
            const SizedBox(height: 20),

            // Product Name Field
            const Text(
              'اسم المنتج',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _nameController,
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              decoration: const InputDecoration(
                hintText: 'مثال: قطن مصري فاخر 100%',
              ),
              onChanged: controller.updateName,
            ),
            const SizedBox(height: 20),

            // Category Selector Field
            const Text(
              'الفئة',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: formData.category,
              alignment: AlignmentDirectional.centerEnd,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              icon: const Icon(Icons.expand_more, color: AppColors.onSurfaceVariant),
              items: _categories.map((category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(
                    category,
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(fontSize: 14),
                  ),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  controller.updateCategory(val);
                }
              },
            ),
            const SizedBox(height: 20),

            // Short Description Textarea Field
            const Text(
              'وصف مختصر',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _descController,
              maxLines: 3,
              maxLength: 200,
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              decoration: const InputDecoration(
                hintText: 'أدخل وصفاً موجزاً للمنتج ومميزاته الرئيسية...',
                counterText: '',
              ),
              onChanged: controller.updateDescription,
            ),
            const SizedBox(height: 4),
            Text(
              '${formData.description.length} / 200 حرف',
              textAlign: TextAlign.left,
              style: const TextStyle(fontSize: 11, color: AppColors.outline),
            ),
            const SizedBox(height: 24),
            const Divider(color: AppColors.outlineVariant, height: 1),
            const SizedBox(height: 24),

            // Section Title: Classification
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  'نوع المنتج والاستخدام',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.category_outlined, color: AppColors.primary, size: 20),
              ],
            ),
            const SizedBox(height: 20),

            // Product Nature Custom Radio
            const Text(
              'طبيعة المنتج',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      controller.updateProductNature('صناعي');
                    },
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                        color: formData.productNature == 'صناعي'
                            ? AppColors.primary.withValues(alpha: 0.08)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: formData.productNature == 'صناعي'
                              ? AppColors.primary
                              : AppColors.outlineVariant,
                          width: formData.productNature == 'صناعي' ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.factory_outlined,
                            color: formData.productNature == 'صناعي'
                                ? AppColors.primary
                                : AppColors.onSurfaceVariant,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'صناعي',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: formData.productNature == 'صناعي'
                                  ? AppColors.primary
                                  : AppColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      controller.updateProductNature('تجزئة');
                    },
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                        color: formData.productNature == 'تجزئة'
                            ? AppColors.primary.withValues(alpha: 0.08)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: formData.productNature == 'تجزئة'
                              ? AppColors.primary
                              : AppColors.outlineVariant,
                          width: formData.productNature == 'تجزئة' ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.storefront_outlined,
                            color: formData.productNature == 'تجزئة'
                                ? AppColors.primary
                                : AppColors.onSurfaceVariant,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'تجزئة',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: formData.productNature == 'تجزئة'
                                  ? AppColors.primary
                                  : AppColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Visibility Toggle Box
            const Text(
              'حالة العرض',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.5)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Switch.adaptive(
                    value: formData.availableForDirectOrder,
                    activeThumbColor: AppColors.primary,
                    activeTrackColor: AppColors.primary.withValues(alpha: 0.5),
                    onChanged: controller.updateAvailableForDirectOrder,
                  ),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'متاح للطلب المباشر',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.onSurface,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'سيتمكن العملاء من الشراء فوراً',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Actions row
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Move to next step or submit
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    minimumSize: const Size(120, 48),
                  ),
                  icon: const Icon(Icons.arrow_back, size: 18),
                  label: const Text(
                    'التالي',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    minimumSize: const Size(120, 48),
                  ),
                  child: const Text(
                    'حفظ كمسودة',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../../../controllers/add_product_controller.dart';
import '../../../widgets/upgrade_dialog.dart';
import '../../../../../subscription/presentation/controllers/subscription_controllers.dart';

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

  void _validateAndUploadAsset(BuildContext context, String type) {
    final sub = ref.read(activeSubscriptionControllerProvider).value;
    final usage = ref.read(subscriptionUsageControllerProvider).value;
    if (sub == null || usage == null) return;

    final double maxVideos = sub.planId == 'free' ? 0.0 : 20.0;
    final double maxPDFs = sub.planId == 'free' ? 1.0 : 2.0;
    final double maxStorage = sub.planId == 'free' ? 1.0 : 5.0;

    if (type == 'video' && usage.aiReportsUsed >= maxVideos) {
      _showUploadLimitReachedDialog(
        context,
        'نفدت مساحة رفع مقاطع الفيديو المميزة',
        'لقد استهلكت جميع مساحات رفع الفيديو المسموحة في باقتك (${maxVideos.toStringAsFixed(0)} فيديو). يرجى الترقية أو شراء حزمة مقاطع فيديو إضافية.',
      );
      return;
    }

    if (type == 'pdf' && usage.branchesUsed >= maxPDFs) {
      _showUploadLimitReachedDialog(
        context,
        'نفدت مساحة رفع الكتالوجات الفنية',
        'لقد استهلكت الحد الأقصى لملفات الكتالوج المتاحة (${maxPDFs.toStringAsFixed(0)} ملفات). يرجى الترقية أو شراء حزمة كتالوجات إضافية.',
      );
      return;
    }

    if (type == 'storage' && usage.storageUsedGb >= maxStorage) {
      _showUploadLimitReachedDialog(
        context,
        'نفذت مساحة التخزين السحابية للمؤسسة',
        'لقد استهلكت الحد الأقصى لمساحة التخزين السحابية المخصصة (${maxStorage.toStringAsFixed(0)} جيجابايت). يرجى الترقية لزيادة السعة.',
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تم رفع ملف الـ $type بنجاح وحفظه في مساحة السحابة.')),
    );
  }

  void _showUploadLimitReachedDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (ctx) => UpgradeDialog(
        title: title,
        content: message,
        onUpgrade: () => context.push('/subscription/plans'),
        onBuyPack: () => context.push('/subscription/addons'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formData = ref.watch(addProductControllerProvider);
    final controller = ref.read(addProductControllerProvider.notifier);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
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
                Text(
                  'هوية المنتج',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.info_outline, color: AppColors.primary, size: 20),
              ],
            ),
            SizedBox(height: 20),

            // Product Name Field
            Text(
              'اسم المنتج',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 8),
            TextFormField(
              controller: _nameController,
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              decoration: const InputDecoration(
                hintText: 'مثال: قطن مصري فاخر 100%',
              ),
              onChanged: controller.updateName,
            ),
            SizedBox(height: 20),

            // Category Selector Field
            Text(
              'الفئة',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: formData.category,
              alignment: AlignmentDirectional.centerEnd,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              icon: const Icon(Icons.expand_more, color: Theme.of(context).colorScheme.onSurfaceVariant),
              items: _categories.map((category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(
                    category,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(fontSize: 14),
                  ),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  controller.updateCategory(val);
                }
              },
            ),
            SizedBox(height: 20),

            // Short Description Textarea Field
            Text(
              'وصف مختصر',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 8),
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
            SizedBox(height: 4),
            Text(
              '${formData.description.length} / 200 حرف',
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 11, color: AppColors.outline),
            ),
            SizedBox(height: 24),
            const Divider(color: AppColors.outlineVariant, height: 1),
            SizedBox(height: 24),

            // Section Title: Classification
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'نوع المنتج والاستخدام',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.category_outlined, color: AppColors.primary, size: 20),
              ],
            ),
            SizedBox(height: 20),

            // Product Nature Custom Radio
            Text(
              'طبيعة المنتج',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 12),
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
                                : Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                          SizedBox(height: 6),
                          Text(
                            'صناعي',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: formData.productNature == 'صناعي'
                                  ? AppColors.primary
                                  : Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
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
                                : Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                          SizedBox(height: 6),
                          Text(
                            'تجزئة',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: formData.productNature == 'تجزئة'
                                  ? AppColors.primary
                                  : Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),

            // Visibility Toggle Box
            Text(
              'حالة العرض',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'متاح للطلب المباشر',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'سيتمكن العملاء من الشراء فوراً',
                        style: TextStyle(
                          fontSize: 11,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),

            // Media Assets Box
            Text(
              'ملفات الوسائط والكتالوجات التقنية B2B',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.5)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => _validateAndUploadAsset(context, 'image'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.surface,
                          foregroundColor: const Color(0xFF0040E0),
                          minimumSize: const Size(120, 36),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        icon: const Icon(Icons.image, size: 16),
                        label: Text('رفع صور المنتج', style: TextStyle(fontSize: 11)),
                      ),
                      Text('الصور التوضيحية للأقمشة (حد 5 صور)', style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => _validateAndUploadAsset(context, 'video'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.surface,
                          foregroundColor: const Color(0xFF0040E0),
                          minimumSize: const Size(120, 36),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        icon: const Icon(Icons.videocam, size: 16),
                        label: Text('رفع فيديو توضيحي', style: TextStyle(fontSize: 11)),
                      ),
                      Text('مقاطع الفيديو وعينات النسيج المتحركة', style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => _validateAndUploadAsset(context, 'pdf'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.surface,
                          foregroundColor: const Color(0xFF0040E0),
                          minimumSize: const Size(120, 36),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        icon: const Icon(Icons.picture_as_pdf, size: 16),
                        label: Text('رفع كتالوج PDF', style: TextStyle(fontSize: 11)),
                      ),
                      Text('ملفات التحليل الفني وشهادات الجودة', style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),

            // Actions row
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Move to next step or submit
                      controller.setStep(2);
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
                  label: Text(
                    'التالي',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(width: 12),
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
                  child: Text(
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

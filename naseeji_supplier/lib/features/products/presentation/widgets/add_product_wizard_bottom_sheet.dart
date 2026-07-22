import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/products_providers.dart';

class AddProductWizardBottomSheet extends ConsumerStatefulWidget {
  const AddProductWizardBottomSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const AddProductWizardBottomSheet(),
    );
  }

  @override
  ConsumerState<AddProductWizardBottomSheet> createState() => _AddProductWizardBottomSheetState();
}

class _AddProductWizardBottomSheetState extends ConsumerState<AddProductWizardBottomSheet> {
  int _currentStep = 1; // 1 to 7

  // Form Fields
  final _nameController = TextEditingController(text: 'قماش تريكو قطني معالج');
  final _categoryController = TextEditingController(text: 'أقمشة ملابس');
  final _subCategoryController = TextEditingController(text: 'أقمشة سادة تريكو');
  final _brandController = TextEditingController(text: 'مصانع القاهرة للنسيج');
  final _countryController = TextEditingController(text: 'مصر');

  final _specsMaterialController = TextEditingController(text: 'قطن مصري 100%');
  final _specsWeightController = TextEditingController(text: '200 جرام/متر');

  final _priceController = TextEditingController(text: '80.0');
  final _moqController = TextEditingController(text: '100');
  final _stockController = TextEditingController(text: '2500');
  final _pickupController = TextEditingController(text: 'مخزن العاشر من رمضان');

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _subCategoryController.dispose();
    _brandController.dispose();
    _countryController.dispose();
    _specsMaterialController.dispose();
    _specsWeightController.dispose();
    _priceController.dispose();
    _moqController.dispose();
    _stockController.dispose();
    _pickupController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.85 + bottomInset,
        padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + bottomInset),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle Bar & Close Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3), shape: BoxShape.circle),
                  child: Icon(Icons.add_shopping_cart_rounded, color: theme.colorScheme.primary, size: 18),
                ),
                const SizedBox(width: 8),
                Text(
                  'إضافة منتج خامة جديد (خطوة $_currentStep من 7)',
                  style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
                ),
                const Spacer(),
                IconButton(icon: const Icon(Icons.close_rounded, size: 18), onPressed: () => Navigator.pop(context)),
              ],
            ),

            // Step Progress Indicator
            LinearProgressIndicator(
              value: _currentStep / 7.0,
              color: theme.colorScheme.primary,
              backgroundColor: theme.colorScheme.surfaceContainerLow,
              minHeight: 4,
            ),
            const SizedBox(height: 12),

            // Step Title
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                _getStepTitle(_currentStep),
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
              ),
            ),
            const SizedBox(height: 12),

            // Step Form Content
            Expanded(
              child: SingleChildScrollView(
                child: _buildStepForm(_currentStep),
              ),
            ),

            // Bottom Navigation Buttons
            Row(
              children: [
                if (_currentStep > 1)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => setState(() => _currentStep--),
                      style: OutlinedButton.styleFrom(minimumSize: const Size(0, 42)),
                      child: const Text('السابق'),
                    ),
                  ),
                if (_currentStep > 1) const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_currentStep < 7) {
                        setState(() => _currentStep++);
                      } else {
                        _submitProduct();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(0, 42),
                    ),
                    child: Text(_currentStep == 7 ? 'تقديم للمراجعة والنشر' : 'التالي'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getStepTitle(int step) {
    switch (step) {
      case 1:
        return '١. المعلومات الأساسية';
      case 2:
        return '٢. المواصفات الفنية والقياسية';
      case 3:
        return '٣. الصور الرسمية للمنتج';
      case 4:
        return '٤. فيديو استعراض الخامة (اختياري)';
      case 5:
        return '٥. كتالوجات ومستندات PDF';
      case 6:
        return '٦. الأسعار والجملة والمخزون';
      case 7:
        return '٧. المراجعة والنشر النهائي';
      default:
        return '';
    }
  }

  Widget _buildStepForm(int step) {
    switch (step) {
      case 1:
        return Column(
          children: [
            _buildField(_nameController, 'اسم المنتج الخامة (مثال: غزل قطن 30/1)', Icons.title),
            const SizedBox(height: 8),
            _buildField(_categoryController, 'الفئة الرئيسية', Icons.category_outlined),
            const SizedBox(height: 8),
            _buildField(_subCategoryController, 'الفئة الفرعية', Icons.subdirectory_arrow_right_rounded),
            const SizedBox(height: 8),
            _buildField(_brandController, 'العلامة التجارية / المصنع', Icons.factory_outlined),
          ],
        );
      case 2:
        return Column(
          children: [
            _buildField(_specsMaterialController, 'الخامة والمكونات', Icons.texture_outlined),
            const SizedBox(height: 8),
            _buildField(_specsWeightController, 'الوزن/الكثافة (جم/م٢ أو دنييه)', Icons.fitness_center_outlined),
            const SizedBox(height: 8),
            _buildField(_countryController, 'بلد المنشأ (جمهورية مصر العربية)', Icons.flag_outlined),
          ],
        );
      case 3:
        return Column(
          children: [
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.cloud_upload_outlined, size: 32, color: Colors.blue),
                  const SizedBox(height: 4),
                  const Text('اضغط لرفع الغلاف الرئيسي للمنتج', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                  Text('الحد الأقصى بحسب الباقة: 10 صور', style: TextStyle(fontSize: 8.5, color: Theme.of(context).colorScheme.outline)),
                ],
              ),
            ),
          ],
        );
      case 4:
        return Column(
          children: [
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.videocam_outlined, size: 28, color: Colors.purple),
                    SizedBox(height: 4),
                    Text('إرفاق فيديو توضيحي لملمس الخامة والجودة', style: TextStyle(fontSize: 10)),
                  ],
                ),
              ),
            ),
          ],
        );
      case 5:
        return Column(
          children: [
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.picture_as_pdf_outlined, size: 28, color: Colors.red),
                    SizedBox(height: 4),
                    Text('رفع كتالوج PDF أو تقرير الفحص المعملي', style: TextStyle(fontSize: 10)),
                  ],
                ),
              ),
            ),
          ],
        );
      case 6:
        return Column(
          children: [
            _buildField(_priceController, 'سعر الوحدة بداية من (ج.م)', Icons.attach_money_rounded, isNum: true),
            const SizedBox(height: 8),
            _buildField(_moqController, 'أقل كمية للطلب (MOQ)', Icons.shopping_bag_outlined, isNum: true),
            const SizedBox(height: 8),
            _buildField(_stockController, 'المخزون المتاح بالكامل', Icons.inventory_2_outlined, isNum: true),
            const SizedBox(height: 8),
            _buildField(_pickupController, 'مكان الاستلام والمخزن', Icons.location_on_outlined),
          ],
        );
      case 7:
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.check_circle_outline, color: Colors.green, size: 18),
                      SizedBox(width: 6),
                      Text('جاهز لإرسال المنتج للمراجعة والنشر!', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.green)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text('الاسم: ${_nameController.text}', style: const TextStyle(fontSize: 10)),
                  Text('السعر: ${_priceController.text} ج.م', style: const TextStyle(fontSize: 10)),
                  Text('المخزون: ${_stockController.text}', style: const TextStyle(fontSize: 10)),
                  Text('المكان: ${_pickupController.text}', style: const TextStyle(fontSize: 10)),
                ],
              ),
            ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildField(TextEditingController ctrl, String label, IconData icon, {bool isNum = false}) {
    return TextField(
      controller: ctrl,
      keyboardType: isNum ? TextInputType.number : TextInputType.text,
      style: const TextStyle(fontSize: 11.5),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: 10.5, color: Theme.of(context).colorScheme.outline),
        prefixIcon: Icon(icon, size: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      ),
    );
  }

  void _submitProduct() {
    ref.invalidate(productsProvider);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم تقديم المنتج بنجاح وهوا دلوقتي "بانتظار المراجعة" 🚀'),
        backgroundColor: Colors.amber,
      ),
    );
  }
}

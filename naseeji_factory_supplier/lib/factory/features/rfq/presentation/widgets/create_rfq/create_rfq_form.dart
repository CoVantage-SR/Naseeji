// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:naseeji_factory/core/constants/app_colors.dart';
import 'package:naseeji_factory/core/constants/app_radius.dart';
import 'package:naseeji_factory/core/constants/app_spacing.dart';
import '../../providers/rfq_provider.dart';
import '../create_rfq_widgets.dart';

class CreateRFQForm extends ConsumerStatefulWidget {
  const CreateRFQForm({super.key});

  @override
  ConsumerState<CreateRFQForm> createState() => _CreateRFQFormState();
}

class _CreateRFQFormState extends ConsumerState<CreateRFQForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _productNameController = TextEditingController();
  final _materialController = TextEditingController();
  final _colorController = TextEditingController();
  final _sizeController = TextEditingController();
  final _qualityController = TextEditingController();
  final _qtyController = TextEditingController();
  final _addressController = TextEditingController();

  String _selectedCategory = 'خيوط وتريكو';
  String _selectedUnit = 'كيلو جرام';
  String _selectedGov = 'الغربية';
  String _selectedCity = 'المحلة الكبرى';
  DateTime? _deliveryDate = DateTime.now().add(const Duration(days: 30));
  final List<String> _attachments = [];
  bool _sendToRecommended = true;

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _productNameController.dispose();
    _materialController.dispose();
    _colorController.dispose();
    _sizeController.dispose();
    _qualityController.dispose();
    _qtyController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _deliveryDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _deliveryDate = picked;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ref.read(rFQNotifierProvider.notifier).createRFQ(
            title: _titleController.text.trim(),
            category: _selectedCategory,
            description: _descController.text.trim(),
            material: _materialController.text.trim(),
            color: _colorController.text.trim(),
            size: _sizeController.text.trim(),
            qualityLevel: _qualityController.text.trim(),
            quantity: int.tryParse(_qtyController.text) ?? 500,
            unit: _selectedUnit,
            governorate: _selectedGov,
            city: _selectedCity,
            address: _addressController.text.trim(),
            deliveryDate: _deliveryDate != null
                ? '${_deliveryDate!.year}/${_deliveryDate!.month}/${_deliveryDate!.day}'
                : 'غير محدد',
            attachments: _attachments,
            sendToRecommended: _sendToRecommended,
            selectedSupplierIds: _sendToRecommended ? [] : ['sup_1', 'sup_2'],
          );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم إنشاء ونشر طلب عرض السعر (RFQ) بنجاح!')),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 1. Basic Info
            FormSectionContainer(
              title: 'المعلومات الأساسية',
              child: Column(
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'عنوان الطلب',
                      hintText: 'مثال: توريد خيوط قطنية للموسم الشتوي',
                      prefixIcon: Icon(Icons.title_rounded),
                    ),
                    validator: (val) => val == null || val.isEmpty ? 'يرجى كتابة عنوان الطلب' : null,
                  ),
                  AppSpacing.hMD,
                  DropdownButtonFormField<String>(
                    initialValue: _selectedCategory,
                    onChanged: (val) => setState(() => _selectedCategory = val ?? ''),
                    decoration: const InputDecoration(
                      labelText: 'التصنيف الرئيسي للطلب',
                      prefixIcon: Icon(Icons.category_outlined),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'خيوط وتريكو', child: Text('خيوط وتريكو')),
                      DropdownMenuItem(value: 'أقمشة وصباغة', child: Text('أقمشة وصباغة')),
                      DropdownMenuItem(value: 'إكسسوارات وملحقات', child: Text('إكسسوارات وملحقات')),
                      DropdownMenuItem(value: 'تغليف وتعبئة', child: Text('تغليف وتعبئة')),
                    ],
                  ),
                  AppSpacing.hMD,
                  TextFormField(
                    controller: _descController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'شرح وتفاصيل الطلب الشاملة',
                      hintText: 'اكتب هنا شروط الإنتاج، الشهادات المطلوبة، أو أي شروط توريد خاصة بالجهة المشترية...',
                      prefixIcon: Icon(Icons.description_outlined),
                    ),
                    validator: (val) => val == null || val.isEmpty ? 'يرجى توضيح شرح تفاصيل الطلب' : null,
                  ),
                ],
              ),
            ),
            AppSpacing.hMD,

            // 2. Product Details
            FormSectionContainer(
              title: 'المواصفات الفنية للمنتج المطلوب',
              child: Column(
                children: [
                  TextFormField(
                    controller: _productNameController,
                    decoration: const InputDecoration(
                      labelText: 'اسم المنتج المطلوب',
                      hintText: 'خيوط قطن ممشط 30/1، قماش جينز متين...',
                      prefixIcon: Icon(Icons.shopping_bag_outlined),
                    ),
                  ),
                  AppSpacing.hMD,
                  TextFormField(
                    controller: _materialController,
                    decoration: const InputDecoration(
                      labelText: 'التركيب الكيميائي والخامة',
                      hintText: '100% قطن مصري، 65% بوليستر و 35% ليكرا...',
                      prefixIcon: Icon(Icons.gradient_outlined),
                    ),
                  ),
                  AppSpacing.hMD,
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _colorController,
                          decoration: const InputDecoration(
                            labelText: 'اللون المطلوب',
                            hintText: 'أبيض، كحلي...',
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _sizeController,
                          decoration: const InputDecoration(
                            labelText: 'المقاس / العرض',
                            hintText: 'عرض 150 سم، نمرة 30/1...',
                          ),
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.hMD,
                  TextFormField(
                    controller: _qualityController,
                    decoration: const InputDecoration(
                      labelText: 'مستوى الجودة (Quality Grade)',
                      hintText: 'نخب أول (Grade A)، تجاري ممتاز...',
                      prefixIcon: Icon(Icons.workspace_premium_outlined),
                    ),
                  ),
                ],
              ),
            ),
            AppSpacing.hMD,

            // 3. Quantity & Unit
            FormSectionContainer(
              title: 'الكميات المطلوبة والوحدات قياس',
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      controller: _qtyController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'الكمية الإجمالية',
                        prefixIcon: Icon(Icons.numbers_rounded),
                      ),
                      validator: (val) {
                        if (val == null || val.isEmpty) return 'يرجى تحديد الكمية';
                        if (int.tryParse(val) == null) return 'الرقم غير صالح';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: DropdownButtonFormField<String>(
                      initialValue: _selectedUnit,
                      onChanged: (val) => setState(() => _selectedUnit = val ?? 'كيلو جرام'),
                      decoration: const InputDecoration(
                        labelText: 'الوحدة',
                      ),
                      items: const [
                        DropdownMenuItem(value: 'كيلو جرام', child: Text('كيلو جرام')),
                        DropdownMenuItem(value: 'متر', child: Text('متر')),
                        DropdownMenuItem(value: 'بكرة', child: Text('بكرة')),
                        DropdownMenuItem(value: 'قطعة', child: Text('قطعة')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            AppSpacing.hMD,

            // 4. Attachments
            FormSectionContainer(
              title: 'مرفقات المستندات الفنية والكتالوجات',
              child: AttachmentsWidget(
                attachments: _attachments,
                onAddTap: () {
                  setState(() {
                    _attachments.add('ملف_مواصفات_فنية_رقم_${_attachments.length + 1}.pdf');
                  });
                },
                onRemoveTap: (idx) {
                  setState(() {
                    _attachments.removeAt(idx);
                  });
                },
              ),
            ),
            AppSpacing.hMD,

            // 5. Delivery Information
            FormSectionContainer(
              title: 'شروط التسليم والعنوان المفضل',
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: _selectedGov,
                          onChanged: (val) => setState(() => _selectedGov = val ?? ''),
                          decoration: const InputDecoration(labelText: 'المحافظة'),
                          items: const [
                            DropdownMenuItem(value: 'القاهرة', child: Text('القاهرة')),
                            DropdownMenuItem(value: 'الجيزة', child: Text('الجيزة')),
                            DropdownMenuItem(value: 'الغربية', child: Text('الغربية')),
                            DropdownMenuItem(value: 'الشرقية', child: Text('الشرقية')),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: _selectedCity,
                          onChanged: (val) => setState(() => _selectedCity = val ?? ''),
                          decoration: const InputDecoration(labelText: 'المدينة'),
                          items: const [
                            DropdownMenuItem(value: 'المحلة الكبرى', child: Text('المحلة الكبرى')),
                            DropdownMenuItem(value: 'السادس من أكتوبر', child: Text('السادس من أكتوبر')),
                            DropdownMenuItem(value: 'بدر', child: Text('بدر')),
                          ],
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.hMD,
                  TextFormField(
                    controller: _addressController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'عنوان المصنع التفصيلي للاستلام الشحنة',
                      prefixIcon: Icon(Icons.location_on_outlined),
                    ),
                    validator: (val) => val == null || val.isEmpty ? 'يرجى كتابة عنوان التوصيل' : null,
                  ),
                  AppSpacing.hMD,
                  InkWell(
                    onTap: () => _selectDate(context),
                    borderRadius: AppRadius.rMD,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: AppRadius.rMD,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.calendar_today_rounded, color: Colors.grey, size: 20),
                              SizedBox(width: 12),
                              Text('تاريخ التسليم المطلوب النهائي'),
                            ],
                          ),
                          Text(
                            _deliveryDate != null
                                ? '${_deliveryDate!.year}/${_deliveryDate!.month}/${_deliveryDate!.day}'
                                : 'اختر التاريخ',
                            style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            AppSpacing.hMD,

            // 6. Supplier Selection
            FormSectionContainer(
              title: 'دعوة الموردين والمصانع الشريكة',
              child: Column(
                children: [
                  RadioListTile<bool>(
                    title: const Text('إرسال إلى جميع الموردين الموصى بهم تلقائياً (سرعة وتنافسية أعلى)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    value: true,
                    groupValue: _sendToRecommended,
                    activeColor: AppColors.primary,
                    onChanged: (val) => setState(() => _sendToRecommended = val ?? true),
                  ),
                  RadioListTile<bool>(
                    title: const Text('تحديد موردين بأعينهم فقط من قائمة المفضلين المعتمدين', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    value: false,
                    groupValue: _sendToRecommended,
                    activeColor: AppColors.primary,
                    onChanged: (val) => setState(() => _sendToRecommended = val ?? false),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Action Buttons Row
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
                    child: const Text('حفظ كمسودة'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: AppRadius.rMD),
                    ),
                    child: const Text('نشر وإرسال الـ RFQ'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}



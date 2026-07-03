import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/general_widgets.dart';
import '../controllers/registration_controller.dart';

class SupplierRegistrationScreen extends ConsumerStatefulWidget {
  const SupplierRegistrationScreen({super.key});

  @override
  ConsumerState<SupplierRegistrationScreen> createState() => _SupplierRegistrationScreenState();
}

class _SupplierRegistrationScreenState extends ConsumerState<SupplierRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _companyController = TextEditingController();
  final _crController = TextEditingController();
  final _taxController = TextEditingController();
  
  final List<String> _availableCategories = ['أقمشة', 'خيوط', 'أزرار وإكسسوارات', 'خدمات تطريز', 'خدمات طباعة', 'خامات صوف', 'خامات قطن'];
  final List<String> _selectedCategories = [];
  String? _uploadedFileName;

  @override
  void dispose() {
    _companyController.dispose();
    _crController.dispose();
    _taxController.dispose();
    super.dispose();
  }

  void _toggleCategory(String category) {
    setState(() {
      if (_selectedCategories.contains(category)) {
        _selectedCategories.remove(category);
      } else {
        _selectedCategories.add(category);
      }
    });
  }

  void _simulateFileUpload() {
    setState(() {
      _uploadedFileName = 'commercial_registry_doc.pdf';
    });
    ref.read(registrationControllerProvider.notifier).updateDocumentPath('/mock/path/commercial_registry_doc.pdf');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم تحميل ملف السجل التجاري بنجاح (محاكاة).')),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategories.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى اختيار تصنيف واحد على الأقل للمواد التي توردها.'), backgroundColor: AppColors.error),
      );
      return;
    }
    if (_uploadedFileName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى إرفاق ملف السجل التجاري لإكمال التوثيق.'), backgroundColor: AppColors.error),
      );
      return;
    }

    // 1. Update details in controller state
    ref.read(registrationControllerProvider.notifier).updateCompanyDetails(
          companyName: _companyController.text.trim(),
          commercialRegistry: _crController.text.trim(),
          taxNumber: _taxController.text.trim(),
          categories: _selectedCategories,
        );

    // 2. Submit data
    final success = await ref.read(registrationControllerProvider.notifier).submitSupplierRegistration();
    if (mounted && success) {
      // Show Success Dialog & go to login screen
      _showSuccessDialog();
    } else if (mounted) {
      final errorMsg = ref.read(registrationControllerProvider).errorMessage ?? 'حدث خطأ أثناء حفظ البيانات';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMsg), backgroundColor: AppColors.error),
      );
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              const CircleAvatar(
                radius: 36,
                backgroundColor: AppColors.secondaryContainer,
                child: Icon(Icons.check_circle, color: AppColors.secondary, size: 48),
              ),
              const SizedBox(height: 24),
              const Text(
                'تم تقديم الطلب بنجاح',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                'طلب التوثيق الخاص بك قيد المراجعة الآن. سنقوم بإشعارك فور اكتمال المراجعة وتفعيل الحساب.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: AppColors.onSurfaceVariant, height: 1.5),
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                text: 'تسجيل الدخول',
                onPressed: () {
                  Navigator.of(context).pop();
                  ref.read(registrationControllerProvider.notifier).resetSuccess();
                  context.go('/login');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(registrationControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'بيانات التوثيق والمؤسسة',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SafeArea(
        child: LoadingOverlay(
          isLoading: state.isLoading,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  const Text(
                    'توثيق حساب المورد',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.onBackground,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'يرجى تزويدنا بالبيانات التجارية الرسمية لتوثيق شركتك أو مصنعك على المنصة',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Company Name
                  CustomTextField(
                    controller: _companyController,
                    labelText: 'الاسم التجاري للمؤسسة / المصنع',
                    prefixIcon: Icons.business_outlined,
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'يرجى إدخال اسم المؤسسة';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  // CR Number
                  CustomTextField(
                    controller: _crController,
                    labelText: 'رقم السجل التجاري',
                    prefixIcon: Icons.analytics_outlined,
                    keyboardType: TextInputType.number,
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'يرجى إدخال رقم السجل التجاري';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  // Tax number
                  CustomTextField(
                    controller: _taxController,
                    labelText: 'الرقم الضريبي للمؤسسة',
                    prefixIcon: Icons.receipt_long_outlined,
                    keyboardType: TextInputType.number,
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'يرجى إدخال الرقم الضريبي';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  // Categories Label
                  const Text(
                    'التصنيفات والمنتجات التي توردها',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: _availableCategories.map((category) {
                      final isSelected = _selectedCategories.contains(category);
                      return ChoiceChip(
                        label: Text(category),
                        selected: isSelected,
                        onSelected: (_) => _toggleCategory(category),
                        selectedColor: AppColors.primaryContainer,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : AppColors.onSurface,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  // File uploader card design
                  const Text(
                    'إرفاق السجل التجاري (PDF)',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: _simulateFileUpload,
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.outlineVariant,
                          style: BorderStyle.solid,
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        children: [
                          const Icon(Icons.cloud_upload_outlined, size: 40, color: AppColors.primary),
                          const SizedBox(height: 12),
                          Text(
                            _uploadedFileName ?? 'اضغط هنا لرفع نسخة من السجل التجاري',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: _uploadedFileName != null ? FontWeight.bold : FontWeight.normal,
                              color: _uploadedFileName != null ? AppColors.primary : AppColors.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'الحد الأقصى للملف 10 ميجا بايت (صيغة PDF)',
                            style: TextStyle(fontSize: 12, color: AppColors.outline),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Submit
                  PrimaryButton(
                    text: 'إرسال طلب التوثيق',
                    onPressed: _submit,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

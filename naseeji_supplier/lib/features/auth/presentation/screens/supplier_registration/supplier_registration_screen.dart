import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import 'package:naseeji_supplier/core/widgets/general_widgets.dart';
import 'package:naseeji_supplier/features/auth/presentation/controllers/registration_controller.dart';
import 'widgets/category_selector.dart';
import 'widgets/document_uploader.dart';

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

    ref.read(registrationControllerProvider.notifier).updateCompanyDetails(
          companyName: _companyController.text.trim(),
          commercialRegistry: _crController.text.trim(),
          taxNumber: _taxController.text.trim(),
          categories: _selectedCategories,
        );

    final success = await ref.read(registrationControllerProvider.notifier).submitSupplierRegistration();
    if (mounted && success) {
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
              SizedBox(height: 16),
              const CircleAvatar(
                radius: 36,
                backgroundColor: AppColors.secondaryContainer,
                child: Icon(Icons.check_circle, color: AppColors.secondary, size: 48),
              ),
              SizedBox(height: 24),
              Text(
                'تم تقديم الطلب بنجاح',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              Text(
                'طلب التوثيق الخاص بك قيد المراجعة الآن. سنقوم بإشعارك فور اكتمال المراجعة وتفعيل الحساب.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSurfaceVariant, height: 1.5),
              ),
              SizedBox(height: 24),
              PrimaryButton(
                text: 'الانتقال للرئيسية',
                onPressed: () {
                  Navigator.of(context).pop();
                  ref.read(registrationControllerProvider.notifier).resetSuccess();
                  context.go('/home');
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
        title: Text(
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
                  Text(
                    'توثيق حساب المورد',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'يرجى تزويدنا بالبيانات التجارية الرسمية لتوثيق شركتك أو مصنعك على المنصة',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 32),
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
                  SizedBox(height: 16),
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
                  SizedBox(height: 16),
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
                  SizedBox(height: 24),
                  Text(
                    'التصنيفات والمنتجات التي توردها',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  CategorySelector(
                    availableCategories: _availableCategories,
                    selectedCategories: _selectedCategories,
                    onToggle: _toggleCategory,
                  ),
                  SizedBox(height: 24),
                  Text(
                    'إرفاق السجل التجاري (PDF)',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  DocumentUploader(
                    uploadedFileName: _uploadedFileName,
                    onTap: _simulateFileUpload,
                  ),
                  SizedBox(height: 40),
                  PrimaryButton(
                    text: 'إرسال طلب التوثيق',
                    onPressed: _submit,
                  ),
                  SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

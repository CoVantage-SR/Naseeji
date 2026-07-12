import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import 'package:naseeji_supplier/core/theme/app_theme.dart';
import 'package:naseeji_supplier/core/widgets/general_widgets.dart';
import 'package:naseeji_supplier/features/auth/domain/entities/supplier_registration_data.dart';
import 'package:naseeji_supplier/features/auth/presentation/controllers/registration_controller.dart';

class GoogleCompleteRegistrationScreen extends ConsumerStatefulWidget {
  const GoogleCompleteRegistrationScreen({super.key});

  @override
  ConsumerState<GoogleCompleteRegistrationScreen> createState() => _GoogleCompleteRegistrationScreenState();
}

class _GoogleCompleteRegistrationScreenState extends ConsumerState<GoogleCompleteRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  // State
  SupplierType _selectedType = SupplierType.supplier;
  final _companyController = TextEditingController();
  final _phoneController = TextEditingController();

  String? _selectedGovernorate;
  String? _selectedCity;
  final List<String> _selectedSpecs = [];

  final Map<String, List<String>> _governorateCities = {
    'القاهرة': ['القاهرة الجديدة', 'مصر الجديدة', 'المعادي', 'وسط البلد', 'حلوان'],
    'الجيزة': ['الدقي', 'المهندسين', 'الهرم', '6 أكتوبر', 'الشيخ زايد'],
    'الإسكندرية': ['سموحة', 'المنتزه', 'سيدي بشر', 'الرمل', 'وسط الإسكندرية'],
    'الدقهلية': ['المنصورة', 'ميت غمر', 'السنبلاوين', 'دكرنس', 'طلخا'],
  };

  final List<String> _supplierSpecializations = [
    'أقمشة', 'خيوط', 'إكسسوارات', 'حشو', 'تغليف', 'طباعة', 'كيماويات', 'ماكينات', 'أكياس وكرتون', 'أزرار وسوست', 'مستلزمات مصانع'
  ];
  final List<String> _serviceSpecializations = [
    'طباعة', 'تطريز', 'صباغة', 'تصميم', 'قص', 'تغليف', 'خدمات أخرى'
  ];

  @override
  void dispose() {
    _companyController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _toggleSpecialization(String spec) {
    setState(() {
      if (_selectedSpecs.contains(spec)) {
        _selectedSpecs.remove(spec);
      } else {
        _selectedSpecs.add(spec);
      }
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedType != SupplierType.factoryUnit && _selectedSpecs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('من فضلك اختر تخصص واحد على الأقل.'), backgroundColor: AppColors.error),
      );
      return;
    }

    // Save details to registration flow controller
    ref.read(registrationControllerProvider.notifier).updateSupplierType(_selectedType);
    ref.read(registrationControllerProvider.notifier).updateBasicAccount(
          name: 'جوجل يوزر',
          email: 'google@naseeji.com',
          phone: _phoneController.text.trim(),
          password: 'GoogleUserPassword123!',
          governorate: _selectedGovernorate ?? '',
          city: _selectedCity ?? '',
        );

    ref.read(registrationControllerProvider.notifier).updateCompanyDetails(
          companyName: _companyController.text.trim(),
          commercialRegistry: '123456',
          taxNumber: '123456789',
          categories: _selectedSpecs,
        );

    // Call sendOtp and verify
    final success = await ref.read(registrationControllerProvider.notifier).sendOtp();
    if (mounted) {
      if (success) {
        context.push('/verify-otp');
      } else {
        final errorMsg = ref.read(registrationControllerProvider).errorMessage ?? 'حدث خطأ ما';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMsg), backgroundColor: AppColors.error),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(registrationControllerProvider);
    final theme = Theme.of(context);

    return Theme(
      data: AppTheme.darkTheme,
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('إكمال بيانات الحساب', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              centerTitle: true,
            ),
            body: SafeArea(
              child: LoadingOverlay(
                isLoading: state.isLoading,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'أهلاً بيك 👋',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'لقينا حساب Google بتاعك.\nكمّل البيانات دي علشان تقدر تستخدم نسيجي.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: theme.colorScheme.onSurfaceVariant,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Account Type Selectable
                        Text(
                          'نوع الحساب *',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
                          textAlign: TextAlign.right,
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          alignment: WrapAlignment.end,
                          children: SupplierType.values.map((type) {
                            final isSelected = _selectedType == type;
                            String label = '';
                            if (type == SupplierType.supplier) label = 'مورد خامات';
                            if (type == SupplierType.factoryUnit) label = 'مصنع';
                            if (type == SupplierType.customizer) label = 'مقدم خدمات';
                            return ChoiceChip(
                              label: Text(label),
                              selected: isSelected,
                              onSelected: (val) {
                                if (val) {
                                  setState(() {
                                    _selectedType = type;
                                    _selectedSpecs.clear();
                                  });
                                }
                              },
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 16),

                        CustomTextField(
                          controller: _companyController,
                          labelText: 'اسم الشركة *',
                          prefixIcon: Icons.business_outlined,
                          validator: (val) => val == null || val.trim().isEmpty ? 'من فضلك اكتب اسم الشركة.' : null,
                        ),
                        const SizedBox(height: 16),

                        CustomTextField(
                          controller: _phoneController,
                          labelText: 'رقم الهاتف *',
                          prefixText: '+20 ',
                          keyboardType: TextInputType.phone,
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) return 'اكتب رقم موبايل مصري صحيح.';
                            if (val.trim().length != 11 || !RegExp(r'^(010|011|012|015)[0-9]{8}$').hasMatch(val.trim())) {
                              return 'اكتب رقم موبايل مصري صحيح.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        DropdownButtonFormField<String>(
                          initialValue: _selectedGovernorate,
                          decoration: InputDecoration(
                            labelText: 'المحافظة *',
                            prefixIcon: const Icon(Icons.map_outlined),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          items: _governorateCities.keys.map((gov) => DropdownMenuItem(value: gov, child: Text(gov))).toList(),
                          onChanged: (val) {
                            setState(() {
                              _selectedGovernorate = val;
                              _selectedCity = null;
                            });
                          },
                          validator: (val) => val == null ? 'يرجى اختيار المحافظة' : null,
                        ),
                        const SizedBox(height: 16),

                        DropdownButtonFormField<String>(
                          initialValue: _selectedCity,
                          decoration: InputDecoration(
                            labelText: 'المدينة *',
                            prefixIcon: const Icon(Icons.location_city_outlined),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          items: _selectedGovernorate == null
                              ? []
                              : _governorateCities[_selectedGovernorate]!.map((city) => DropdownMenuItem(value: city, child: Text(city))).toList(),
                          onChanged: (val) {
                            setState(() {
                              _selectedCity = val;
                            });
                          },
                          validator: (val) => val == null ? 'يرجى اختيار المدينة' : null,
                        ),
                        const SizedBox(height: 24),

                        if (_selectedType == SupplierType.supplier) ...[
                          Text(
                            'التخصصات المتاحة *',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
                            textAlign: TextAlign.right,
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            alignment: WrapAlignment.end,
                            children: _supplierSpecializations.map((spec) {
                              final isSelected = _selectedSpecs.contains(spec);
                              return FilterChip(
                                label: Text(spec),
                                selected: isSelected,
                                onSelected: (_) => _toggleSpecialization(spec),
                              );
                            }).toList(),
                          ),
                        ] else if (_selectedType == SupplierType.customizer) ...[
                          Text(
                            'الخدمات المتاحة *',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
                            textAlign: TextAlign.right,
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            alignment: WrapAlignment.end,
                            children: _serviceSpecializations.map((spec) {
                              final isSelected = _selectedSpecs.contains(spec);
                              return FilterChip(
                                label: Text(spec),
                                selected: isSelected,
                                onSelected: (_) => _toggleSpecialization(spec),
                              );
                            }).toList(),
                          ),
                        ],

                        const SizedBox(height: 32),

                        PrimaryButton(
                          text: 'تأكيد وإنشاء الحساب',
                          onPressed: _submit,
                          suffixIcon: Icons.check_circle_outline,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}

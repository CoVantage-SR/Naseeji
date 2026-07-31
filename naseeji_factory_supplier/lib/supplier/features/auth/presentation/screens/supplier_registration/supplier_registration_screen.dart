import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_factory/core/theme/app_colors.dart';
import 'package:naseeji_factory/core/theme/app_theme.dart';
import 'package:naseeji_factory/core/widgets/general_widgets.dart';
import 'package:naseeji_factory/authentication/domain/entities/supplier_registration_data.dart';
import 'package:naseeji_factory/authentication/presentation/controllers/registration_controller.dart';

class SupplierRegistrationScreen extends ConsumerStatefulWidget {
  const SupplierRegistrationScreen({super.key});

  @override
  ConsumerState<SupplierRegistrationScreen> createState() => _SupplierRegistrationScreenState();
}

class _SupplierRegistrationScreenState extends ConsumerState<SupplierRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  // Specializations
  final List<String> _supplierSpecializations = [
    'أقمشة', 'خيوط', 'إكسسوارات', 'حشو', 'تغليف', 'طباعة', 'كيماويات', 'ماكينات', 'أكياس وكرتون', 'أزرار وسوست', 'مستلزمات مصانع'
  ];
  final List<String> _serviceSpecializations = [
    'طباعة', 'تطريز', 'صباغة', 'تصميم', 'قص', 'تغليف', 'خدمات أخرى'
  ];

  final List<String> _selectedSpecs = [];

  // Controllers for additional fields
  final _factoryTypeController = TextEditingController();
  final _employeeCountController = TextEditingController();
  final _productionCapacityController = TextEditingController();
  final _productTypesController = TextEditingController();

  final _bioController = TextEditingController();
  final _establishedYearController = TextEditingController();
  final _minOrderController = TextEditingController();
  final _countriesController = TextEditingController();
  final _websiteController = TextEditingController();

  @override
  void dispose() {
    _factoryTypeController.dispose();
    _employeeCountController.dispose();
    _productionCapacityController.dispose();
    _productTypesController.dispose();
    _bioController.dispose();
    _establishedYearController.dispose();
    _minOrderController.dispose();
    _countriesController.dispose();
    _websiteController.dispose();
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

  void _submit() {
    final registrationState = ref.read(registrationControllerProvider);
    final selectedType = registrationState.data.supplierType;

    // Validation
    if (selectedType != SupplierType.factoryUnit && _selectedSpecs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('من فضلك اختر تخصص واحد على الأقل.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    // Save step 4 data to provider
    ref.read(registrationControllerProvider.notifier).updateBusinessDetails(
          specializations: _selectedSpecs,
          factoryType: _factoryTypeController.text.trim(),
          employeeCount: _employeeCountController.text.trim(),
          productionCapacity: _productionCapacityController.text.trim(),
          productTypes: _productTypesController.text.trim(),
          companyBio: _bioController.text.trim(),
          establishedYear: _establishedYearController.text.trim(),
          minOrderValue: _minOrderController.text.trim(),
          supplyCountries: _countriesController.text.trim(),
          website: _websiteController.text.trim(),
        );

    context.push('/register-review');
  }

  @override
  Widget build(BuildContext context) {
    final registrationState = ref.watch(registrationControllerProvider);
    final selectedType = registrationState.data.supplierType ?? SupplierType.supplier;
    final theme = Theme.of(context);

    return Theme(
      data: AppTheme.darkTheme,
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'التخصصات والبيانات التجارية',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              centerTitle: true,
              actions: [
                TextButton(
                  onPressed: () => context.go('/login'),
                  child: Text(
                    'تسجيل الدخول',
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Step Progress Indicator
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox.shrink(),
                          Text(
                            'الخطوة 4 من 5',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: TweenAnimationBuilder<double>(
                          tween: Tween<double>(begin: 0.0, end: 0.8),
                          duration: const Duration(milliseconds: 800),
                          curve: Curves.easeInOut,
                          builder: (ctx, value, child) => LinearProgressIndicator(
                            value: value,
                            minHeight: 6,
                            backgroundColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                            valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      Text(
                        'التخصصات والبيانات التجارية',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'اختار التخصصات اللي شركتك بتشتغل فيها.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Conditional view based on Account Type
                      if (selectedType == SupplierType.supplier) ...[
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
                      ] else if (selectedType == SupplierType.customizer) ...[
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
                      ] else if (selectedType == SupplierType.factoryUnit) ...[
                        CustomTextField(
                          controller: _factoryTypeController,
                          labelText: 'نوع المصنع *',
                          prefixIcon: Icons.factory_outlined,
                          validator: (val) => val == null || val.trim().isEmpty ? 'حقل مطلوب' : null,
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: _employeeCountController,
                          labelText: 'عدد العمال *',
                          prefixIcon: Icons.people_outline,
                          keyboardType: TextInputType.number,
                          validator: (val) => val == null || val.trim().isEmpty ? 'حقل مطلوب' : null,
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: _productionCapacityController,
                          labelText: 'الطاقة الإنتاجية *',
                          prefixIcon: Icons.bolt_outlined,
                          validator: (val) => val == null || val.trim().isEmpty ? 'حقل مطلوب' : null,
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: _productTypesController,
                          labelText: 'أنواع المنتجات *',
                          prefixIcon: Icons.category_outlined,
                          validator: (val) => val == null || val.trim().isEmpty ? 'حقل مطلوب' : null,
                        ),
                      ],

                      const SizedBox(height: 24),
                      const Divider(),
                      const SizedBox(height: 16),

                      Text(
                        'بيانات المؤسسة الإضافية',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
                        textAlign: TextAlign.right,
                      ),
                      const SizedBox(height: 16),

                      CustomTextField(
                        controller: _bioController,
                        labelText: 'نبذة عن الشركة *',
                        prefixIcon: Icons.description_outlined,
                        maxLines: 3,
                        validator: (val) => val == null || val.trim().isEmpty ? 'حقل مطلوب' : null,
                      ),
                      const SizedBox(height: 16),

                      CustomTextField(
                        controller: _establishedYearController,
                        labelText: 'سنة التأسيس *',
                        prefixIcon: Icons.calendar_today_outlined,
                        keyboardType: TextInputType.number,
                        validator: (val) => val == null || val.trim().isEmpty ? 'حقل مطلوب' : null,
                      ),
                      const SizedBox(height: 16),

                      CustomTextField(
                        controller: _minOrderController,
                        labelText: 'الحد الأدنى للطلب *',
                        prefixIcon: Icons.shopping_basket_outlined,
                        keyboardType: TextInputType.number,
                        validator: (val) => val == null || val.trim().isEmpty ? 'حقل مطلوب' : null,
                      ),
                      const SizedBox(height: 16),

                      CustomTextField(
                        controller: _countriesController,
                        labelText: 'الدول التي يتم التوريد لها (اختياري)',
                        prefixIcon: Icons.public_outlined,
                      ),
                      const SizedBox(height: 16),

                      CustomTextField(
                        controller: _websiteController,
                        labelText: 'موقع إلكتروني (اختياري)',
                        prefixIcon: Icons.language_outlined,
                        keyboardType: TextInputType.url,
                      ),

                      const SizedBox(height: 32),

                      PrimaryButton(
                        text: 'متابعة',
                        onPressed: _submit,
                        suffixIcon: Icons.arrow_forward_rounded,
                      ),
                    ],
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




import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/session/session_provider.dart';
import '../../../shared/enums/user_role.dart';
import '../widgets/register_header.dart';

class BasicProfileScreen extends ConsumerStatefulWidget {
  final UserRole initialRole;

  const BasicProfileScreen({
    super.key,
    required this.initialRole,
  });

  @override
  ConsumerState<BasicProfileScreen> createState() => _BasicProfileScreenState();
}

class _BasicProfileScreenState extends ConsumerState<BasicProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _entityNameController;
  late final TextEditingController _ownerNameController;
  late final TextEditingController _cityController;
  late final TextEditingController _addressController;

  String? _selectedGovernorate;
  String? _selectedCategory;
  File? _logoFile;
  bool _isLoading = false;
  String _currentLanguage = 'العربية';

  final List<String> _governorates = [
    'القاهرة',
    'الجيزة',
    'الإسكندرية',
    'الغربية (المحلة الكبرى)',
    'الشرقية',
    'الدقهلية',
    'القليوبية',
    'المنوفية',
    'البحيرة',
    'كفر الشيخ',
    'الفيوم',
    'بني سويف',
    'المنيا',
    'أسيوط',
    'سوهاج',
    'قنا',
    'الأقصر',
    'أسوان',
    'بورسعيد',
    'الإسماعيلية',
    'السويس',
  ];

  List<String> get _categories {
    if (widget.initialRole == UserRole.factory) {
      return [
        'مصنع غزل ونسيج',
        'مصنع ملابس جاهزة',
        'مصنع صباغة وتجهيز',
        'مصنع تريكو وطباعة',
        'مصنع مفروشات ومنسوجات منزلية',
      ];
    } else {
      return [
        'مورد خيوط وغزول',
        'مورد أقمشة ومستلزمات',
        'مورد صبغات ومواد كيميائية',
        'مورد ماكينات وقطع غيار',
        'مورد اكسسوارات وتعبئة',
      ];
    }
  }

  @override
  void initState() {
    super.initState();
    _entityNameController = TextEditingController();
    _ownerNameController = TextEditingController();
    _cityController = TextEditingController();
    _addressController = TextEditingController();
  }

  @override
  void dispose() {
    _entityNameController.dispose();
    _ownerNameController.dispose();
    _cityController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _pickLogo() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (image != null) {
      setState(() {
        _logoFile = File(image.path);
      });
    }
  }

  Future<void> _handleSubmit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (_selectedGovernorate == null || _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى اختيار المحافظة والفئة المطلوبة'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    FocusScope.of(context).unfocus();

    await ref.read(sessionNotifierProvider.notifier).saveBasicProfile(
          entityName: _entityNameController.text.trim(),
          ownerName: _ownerNameController.text.trim(),
          governorate: _selectedGovernorate!,
          city: _cityController.text.trim(),
          address: _addressController.text.trim(),
          category: _selectedCategory!,
          logoUrl: _logoFile?.path,
          role: widget.initialRole,
        );

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      if (widget.initialRole == UserRole.supplier) {
        context.go('/supplier/dashboard');
      } else {
        context.go('/factory/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final isFactory = widget.initialRole == UserRole.factory;

    return Scaffold(
      backgroundColor: isDark ? colorScheme.surface : const Color(0xFFFAFCFF),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: AbsorbPointer(
            absorbing: _isLoading,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  RegisterHeader(
                    onBack: () => Navigator.of(context).pop(),
                    currentLanguage: _currentLanguage,
                    onLanguageChanged: (lang) {
                      setState(() {
                        _currentLanguage = lang;
                      });
                    },
                  ),

                  AppSpacing.hSM,

                  Text(
                    isFactory ? 'البيانات الأساسية للمصنع' : 'البيانات الأساسية للمورد',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDark ? colorScheme.onSurface : const Color(0xFF1E293B),
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'أدخل البيانات الأساسية للبدء فورا في استخدام المنصة',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isDark ? colorScheme.onSurfaceVariant : const Color(0xFF64748B),
                      fontSize: 13,
                    ),
                  ),

                  AppSpacing.hLG,

                  // Logo Picker (Optional)
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 46,
                          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                          backgroundImage: _logoFile != null ? FileImage(_logoFile!) : null,
                          child: _logoFile == null
                              ? const Icon(Icons.business_rounded, size: 44, color: AppColors.primary)
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: InkWell(
                            onTap: _pickLogo,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.camera_alt_rounded, size: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'شعار الشركة (اختياري)',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                  ),

                  AppSpacing.hLG,

                  // Entity Name Field
                  TextFormField(
                    controller: _entityNameController,
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'هذا الحقل مطلوب' : null,
                    decoration: InputDecoration(
                      labelText: isFactory ? 'اسم المصنع *' : 'اسم المورد / الشركة *',
                      prefixIcon: const Icon(Icons.factory_outlined),
                      filled: true,
                      fillColor: isDark ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.3) : Colors.white,
                      border: OutlineInputBorder(borderRadius: AppRadius.rSM),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Owner Name Field
                  TextFormField(
                    controller: _ownerNameController,
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'هذا الحقل مطلوب' : null,
                    decoration: InputDecoration(
                      labelText: 'اسم المالك / المدير *',
                      prefixIcon: const Icon(Icons.person_outline_rounded),
                      filled: true,
                      fillColor: isDark ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.3) : Colors.white,
                      border: OutlineInputBorder(borderRadius: AppRadius.rSM),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Governorate Dropdown
                  DropdownButtonFormField<String>(
                    value: _selectedGovernorate,
                    validator: (v) => v == null ? 'يرجى اختيار المحافظة' : null,
                    items: _governorates
                        .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                        .toList(),
                    onChanged: (val) => setState(() => _selectedGovernorate = val),
                    decoration: InputDecoration(
                      labelText: 'المحافظة *',
                      prefixIcon: const Icon(Icons.map_outlined),
                      filled: true,
                      fillColor: isDark ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.3) : Colors.white,
                      border: OutlineInputBorder(borderRadius: AppRadius.rSM),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // City Field
                  TextFormField(
                    controller: _cityController,
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'هذا الحقل مطلوب' : null,
                    decoration: InputDecoration(
                      labelText: 'المدينة / المنطقة *',
                      prefixIcon: const Icon(Icons.location_city_outlined),
                      filled: true,
                      fillColor: isDark ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.3) : Colors.white,
                      border: OutlineInputBorder(borderRadius: AppRadius.rSM),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Address Field
                  TextFormField(
                    controller: _addressController,
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'هذا الحقل مطلوب' : null,
                    decoration: InputDecoration(
                      labelText: 'العنوان التفصيلي *',
                      prefixIcon: const Icon(Icons.location_on_outlined),
                      filled: true,
                      fillColor: isDark ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.3) : Colors.white,
                      border: OutlineInputBorder(borderRadius: AppRadius.rSM),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Category Dropdown
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    validator: (v) => v == null ? 'يرجى اختيار النشاط' : null,
                    items: _categories
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (val) => setState(() => _selectedCategory = val),
                    decoration: InputDecoration(
                      labelText: isFactory ? 'فئة / نشاط المصنع *' : 'فئة / نشاط المورد *',
                      prefixIcon: const Icon(Icons.category_outlined),
                      filled: true,
                      fillColor: isDark ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.3) : Colors.white,
                      border: OutlineInputBorder(borderRadius: AppRadius.rSM),
                    ),
                  ),

                  AppSpacing.hXL,

                  // Submit Button
                  SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _handleSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        textStyle: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('إنشاء الحساب والدخول'),
                    ),
                  ),

                  AppSpacing.hLG,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

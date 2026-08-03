import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../presentation/providers/auth_providers.dart';
import '../../../../core/widgets/general_widgets.dart';
import '../../../../shared/enums/user_role.dart';
import '../providers/complete_profile_provider.dart';
import '../widgets/address_field.dart';
import '../widgets/city_dropdown.dart';
import '../widgets/commercial_register_field.dart';
import '../widgets/company_name_field.dart';
import '../widgets/company_type_dropdown.dart';
import '../widgets/continue_button.dart';
import '../widgets/governorate_dropdown.dart';
import '../widgets/logo_picker.dart';
import '../widgets/progress_indicator.dart';
import '../widgets/section_title.dart';
import '../widgets/tax_number_field.dart';
import '../widgets/textile_category_dropdown.dart';

class CompleteProfileScreen extends ConsumerStatefulWidget {
  final UserRole? initialRole;

  const CompleteProfileScreen({
    super.key,
    this.initialRole,
  });

  @override
  ConsumerState<CompleteProfileScreen> createState() =>
      _CompleteProfileScreenState();
}

class _CompleteProfileScreenState
    extends ConsumerState<CompleteProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _cityController;
  late final TextEditingController _addressController;
  late final TextEditingController _crController;
  late final TextEditingController _taxController;

  @override
  void initState() {
    super.initState();
    final authUser = ref.read(authControllerProvider).user;
    _nameController = TextEditingController(text: authUser?.name ?? '');
    _emailController = TextEditingController(text: authUser?.email ?? '');
    _cityController = TextEditingController();
    _addressController = TextEditingController();
    _crController = TextEditingController();
    _taxController = TextEditingController();

    if (widget.initialRole != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(completeProfileControllerProvider.notifier)
            .setRole(widget.initialRole!);
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _cityController.dispose();
    _addressController.dispose();
    _crController.dispose();
    _taxController.dispose();
    super.dispose();
  }

  Future<void> _handleDetectLocation() async {
    final controller = ref.read(completeProfileControllerProvider.notifier);
    final success = await controller.detectLocation();
    if (success && mounted) {
      final state = ref.read(completeProfileControllerProvider);
      if (state.selectedCity != null) {
        _cityController.text = state.selectedCity!;
      }
      if (state.address.isNotEmpty) {
        _addressController.text = state.address;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم تحديد موقع المنشأة تلقائياً بواسطة الـ GPS 📍'),
          backgroundColor: Colors.teal,
        ),
      );
    }
  }

  Future<void> _handleSubmit() async {
    FocusScope.of(context).unfocus();
    final controller = ref.read(completeProfileControllerProvider.notifier);
    final state = ref.read(completeProfileControllerProvider);

    final success = await controller.submitProfile();

    if (success && mounted) {
      context.push('/auth/terms-acceptance', extra: state.selectedRole);
    } else if (mounted) {
      final err = ref.read(completeProfileControllerProvider).errorMessage;
      if (err != null && err.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(err),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final state = ref.watch(completeProfileControllerProvider);
    final controller = ref.read(completeProfileControllerProvider.notifier);

    return Scaffold(
      backgroundColor: isDark ? colorScheme.surface : const Color(0xFFFAFCFF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: colorScheme.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.language_rounded, size: 18),
            label: const Text('العربية'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: LoadingOverlay(
        isLoading: state.isLoading,
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const CompleteProfileProgressIndicator(currentStep: 3),
                const SizedBox(height: 24),
                LogoPicker(
                  selectedLogo: state.selectedLogo,
                  logoUrl: state.logoUrl,
                  onPickImage: controller.pickLogo,
                  onDeleteImage: controller.deleteLogo,
                ),
                const SizedBox(height: 20),
                Text(
                  state.selectedRole == UserRole.factory
                      ? 'استكمال بيانات المصنع'
                      : 'استكمال بيانات المورد',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  state.selectedRole == UserRole.factory
                      ? 'أكمل بيانات مصنعك للبدء في تصفح وطلب خامات النسيج'
                      : 'أكمل بيانات شركتك الموردة للبدء في عرض وعرض منتجاتك للمصانع',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 28),
                const SectionTitle(
                  title: 'نوع الحساب والتخصص',
                  icon: Icons.business_center_outlined,
                ),
                const SizedBox(height: 12),
                CompanyTypeDropdown(
                  selectedRole: state.selectedRole,
                  onRoleChanged: controller.setRole,
                ),
                const SizedBox(height: 16),
                CompanyNameField(
                  controller: _nameController,
                  errorText: state.validationErrors['name'],
                  onChanged: controller.setCompanyName,
                ),
                if (_emailController.text.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    'البريد الإلكتروني الحساب *',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _emailController,
                    readOnly: true,
                    enabled: false,
                    textDirection: TextDirection.ltr,
                    decoration: InputDecoration(
                      hintText: 'email@domain.com',
                      prefixIcon: Icon(
                        Icons.lock_outline_rounded,
                        color: colorScheme.outline,
                      ),
                      filled: true,
                      fillColor: isDark
                          ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.3)
                          : const Color(0xFFF8FAFC),
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                TextileCategoryDropdown(
                  role: state.selectedRole,
                  selectedCategory: state.selectedCategory,
                  errorText: state.validationErrors['category'],
                  onChanged: (val) {
                    if (val != null) controller.setCategory(val);
                  },
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SectionTitle(
                      title: 'الموقع والعنوان',
                      icon: Icons.location_on_outlined,
                    ),
                    TextButton.icon(
                      onPressed: _handleDetectLocation,
                      icon: const Icon(Icons.my_location_rounded, size: 16),
                      label: const Text('تحديد موفعي (GPS)'),
                      style: TextButton.styleFrom(
                        foregroundColor: colorScheme.primary,
                        textStyle: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                GovernorateDropdown(
                  selectedGovernorate: state.selectedGovernorate,
                  errorText: state.validationErrors['governorate'],
                  onChanged: (val) {
                    if (val != null) controller.setGovernorate(val);
                  },
                ),
                const SizedBox(height: 16),
                CityField(
                  controller: _cityController,
                  errorText: state.validationErrors['city'],
                  onChanged: controller.setCity,
                ),
                const SizedBox(height: 16),
                AddressField(
                  controller: _addressController,
                  errorText: state.validationErrors['address'],
                  onChanged: controller.setAddress,
                ),
                const SizedBox(height: 24),
                const SectionTitle(
                  title: 'البيانات القانونية والضريبية',
                  icon: Icons.verified_user_outlined,
                ),
                const SizedBox(height: 12),
                CommercialRegisterField(
                  controller: _crController,
                  errorText: state.validationErrors['commercialRegister'],
                  onChanged: controller.setCommercialRegister,
                ),
                const SizedBox(height: 16),
                TaxNumberField(
                  controller: _taxController,
                  errorText: state.validationErrors['taxNumber'],
                  onChanged: controller.setTaxNumber,
                ),
                const SizedBox(height: 32),
                ContinueButton(
                  isLoading: state.isLoading,
                  onPressed: _handleSubmit,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

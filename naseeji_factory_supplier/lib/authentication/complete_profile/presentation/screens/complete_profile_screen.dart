import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
  late final TextEditingController _addressController;
  late final TextEditingController _crController;
  late final TextEditingController _taxController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
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
    _addressController.dispose();
    _crController.dispose();
    _taxController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    FocusScope.of(context).unfocus();
    final controller = ref.read(completeProfileControllerProvider.notifier);
    final state = ref.read(completeProfileControllerProvider);

    final success = await controller.submitProfile();

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم استكمال بيانات الحساب بنجاح!'),
          backgroundColor: Colors.green,
        ),
      );

      if (state.selectedRole == UserRole.supplier) {
        context.go('/supplier/dashboard');
      } else {
        context.go('/factory/home');
      }
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
                  'استكمال بيانات الحساب',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'أكمل بيانات شركتك للبدء في استخدام منصة نسيجي',
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
                const SectionTitle(
                  title: 'الموقع والعنوان',
                  icon: Icons.location_on_outlined,
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
                CityDropdown(
                  selectedGovernorate: state.selectedGovernorate,
                  selectedCity: state.selectedCity,
                  errorText: state.validationErrors['city'],
                  onChanged: (val) {
                    if (val != null) controller.setCity(val);
                  },
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

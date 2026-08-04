import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/session/session_provider.dart';
import '../../../presentation/providers/auth_providers.dart';
import '../../../../core/widgets/general_widgets.dart';
import '../../../../shared/enums/user_role.dart';
import '../providers/complete_profile_provider.dart';
import '../widgets/address_field.dart';
import '../widgets/city_dropdown.dart';
import '../widgets/company_name_field.dart';
import '../widgets/company_type_dropdown.dart';
import '../widgets/company_verification_form.dart';
import '../widgets/continue_button.dart';
import '../widgets/governorate_dropdown.dart';
import '../widgets/identity_verification_form.dart';
import '../widgets/logo_picker.dart';
import '../widgets/section_title.dart';
import '../widgets/textile_category_dropdown.dart';
import '../widgets/verification_method_selector.dart';
import '../widgets/verification_progress_card.dart';

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
  late final TextEditingController _nameController = TextEditingController();
  late final TextEditingController _emailController = TextEditingController();
  late final TextEditingController _cityController = TextEditingController();
  late final TextEditingController _addressController = TextEditingController();
  late final TextEditingController _crController = TextEditingController();
  late final TextEditingController _taxController = TextEditingController();
  late final TextEditingController _businessNameController = TextEditingController();
  late final TextEditingController _businessAddressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final authUser = ref.read(authControllerProvider).user;
    final session = ref.read(sessionNotifierProvider);

    if (authUser != null) {
      if (authUser.name.isNotEmpty) {
        _nameController.text = authUser.name;
        _businessNameController.text = authUser.name;
      }
      if (authUser.email.isNotEmpty) {
        _emailController.text = authUser.email;
      }
    } else if (session.entityName != null) {
      _nameController.text = session.entityName!;
      _businessNameController.text = session.entityName!;
    }

    if (session.address != null) {
      _addressController.text = session.address!;
      _businessAddressController.text = session.address!;
    }

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
    _businessNameController.dispose();
    _businessAddressController.dispose();
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
        _businessAddressController.text = state.address;
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
      final isCompany = state.verificationMethod == 'company';
      final hasDocs = isCompany
          ? (state.crDocumentFile != null || _crController.text.isNotEmpty)
          : (state.idFrontFile != null || state.selfieFile != null);

      final pct = hasDocs ? 100 : 80;
      final vStatus = hasDocs ? 'pending' : 'unverified';
      final vLevel = hasDocs ? (isCompany ? 'business_verified' : 'identity_verified') : 'basic';

      final sessionNotifier = ref.read(sessionNotifierProvider.notifier);
      await sessionNotifier.saveBasicProfile(
        entityName: _nameController.text.trim().isNotEmpty ? _nameController.text.trim() : _businessNameController.text.trim(),
        ownerName: _nameController.text.trim(),
        governorate: state.selectedGovernorate ?? 'القاهرة',
        city: state.selectedCity ?? 'القاهرة',
        address: _addressController.text.trim(),
        category: state.selectedCategory ?? state.businessType ?? 'عام',
        logoUrl: state.logoUrl,
        role: state.selectedRole,
      );
      await sessionNotifier.updateCompletionPercentage(pct);
      await sessionNotifier.updateVerificationDetails(
        status: vStatus,
        level: vLevel,
        method: state.verificationMethod,
        businessType: state.businessType,
        idFrontUrl: state.idFrontFile?.path,
        idBackUrl: state.idBackFile?.path,
        selfieUrl: state.selfieFile?.path,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(hasDocs
                ? 'تم حفظ بيانات الملف والمستندات بنجاح! طلبك قيد المراجعة 🟡'
                : 'تم استكمال ملف الحساب بنجاح! يمكنك توثيق الحساب لاحقاً للحصول على شارة التوثيق ⭐️'),
            backgroundColor: Colors.teal,
          ),
        );

        final role = state.selectedRole;
        if (role == UserRole.supplier) {
          context.go('/supplier/dashboard');
        } else {
          context.go('/factory/home');
        }
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
                // Modular Progress Breakdown Card
                VerificationProgressCard(
                  completionPercentage: state.completionPercentage,
                  hasBasicInfo: state.companyName.isNotEmpty || state.businessName.isNotEmpty,
                  hasPhoneVerified: true,
                  hasLogo: state.selectedLogo != null || (state.logoUrl != null && state.logoUrl!.isNotEmpty),
                  hasAddress: state.address.isNotEmpty || state.businessAddress.isNotEmpty,
                  hasCategory: state.selectedCategory != null || state.businessType != null,
                  hasDocuments: (state.crDocumentFile != null && state.taxDocumentFile != null) ||
                      (state.idFrontFile != null && state.idBackFile != null && state.selfieFile != null),
                  hasWebsite: state.website != null && state.website!.isNotEmpty,
                ),

                const SizedBox(height: 20),

                LogoPicker(
                  selectedLogo: state.selectedLogo,
                  logoUrl: state.logoUrl,
                  onPickImage: controller.pickLogo,
                  onDeleteImage: controller.deleteLogo,
                ),

                const SizedBox(height: 20),

                Text(
                  state.selectedRole == UserRole.factory
                      ? 'استكمال بيانات وملف المصنع'
                      : 'استكمال بيانات وملف المورد',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  state.selectedRole == UserRole.factory
                      ? 'أكمل بيانات وتوثيق مصنعك للبدء في تصفح وطلب خامات النسيج'
                      : 'أكمل بيانات وتوثيق نشاطك المورد للبدء في تقديم العروض للمصانع',
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
                  onChanged: (val) {
                    controller.setCompanyName(val);
                    if (_businessNameController.text.isEmpty) {
                      _businessNameController.text = val;
                      controller.setBusinessName(val);
                    }
                  },
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
                    const Expanded(
                      child: SectionTitle(
                        title: 'الموقع والعنوان',
                        icon: Icons.location_on_outlined,
                      ),
                    ),
                    const SizedBox(width: 8),
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
                  onChanged: (val) {
                    controller.setAddress(val);
                    if (_businessAddressController.text.isEmpty) {
                      _businessAddressController.text = val;
                      controller.setBusinessAddress(val);
                    }
                  },
                ),

                const SizedBox(height: 28),

                // NEW SECTION: Flexible Verification System Selector (Card 1 vs Card 2)
                VerificationMethodSelector(
                  selectedMethod: state.verificationMethod,
                  onMethodChanged: controller.setVerificationMethod,
                ),

                const SizedBox(height: 20),

                // FORM CONTENT ACCORDING TO SELECTION
                if (state.verificationMethod == 'company')
                  CompanyVerificationForm(
                    crController: _crController,
                    taxController: _taxController,
                    crDocumentFile: state.crDocumentFile,
                    taxDocumentFile: state.taxDocumentFile,
                    validationErrors: state.validationErrors,
                    onCrChanged: controller.setCommercialRegister,
                    onTaxChanged: controller.setTaxNumber,
                    onPickCrDocument: controller.setCrDocument,
                    onPickTaxDocument: controller.setTaxDocument,
                    onDeleteCrDocument: () => controller.deleteDocument('crDocument'),
                    onDeleteTaxDocument: () => controller.deleteDocument('taxDocument'),
                  )
                else
                  IdentityVerificationForm(
                    businessNameController: _businessNameController,
                    businessAddressController: _businessAddressController,
                    selectedBusinessType: state.businessType,
                    idFrontFile: state.idFrontFile,
                    idBackFile: state.idBackFile,
                    selfieFile: state.selfieFile,
                    validationErrors: state.validationErrors,
                    onBusinessNameChanged: controller.setBusinessName,
                    onBusinessTypeChanged: controller.setBusinessType,
                    onBusinessAddressChanged: controller.setBusinessAddress,
                    onPickIdFront: controller.setIdFront,
                    onPickIdBack: controller.setIdBack,
                    onPickSelfie: controller.setSelfie,
                    onDeleteIdFront: () => controller.deleteDocument('idFront'),
                    onDeleteIdBack: () => controller.deleteDocument('idBack'),
                    onDeleteSelfie: () => controller.deleteDocument('selfieWithId'),
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

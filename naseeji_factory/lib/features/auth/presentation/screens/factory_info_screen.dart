import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_spacing.dart';
import '../providers/auth_provider.dart';
import '../providers/registration_provider.dart';
import '../widgets/factory_info_widgets.dart';
import '../widgets/register_widgets.dart'; // for PhoneFieldWidget & EmailFieldWidget
import '../widgets/reusable_registration_widgets.dart' hide BackButton;

class FactoryInfoScreen extends ConsumerStatefulWidget {
  const FactoryInfoScreen({super.key});

  @override
  ConsumerState<FactoryInfoScreen> createState() => _FactoryInfoScreenState();
}

class _FactoryInfoScreenState extends ConsumerState<FactoryInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ownerController = TextEditingController();
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  final _cityController = TextEditingController();
  final _descController = TextEditingController();
  String? _selectedGov;
  String? _selectedRange;

  @override
  void initState() {
    super.initState();
    final regState = ref.read(registrationProvider);
    _phoneController = TextEditingController(text: regState.phone);
    _emailController = TextEditingController(text: regState.email);
    _selectedRange = regState.employeesRange.isEmpty ? null : regState.employeesRange;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ownerController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _cityController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _onContinue() async {
    if (_formKey.currentState!.validate()) {
      // Save data
      ref.read(registrationProvider.notifier).updateBasicInfo(
            factoryName: _nameController.text.trim(),
            ownerName: _ownerController.text.trim(),
            phone: _phoneController.text.trim(),
            email: _emailController.text.trim(),
            governorate: _selectedGov ?? '',
            city: _cityController.text.trim(),
            employeesRange: _selectedRange ?? '',
            description: _descController.text.trim(),
          );

      // Submit registration mock state
      await ref.read(registrationProvider.notifier).submitRegistration();

      // Authenticate the user successfully
      ref.read(authProvider.notifier).login(_phoneController.text.trim(), 'dummy');

      // Navigate directly to Home
      if (mounted) {
        context.go('/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final regState = ref.watch(registrationProvider);
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const RegistrationProgress(currentStep: 4, totalSteps: 4),
                  isKeyboardOpen ? AppSpacing.hSM : AppSpacing.hLG,
                  FactoryInfoHeaderWidget(compact: isKeyboardOpen),
                  isKeyboardOpen ? AppSpacing.hMD : AppSpacing.hXL,
                  FactoryNameWidget(controller: _nameController),
                  AppSpacing.hMD,
                  OwnerNameWidget(controller: _ownerController),
                  AppSpacing.hMD,
                  PhoneFieldWidget(controller: _phoneController),
                  AppSpacing.hMD,
                  EmailFieldWidget(controller: _emailController),
                  AppSpacing.hMD,
                  GovernorateWidget(
                    value: _selectedGov,
                    onChanged: (val) {
                      setState(() {
                        _selectedGov = val;
                      });
                    },
                  ),
                  AppSpacing.hMD,
                  CityWidget(controller: _cityController),
                  AppSpacing.hMD,
                  EmployeesWidget(
                    value: _selectedRange,
                    onChanged: (val) {
                      setState(() {
                        _selectedRange = val;
                      });
                    },
                  ),
                  AppSpacing.hMD,
                  DescriptionWidget(controller: _descController),
                  isKeyboardOpen ? AppSpacing.hLG : AppSpacing.hXXL,
                  ContinueButton(
                    text: 'إرسال وإنشاء الحساب',
                    isLoading: regState.isLoading,
                    onPressed: _onContinue,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

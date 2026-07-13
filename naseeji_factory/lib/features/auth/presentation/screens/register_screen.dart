import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../../../../core/widgets/app_text_fields.dart';
import '../providers/registration_provider.dart';
import '../widgets/register_widgets.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _termsAccepted = false;
  String _passwordText = '';

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(() {
      setState(() {
        _passwordText = _passwordController.text;
      });
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onContinue() {
    if (_formKey.currentState!.validate() && _termsAccepted) {
      // Save data to registration state provider
      ref.read(registrationProvider.notifier).updateBasicInfo(
            factoryName: '',
            ownerName: '',
            phone: _phoneController.text.trim(),
            email: _emailController.text.trim(),
            governorate: '',
            city: '',
            employeesRange: '1-10',
            description: '',
          );
      
      // Navigate to Step 2: Factory Type Selection
      context.push('/factory-type');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_rounded),
          onPressed: () => context.go('/login'),
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
                  const StepIndicatorWidget(currentStep: 1, totalSteps: 3),
                  isKeyboardOpen ? AppSpacing.hSM : AppSpacing.hLG,
                  RegisterHeaderWidget(compact: isKeyboardOpen),
                  isKeyboardOpen ? AppSpacing.hMD : AppSpacing.hXL,
                  PhoneFieldWidget(controller: _phoneController),
                  AppSpacing.hMD,
                  EmailFieldWidget(controller: _emailController),
                  AppSpacing.hMD,
                  // Stateful Password input for live strength calculation
                  AppPasswordField(
                    labelText: 'كلمة المرور',
                    controller: _passwordController,
                  ),
                  AppSpacing.hSM,
                  PasswordStrengthWidget(password: _passwordText),
                  AppSpacing.hMD,
                  ConfirmPasswordFieldWidget(
                    controller: _confirmPasswordController,
                    passwordController: _passwordController,
                  ),
                  AppSpacing.hMD,
                  TermsCheckboxWidget(
                    onChanged: (val) {
                      setState(() {
                        _termsAccepted = val;
                      });
                    },
                  ),
                  AppSpacing.hXL,
                  AppButton.primary(
                    text: 'متابعة',
                    onPressed: _termsAccepted ? _onContinue : null,
                  ),
                  AppSpacing.hLG,
                  const AlreadyHaveAccountWidget(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

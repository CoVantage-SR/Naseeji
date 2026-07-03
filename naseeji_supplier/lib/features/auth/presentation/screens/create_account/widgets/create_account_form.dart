import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import 'package:naseeji_supplier/core/widgets/general_widgets.dart';
import 'package:naseeji_supplier/features/auth/presentation/controllers/registration_controller.dart';

class CreateAccountForm extends ConsumerStatefulWidget {
  const CreateAccountForm({super.key});

  @override
  ConsumerState<CreateAccountForm> createState() => _CreateAccountFormState();
}

class _CreateAccountFormState extends ConsumerState<CreateAccountForm> {
  final _formKey = GlobalKey<FormState>();
  final _companyController = TextEditingController();
  final _managerController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cityController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  String? _selectedCountry;
  bool _acceptTerms = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _companyController.dispose();
    _managerController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى الموافقة على الشروط والأحكام للمتابعة'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('كلمتا المرور غير متطابقتين'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // Update details in state
    ref.read(registrationControllerProvider.notifier).updateBasicAccount(
          name: _managerController.text.trim(),
          email: _emailController.text.trim(),
          phone: _phoneController.text.trim(),
          password: _passwordController.text,
        );

    // Call Send OTP
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
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Row: Company Name & Manager Name
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  controller: _companyController,
                  labelText: 'اسم الشركة',
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'مطلوب';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomTextField(
                  controller: _managerController,
                  labelText: 'اسم المسؤول',
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'مطلوب';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Row: Email & Phone
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  controller: _emailController,
                  labelText: 'البريد الإلكتروني',
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'مطلوب';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomTextField(
                  controller: _phoneController,
                  labelText: 'رقم الهاتف',
                  keyboardType: TextInputType.phone,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'مطلوب';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Row: Country & City
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedCountry,
                  decoration: const InputDecoration(
                    labelText: 'الدولة',
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'sa', child: Text('المملكة العربية السعودية')),
                    DropdownMenuItem(value: 'ae', child: Text('الإمارات العربية المتحدة')),
                    DropdownMenuItem(value: 'kw', child: Text('الكويت')),
                  ],
                  onChanged: (val) {
                    setState(() {
                      _selectedCountry = val;
                    });
                  },
                  validator: (val) {
                    if (val == null) {
                      return 'مطلوب';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomTextField(
                  controller: _cityController,
                  labelText: 'المدينة',
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'مطلوب';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Row: Passwords
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  controller: _passwordController,
                  labelText: 'كلمة المرور',
                  obscureText: _obscurePassword,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'مطلوب';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomTextField(
                  controller: _confirmPasswordController,
                  labelText: 'تأكيد كلمة المرور',
                  obscureText: _obscurePassword,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'مطلوب';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Terms Checkbox
          Row(
            children: [
              Checkbox(
                value: _acceptTerms,
                activeColor: AppColors.primary,
                onChanged: (val) {
                  setState(() {
                    _acceptTerms = val ?? false;
                  });
                },
              ),
              const Expanded(
                child: Text(
                  'أوافق على الشروط والأحكام وسياسة الخصوصية.',
                  style: TextStyle(fontSize: 13, color: AppColors.onSurfaceVariant),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Action Button
          PrimaryButton(
            text: 'إنشاء حساب',
            onPressed: _submit,
            suffixIcon: Icons.arrow_back,
          ),
          const SizedBox(height: 16),
          // Divider
          const Row(
            children: [
              Expanded(child: Divider(color: AppColors.outlineVariant)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'أو',
                  style: TextStyle(color: AppColors.outline, fontSize: 14),
                ),
              ),
              Expanded(child: Divider(color: AppColors.outlineVariant)),
            ],
          ),
          const SizedBox(height: 16),
          // Social Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: const BorderSide(color: AppColors.outlineVariant),
                  ),
                  icon: const Icon(Icons.apple, color: AppColors.onSurface, size: 20),
                  label: const Text(
                    'Apple',
                    style: TextStyle(color: AppColors.onSurfaceVariant),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: const BorderSide(color: AppColors.outlineVariant),
                  ),
                  icon: const Icon(Icons.g_mobiledata_rounded, color: Colors.red, size: 24),
                  label: const Text(
                    'Google',
                    style: TextStyle(color: AppColors.onSurfaceVariant),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

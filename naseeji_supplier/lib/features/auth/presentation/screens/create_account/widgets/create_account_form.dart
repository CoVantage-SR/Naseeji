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

    ref.read(registrationControllerProvider.notifier).updateBasicAccount(
          name: _managerController.text.trim(),
          email: _emailController.text.trim(),
          phone: _phoneController.text.trim(),
          password: _passwordController.text,
        );

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
    final isMobile = MediaQuery.of(context).size.width < 600;

    final companyField = CustomTextField(
      controller: _companyController,
      labelText: 'اسم الشركة',
      validator: (val) {
        if (val == null || val.trim().isEmpty) {
          return 'مطلوب';
        }
        return null;
      },
    );

    final managerField = CustomTextField(
      controller: _managerController,
      labelText: 'اسم المسؤول',
      validator: (val) {
        if (val == null || val.trim().isEmpty) {
          return 'مطلوب';
        }
        return null;
      },
    );

    final emailField = CustomTextField(
      controller: _emailController,
      labelText: 'البريد الإلكتروني',
      keyboardType: TextInputType.emailAddress,
      validator: (val) {
        if (val == null || val.trim().isEmpty) {
          return 'مطلوب';
        }
        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
        if (!emailRegex.hasMatch(val.trim())) {
          return 'يرجى إدخال بريد إلكتروني صحيح';
        }
        return null;
      },
    );

    final phoneField = CustomTextField(
      controller: _phoneController,
      labelText: 'رقم الهاتف',
      keyboardType: TextInputType.phone,
      prefixText: '+20 ',
      validator: (val) {
        if (val == null || val.trim().isEmpty) {
          return 'مطلوب';
        }
        final phoneRegex = RegExp(r'^[0-9]{9,11}$');
        if (!phoneRegex.hasMatch(val.trim())) {
          return 'يرجى إدخال رقم هاتف صحيح يتكون من 9 إلى 11 رقماً';
        }
        return null;
      },
    );

    final cityField = CustomTextField(
      controller: _cityController,
      labelText: 'المدينة',
      validator: (val) {
        if (val == null || val.trim().isEmpty) {
          return 'مطلوب';
        }
        return null;
      },
    );

    final passwordField = CustomTextField(
      controller: _passwordController,
      labelText: 'كلمة المرور',
      obscureText: _obscurePassword,
      suffixIcon: IconButton(
        icon: Icon(
          _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          color: AppColors.outline,
        ),
        onPressed: () {
          setState(() {
            _obscurePassword = !_obscurePassword;
          });
        },
      ),
      validator: (val) {
        if (val == null || val.isEmpty) {
          return 'مطلوب';
        }
        if (val.length < 6) {
          return 'يجب أن تتكون كلمة المرور من 6 أحرف على الأقل';
        }
        return null;
      },
    );

    final confirmPasswordField = CustomTextField(
      controller: _confirmPasswordController,
      labelText: 'تأكيد كلمة المرور',
      obscureText: _obscurePassword,
      suffixIcon: IconButton(
        icon: Icon(
          _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          color: AppColors.outline,
        ),
        onPressed: () {
          setState(() {
            _obscurePassword = !_obscurePassword;
          });
        },
      ),
      validator: (val) {
        if (val == null || val.isEmpty) {
          return 'مطلوب';
        }
        return null;
      },
    );

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Row 1: Company & Manager
          if (isMobile) ...[
            companyField,
            SizedBox(height: 16),
            managerField,
          ] else ...[
            Row(
              children: [
                Expanded(child: companyField),
                SizedBox(width: 16),
                Expanded(child: managerField),
              ],
            ),
          ],
          SizedBox(height: 16),

          // Row 2: Email & Phone
          if (isMobile) ...[
            emailField,
            SizedBox(height: 16),
            phoneField,
          ] else ...[
            Row(
              children: [
                Expanded(child: emailField),
                SizedBox(width: 16),
                Expanded(child: phoneField),
              ],
            ),
          ],
          SizedBox(height: 16),

          // Row 3: City (Full width)
          cityField,
          SizedBox(height: 16),

          // Row 4: Passwords
          if (isMobile) ...[
            passwordField,
            SizedBox(height: 16),
            confirmPasswordField,
          ] else ...[
            Row(
              children: [
                Expanded(child: passwordField),
                SizedBox(width: 16),
                Expanded(child: confirmPasswordField),
              ],
            ),
          ],
          SizedBox(height: 16),

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
              Expanded(
                child: Text(
                  'أوافق على الشروط والأحكام وسياسة الخصوصية.',
                  style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
              ),
            ],
          ),
          SizedBox(height: 24),

          // Action Button
          PrimaryButton(
            text: 'إنشاء حساب',
            onPressed: _submit,
            suffixIcon: Icons.arrow_back,
          ),
          SizedBox(height: 16),

          // Divider
          Row(
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
          SizedBox(height: 16),

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
                  icon: Icon(Icons.apple, color: AppColors.onSurface, size: 20),
                  label: Text(
                    'Apple',
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                ),
              ),
              SizedBox(width: 16),
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
                  label: Text(
                    'Google',
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
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
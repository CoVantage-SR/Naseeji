import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import 'package:naseeji_supplier/core/widgets/general_widgets.dart';
import 'package:naseeji_supplier/features/auth/presentation/controllers/auth_controller.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController(); // Can be email or phone
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      await ref.read(authControllerProvider.notifier).login(
            _identifierController.text.trim(),
            _passwordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Input: Email/Phone
          Text(
            'البريد الإلكتروني أو رقم الهاتف',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 8),
          CustomTextField(
            controller: _identifierController,
            labelText: 'example@naseeji.com',
            prefixIcon: Icons.person_outline,
            validator: (val) {
              if (val == null || val.trim().isEmpty) {
                return 'يرجى إدخال البريد الإلكتروني أو رقم الهاتف';
              }
              final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
              final phoneRegex = RegExp(r'^\+?[0-9]{9,15}$');
              final cleanVal = val.trim();
              if (!emailRegex.hasMatch(cleanVal) && !phoneRegex.hasMatch(cleanVal)) {
                return 'يرجى إدخال بريد إلكتروني صحيح أو رقم هاتف صحيح';
              }
              return null;
            },
          ),
          SizedBox(height: 16),
          // Input: Password
          Text(
            'كلمة المرور',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 8),
          CustomTextField(
            controller: _passwordController,
            labelText: '••••••••',
            prefixIcon: Icons.lock_outline,
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
                return 'يرجى إدخال كلمة المرور';
              }
              if (val.length < 6) {
                return 'يجب أن تتكون كلمة المرور من 6 أحرف على الأقل';
              }
              return null;
            },
          ),
          SizedBox(height: 16),
          // Options: Remember Me & Forgot Password
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: _rememberMe,
                    activeColor: AppColors.primary,
                    onChanged: (val) {
                      setState(() {
                        _rememberMe = val ?? false;
                      });
                    },
                  ),
                  Text(
                    'تذكرني',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  // Forgot password action
                },
                child: Text(
                  'نسيت كلمة المرور؟',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          // Submit Button
          PrimaryButton(
            text: 'تسجيل الدخول',
            onPressed: _submit,
          ),
          SizedBox(height: 24),
          // Or Divider
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
          SizedBox(height: 24),
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
                    'آبل',
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
                    'جوجل',
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
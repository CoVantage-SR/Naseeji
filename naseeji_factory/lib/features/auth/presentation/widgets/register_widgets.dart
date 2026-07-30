import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/utils/validation.dart';

class RegisterHeaderWidget extends StatelessWidget {
  final bool compact;
  const RegisterHeaderWidget({super.key, this.compact = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'إنشاء حساب مصنع جديد',
          style: compact
              ? context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                )
              : context.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
        ),
        if (!compact) ...[
          AppSpacing.hXS,
          Text(
            'سجل حسابك الأساسي للبدء في إعداد ملف المصنع الخاص بك.',
            style: context.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondaryLight,
            ),
          ),
        ],
      ],
    );
  }
}

class StepIndicatorWidget extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const StepIndicatorWidget({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'الخطوة $currentStep من $totalSteps',
              style: context.textTheme.bodyMedium?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${((currentStep / totalSteps) * 100).toInt()}% مكتمل',
              style: context.textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
        AppSpacing.hXS,
        ClipRRect(
          borderRadius: AppRadius.rRound,
          child: LinearProgressIndicator(
            value: currentStep / totalSteps,
            color: AppColors.primary,
            backgroundColor: AppColors.borderLight,
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}

class PhoneFieldWidget extends StatelessWidget {
  final TextEditingController controller;

  const PhoneFieldWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: ValidationUtils.validatePhone,
      textAlign: TextAlign.right,
      keyboardType: TextInputType.phone,
      decoration: const InputDecoration(
        labelText: 'رقم الهاتف المحمول',
        prefixIcon: Icon(Icons.phone_iphone_rounded),
        hintText: '01012345678',
      ),
    );
  }
}

class EmailFieldWidget extends StatelessWidget {
  final TextEditingController controller;

  const EmailFieldWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: ValidationUtils.validateEmail,
      textAlign: TextAlign.right,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        labelText: 'البريد الإلكتروني',
        prefixIcon: Icon(Icons.email_outlined),
        hintText: 'factory@naseeji.com',
      ),
    );
  }
}

class ConfirmPasswordFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final TextEditingController passwordController;

  const ConfirmPasswordFieldWidget({
    super.key,
    required this.controller,
    required this.passwordController,
  });

  @override
  State<ConfirmPasswordFieldWidget> createState() => _ConfirmPasswordFieldWidgetState();
}

class _ConfirmPasswordFieldWidgetState extends State<ConfirmPasswordFieldWidget> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscureText,
      textAlign: TextAlign.right,
      validator: (val) {
        if (val == null || val.isEmpty) {
          return 'يرجى تأكيد كلمة المرور';
        }
        if (val != widget.passwordController.text) {
          return 'كلمتا المرور غير متطابقتين';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: 'تأكيد كلمة المرور',
        prefixIcon: const Icon(Icons.lock_outline_rounded),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off_rounded : Icons.visibility_rounded,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
      ),
    );
  }
}

class PasswordStrengthWidget extends StatelessWidget {
  final String password;

  const PasswordStrengthWidget({super.key, required this.password});

  @override
  Widget build(BuildContext context) {
    final strength = ValidationUtils.checkPasswordStrength(password);
    final text = ValidationUtils.getPasswordStrengthText(strength);
    
    Color color;
    if (strength <= 0.25) {
      color = AppColors.error;
    } else if (strength <= 0.5) {
      color = Colors.orange;
    } else if (strength <= 0.75) {
      color = Colors.amber;
    } else {
      color = AppColors.success;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'قوة كلمة المرور:',
              style: context.textTheme.bodySmall,
            ),
            Text(
              text,
              style: context.textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        AppSpacing.hXS,
        ClipRRect(
          borderRadius: AppRadius.rRound,
          child: LinearProgressIndicator(
            value: strength,
            color: color,
            backgroundColor: AppColors.borderLight,
            minHeight: 4,
          ),
        ),
      ],
    );
  }
}

class TermsCheckboxWidget extends StatefulWidget {
  final ValueChanged<bool> onChanged;

  const TermsCheckboxWidget({super.key, required this.onChanged});

  @override
  State<TermsCheckboxWidget> createState() => _TermsCheckboxWidgetState();
}

class _TermsCheckboxWidgetState extends State<TermsCheckboxWidget> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return FormField<bool>(
      initialValue: false,
      validator: (val) {
        if (val != true) {
          return 'يجب الموافقة على الشروط والأحكام للمتابعة';
        }
        return null;
      },
      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Checkbox(
                  value: _isChecked,
                  activeColor: AppColors.primary,
                  onChanged: (val) {
                    setState(() {
                      _isChecked = val ?? false;
                    });
                    widget.onChanged(_isChecked);
                    field.didChange(_isChecked);
                  },
                ),
                Expanded(
                  child: Text(
                    'أوافق على شروط وأحكام منصة نسيجي وسياسة الخصوصية.',
                    style: context.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
            if (field.hasError) ...[
              AppSpacing.hXXS,
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Text(
                  field.errorText ?? '',
                  style: context.textTheme.bodySmall?.copyWith(color: AppColors.error),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

class AlreadyHaveAccountWidget extends StatelessWidget {
  const AlreadyHaveAccountWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'لديك حساب بالفعل؟ ',
          style: context.textTheme.bodyMedium,
        ),
        TextButton(
          onPressed: () => context.go('/login'),
          child: const Text(
            'تسجيل الدخول',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

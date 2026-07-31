import 'package:flutter/material.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../shared/validators/validators.dart';

class LoginForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController phoneOrEmailController;
  final TextEditingController passwordController;
  final bool rememberMe;
  final ValueChanged<bool> onRememberMeChanged;
  final VoidCallback onForgotPassword;
  final VoidCallback onLogin;
  final bool isLoading;

  const LoginForm({
    super.key,
    required this.formKey,
    required this.phoneOrEmailController,
    required this.passwordController,
    required this.rememberMe,
    required this.onRememberMeChanged,
    required this.onForgotPassword,
    required this.onLogin,
    this.isLoading = false,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Field 1: Email or Phone
          _FormInputLabel(label: 'البريد الإلكتروني أو رقم الهاتف'),
          const SizedBox(height: 6),
          TextFormField(
            controller: widget.phoneOrEmailController,
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [
              AutofillHints.email,
              AutofillHints.telephoneNumber,
              AutofillHints.username,
            ],
            textDirection: TextDirection.rtl,
            style: theme.textTheme.bodyLarge,
            decoration: _buildInputDecoration(
              context: context,
              hintText: 'أدخل بريدك الإلكتروني أو رقم هاتفك',
              suffixIcon: Icons.person_outline_rounded,
            ),
            validator: Validators.emailOrPhone,
          ),

          AppSpacing.hMD,

          // Field 2: Password
          _FormInputLabel(label: 'كلمة المرور'),
          const SizedBox(height: 6),
          TextFormField(
            controller: widget.passwordController,
            obscureText: _obscurePassword,
            autofillHints: const [AutofillHints.password],
            textDirection: TextDirection.rtl,
            style: theme.textTheme.bodyLarge,
            decoration: _buildInputDecoration(
              context: context,
              hintText: 'أدخل كلمة المرور',
              suffixIcon: Icons.lock_outline_rounded,
              prefixIcon: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: colorScheme.outline,
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),
            validator: Validators.password,
          ),

          const SizedBox(height: 8),

          // Remember Me & Forgot Password Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Remember me (RTL Right side)
              InkWell(
                onTap: () => widget.onRememberMeChanged(!widget.rememberMe),
                borderRadius: AppRadius.rSM,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 20,
                        width: 20,
                        child: Checkbox(
                          value: widget.rememberMe,
                          onChanged: (val) => widget.onRememberMeChanged(val ?? false),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          activeColor: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'تذكرني',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isDark ? colorScheme.onSurface : const Color(0xFF334155),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Forgot password button (RTL Left side)
              TextButton(
                onPressed: widget.onForgotPassword,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'نسيت كلمة المرور؟',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          AppSpacing.hLG,

          // Primary Login Button
          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: widget.isLoading ? null : widget.onLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: Colors.white,
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: widget.isLoading
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'تسجيل الدخول',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required BuildContext context,
    required String hintText,
    IconData? suffixIcon,
    Widget? prefixIcon,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return InputDecoration(
      hintText: hintText,
      hintStyle: theme.textTheme.bodyMedium?.copyWith(
        color: isDark ? colorScheme.onSurfaceVariant.withValues(alpha: 0.6) : const Color(0xFF94A3B8),
        fontSize: 13,
      ),
      filled: true,
      fillColor: isDark ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.5) : Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      suffixIcon: suffixIcon != null
          ? Icon(
              suffixIcon,
              color: isDark ? colorScheme.onSurfaceVariant : const Color(0xFF64748B),
              size: 20,
            )
          : null,
      prefixIcon: prefixIcon,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: isDark ? colorScheme.outline.withValues(alpha: 0.4) : const Color(0xFFE2E8F0),
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: colorScheme.primary,
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: colorScheme.error,
          width: 1,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: colorScheme.error,
          width: 1.5,
        ),
      ),
    );
  }
}

class _FormInputLabel extends StatelessWidget {
  final String label;

  const _FormInputLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Text(
      label,
      style: theme.textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: isDark ? theme.colorScheme.onSurface : const Color(0xFF1E293B),
        fontSize: 13.5,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../../shared/validators/validators.dart';

class RegisterTextFields extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  const RegisterTextFields({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.passwordController,
    required this.confirmPasswordController,
  });

  @override
  State<RegisterTextFields> createState() => _RegisterTextFieldsState();
}

class _RegisterTextFieldsState extends State<RegisterTextFields> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Full Name
        _InputLabel(label: 'الاسم الكامل'),
        const SizedBox(height: 6),
        TextFormField(
          controller: widget.nameController,
          textDirection: TextDirection.rtl,
          textInputAction: TextInputAction.next,
          decoration: _buildDecoration(
            context: context,
            hintText: 'أدخل اسمك بالكامل',
            suffixIcon: Icons.person_outline_rounded,
          ),
          validator: (v) => Validators.required(v, 'أدخل اسمك بالكامل'),
        ),

        const SizedBox(height: 16),

        // 2. Email
        _InputLabel(label: 'البريد الإلكتروني'),
        const SizedBox(height: 6),
        TextFormField(
          controller: widget.emailController,
          keyboardType: TextInputType.emailAddress,
          textDirection: TextDirection.rtl,
          textInputAction: TextInputAction.next,
          decoration: _buildDecoration(
            context: context,
            hintText: 'أدخل بريدك الإلكتروني',
            suffixIcon: Icons.email_outlined,
          ),
          validator: Validators.email,
        ),

        const SizedBox(height: 16),

        // 3. Phone Number
        _InputLabel(label: 'رقم الهاتف'),
        const SizedBox(height: 6),
        TextFormField(
          controller: widget.phoneController,
          keyboardType: TextInputType.phone,
          textDirection: TextDirection.rtl,
          textInputAction: TextInputAction.next,
          decoration: _buildDecoration(
            context: context,
            hintText: 'أدخل رقم هاتفك',
            suffixIcon: Icons.phone_outlined,
          ),
          validator: Validators.phone,
        ),

        const SizedBox(height: 16),

        // 4. Password
        _InputLabel(label: 'كلمة المرور'),
        const SizedBox(height: 6),
        TextFormField(
          controller: widget.passwordController,
          obscureText: _obscurePassword,
          textDirection: TextDirection.rtl,
          textInputAction: TextInputAction.next,
          decoration: _buildDecoration(
            context: context,
            hintText: 'أدخل كلمة المرور',
            suffixIcon: Icons.lock_outline_rounded,
            prefixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
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

        const SizedBox(height: 16),

        // 5. Confirm Password
        _InputLabel(label: 'تأكيد كلمة المرور'),
        const SizedBox(height: 6),
        TextFormField(
          controller: widget.confirmPasswordController,
          obscureText: _obscureConfirmPassword,
          textDirection: TextDirection.rtl,
          textInputAction: TextInputAction.done,
          decoration: _buildDecoration(
            context: context,
            hintText: 'أعد كتابة كلمة المرور',
            suffixIcon: Icons.lock_outline_rounded,
            prefixIcon: IconButton(
              icon: Icon(
                _obscureConfirmPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                size: 20,
              ),
              onPressed: () {
                setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                });
              },
            ),
          ),
          validator: (v) {
            if (v == null || v.isEmpty) {
              return 'يرجى تأكيد كلمة المرور';
            }
            if (v != widget.passwordController.text) {
              return 'كلمة المرور غير متطابقة';
            }
            return null;
          },
        ),
      ],
    );
  }

  InputDecoration _buildDecoration({
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

class _InputLabel extends StatelessWidget {
  final String label;

  const _InputLabel({required this.label});

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

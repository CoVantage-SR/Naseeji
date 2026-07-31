import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_radius.dart';
import '../../core/constants/app_spacing.dart';
import '../../shared/validators/validators.dart';
import '../presentation/widgets/register_header.dart';
import '../presentation/widgets/register_logo.dart';
import '../providers/auth_providers.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  final String phone;

  const ResetPasswordScreen({super.key, required this.phone});

  @override
  ConsumerState<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  String _currentLanguage = 'العربية';

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleResetPassword() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    FocusScope.of(context).unfocus();
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 700));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم تعيين كلمة المرور الجديدة بنجاح!'),
          backgroundColor: Colors.green,
        ),
      );

      context.go('/auth/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? colorScheme.surface : const Color(0xFFFAFCFF),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: AbsorbPointer(
            absorbing: _isLoading,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Top Header Bar
                RegisterHeader(
                  onBack: () => Navigator.of(context).pop(),
                  currentLanguage: _currentLanguage,
                  onLanguageChanged: (lang) {
                    setState(() {
                      _currentLanguage = lang;
                    });
                  },
                ),

                AppSpacing.hSM,

                // 2. Brand Identity Header
                const RegisterLogo(),

                AppSpacing.hMD,

                // 3. Title & Subtitle
                Text(
                  'تعيين كلمة مرور جديدة',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? colorScheme.onSurface : const Color(0xFF1E293B),
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'أنشئ كلمة مرور جديدة وآمنة لاستخدامها في تسجيل الدخول',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isDark ? colorScheme.onSurfaceVariant : const Color(0xFF64748B),
                    fontSize: 13.5,
                  ),
                ),

                AppSpacing.hLG,

                // 4. Reset Form Fields
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // New Password Field
                      Text(
                        'كلمة المرور الجديدة',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDark ? colorScheme.onSurface : const Color(0xFF1E293B),
                          fontSize: 13.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _newPasswordController,
                        obscureText: _obscureNewPassword,
                        textDirection: TextDirection.rtl,
                        decoration: _buildInputDecoration(
                          context: context,
                          hintText: 'أدخل كلمة المرور الجديدة',
                          suffixIcon: Icons.lock_outline_rounded,
                          prefixIcon: IconButton(
                            icon: Icon(
                              _obscureNewPassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureNewPassword = !_obscureNewPassword;
                              });
                            },
                          ),
                        ),
                        validator: Validators.password,
                      ),

                      const SizedBox(height: 16),

                      // Confirm Password Field
                      Text(
                        'تأكيد كلمة المرور الجديدة',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDark ? colorScheme.onSurface : const Color(0xFF1E293B),
                          fontSize: 13.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: _obscureConfirmPassword,
                        textDirection: TextDirection.rtl,
                        decoration: _buildInputDecoration(
                          context: context,
                          hintText: 'أعد كتابة كلمة المرور الجديدة',
                          suffixIcon: Icons.lock_outline_rounded,
                          prefixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmPassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
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
                          if (v != _newPasswordController.text) {
                            return 'كلمة المرور غير متطابقة';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),

                AppSpacing.hXL,

                // 5. Save Button
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleResetPassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: Colors.white,
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'حفظ كلمة المرور وتسجيل الدخول',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),

                AppSpacing.hLG,
              ],
            ),
          ),
        ),
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

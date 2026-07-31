import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/general_widgets.dart';
import '../../../shared/validators/validators.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _isSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onSend() {
    if (_emailController.text.trim().isNotEmpty) {
      setState(() {
        _isSent = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('استعادة كلمة المرور'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              const Text(
                'إعادة ضبط كلمة المرور',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'أدخل بريدك الإلكتروني ليصلك رابط استعادة كلمة المرور',
                style: TextStyle(color: AppColors.outline),
              ),
              const SizedBox(height: 36),
              if (!_isSent) ...[
                CustomTextField(
                  controller: _emailController,
                  labelText: 'البريد الإلكتروني',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email_outlined,
                  validator: Validators.email,
                ),
                const SizedBox(height: 32),
                PrimaryButton(
                  text: 'إرسال رابط الاستعادة',
                  onPressed: _onSend,
                ),
              ] else ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.check_circle_outline, color: AppColors.success),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'تم إرسال رابط استعادة كلمة المرور بنجاح إلى بريدك الإلكتروني.',
                          style: TextStyle(color: AppColors.success),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                PrimaryButton(
                  text: 'العودة لتسجيل الدخول',
                  onPressed: () => context.go('/auth/login'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}


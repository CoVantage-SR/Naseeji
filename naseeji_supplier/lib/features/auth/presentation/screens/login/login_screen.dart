import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/session/session_tracker.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import 'package:naseeji_supplier/core/widgets/general_widgets.dart';
import 'package:naseeji_supplier/features/auth/presentation/controllers/auth_controller.dart';
import 'widgets/login_form.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);

    ref.listen(authControllerProvider, (previous, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error.toString()), backgroundColor: AppColors.error),
        );
      }
      if (next.hasValue && next.value != null) {
        ref.read(sessionTrackerProvider.notifier).startSession(next.value!.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('مرحباً بك: ${next.value!.name}'),
            backgroundColor: AppColors.secondary,
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'تسجيل الدخول',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SafeArea(
        child: LoadingOverlay(
          isLoading: authState.isLoading,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: ListView(
                shrinkWrap: true,
                children: [
                  Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.primaryContainer.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.login_rounded,
                        size: 36,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                      'مرحباً بعودتك',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.onBackground,
                      ),
                    ),
                  const SizedBox(height: 8),
                  const Text(
                    'سجل الدخول للمتابعة إلى حساب المورد الخاص بك',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 32),
                  const LoginForm(),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'ليس لديك حساب مورد؟',
                        style: TextStyle(color: AppColors.onSurfaceVariant),
                      ),
                      TextButton(
                        onPressed: () {
                          context.push('/supplier-type');
                        },
                        child: const Text(
                          'سجل الآن',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
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

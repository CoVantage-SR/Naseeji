import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../shared/enums/user_role.dart';
import '../providers/auth_providers.dart';
import 'widgets/account_registration_section.dart';
import 'widgets/demo_explore_banner.dart';
import 'widgets/google_sign_in_button.dart';
import 'widgets/header_brand_section.dart';
import 'widgets/language_dropdown_badge.dart';
import 'widgets/login_form.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneOrEmailController = TextEditingController(text: '01000000000');
  final _passwordController = TextEditingController(text: '123456');
  bool _rememberMe = true;
  String _currentLanguage = 'العربية';

  @override
  void dispose() {
    _phoneOrEmailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    FocusScope.of(context).unfocus();
    final success = await ref.read(authControllerProvider.notifier).login(
          _phoneOrEmailController.text.trim(),
          _passwordController.text,
          rememberMe: _rememberMe,
        );

    if (success && mounted) {
      final user = ref.read(authControllerProvider).user;
      _navigateByUserRole(user?.role);
    }
  }

  Future<void> _handleGoogleLogin() async {
    FocusScope.of(context).unfocus();
    final success = await ref.read(authControllerProvider.notifier).loginWithGoogle();
    if (success && mounted) {
      final user = ref.read(authControllerProvider).user;
      _navigateByUserRole(user?.role);
    }
  }

  Future<void> _handleDemoLogin(UserRole role) async {
    FocusScope.of(context).unfocus();
    await ref.read(authControllerProvider.notifier).loginDemo(role);
    if (mounted) {
      _navigateByUserRole(role);
    }
  }

  void _navigateByUserRole(UserRole? role) {
    if (role == UserRole.factory) {
      context.go('/factory/home');
    } else if (role == UserRole.supplier) {
      context.go('/supplier/dashboard');
    } else {
      context.go('/auth/choose-account-type');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      backgroundColor: isDark ? colorScheme.surface : const Color(0xFFFAFCFF),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: AbsorbPointer(
            absorbing: authState.isLoading,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Language Dropdown Bar
                Align(
                  alignment: AlignmentDirectional.topEnd,
                  child: LanguageDropdownBadge(
                    currentLanguage: _currentLanguage,
                    onLanguageChanged: (lang) {
                      setState(() {
                        _currentLanguage = lang;
                      });
                    },
                  ),
                ),
                AppSpacing.hSM,

                // 2. Brand Identity & Illustration Header
                const HeaderBrandSection(),

                AppSpacing.hMD,

                // 3. Welcome Title & Subtitle
                Text(
                  'تسجيل الدخول',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? colorScheme.onSurface : const Color(0xFF1E293B),
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'مرحباً بعودتك! سجّل دخولك للوصول إلى حسابك',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isDark ? colorScheme.onSurfaceVariant : const Color(0xFF64748B),
                    fontSize: 14,
                  ),
                ),

                AppSpacing.hLG,

                // 4. Main Login Form Widget
                LoginForm(
                  formKey: _formKey,
                  phoneOrEmailController: _phoneOrEmailController,
                  passwordController: _passwordController,
                  rememberMe: _rememberMe,
                  onRememberMeChanged: (val) {
                    setState(() {
                      _rememberMe = val;
                    });
                  },
                  onForgotPassword: () => context.push('/auth/forgot-password'),
                  onLogin: _handleLogin,
                  isLoading: authState.isLoading,
                ),

                if (authState.errorMessage != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: colorScheme.errorContainer.withValues(alpha: 0.3),
                      borderRadius: AppRadius.rSM,
                    ),
                    child: Text(
                      authState.errorMessage!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.error,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],

                AppSpacing.hLG,

                // 5. Divider "أو"
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: isDark ? colorScheme.outlineVariant : const Color(0xFFE2E8F0),
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text(
                        'أو',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isDark ? colorScheme.onSurfaceVariant : const Color(0xFF94A3B8),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: isDark ? colorScheme.outlineVariant : const Color(0xFFE2E8F0),
                        thickness: 1,
                      ),
                    ),
                  ],
                ),

                AppSpacing.hLG,

                // 6. Google Sign In Button
                GoogleSignInButton(
                  onPressed: _handleGoogleLogin,
                  isLoading: authState.isLoading,
                ),

                AppSpacing.hXL,

                // 7. Account Registration Options Section
                AccountRegistrationSection(
                  onRegisterFactory: () {
                    context.push('/auth/register', extra: UserRole.factory);
                  },
                  onRegisterSupplier: () {
                    context.push('/auth/register', extra: UserRole.supplier);
                  },
                ),

                AppSpacing.hLG,

                // 8. Bottom Demo Banner
                DemoExploreBanner(
                  onDemoFactory: () => _handleDemoLogin(UserRole.factory),
                  onDemoSupplier: () => _handleDemoLogin(UserRole.supplier),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

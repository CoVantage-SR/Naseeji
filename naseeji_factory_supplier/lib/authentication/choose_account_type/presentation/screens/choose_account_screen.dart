import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/session/session_provider.dart';
import '../../../presentation/providers/auth_providers.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../shared/enums/user_role.dart';
import '../providers/choose_account_provider.dart';
import '../widgets/continue_button.dart';
import '../widgets/factory_card.dart';
import '../widgets/info_card.dart';
import '../widgets/language_button.dart';
import '../widgets/logo_section.dart';
import '../widgets/page_header.dart';
import '../widgets/progress_indicator.dart';
import '../widgets/supplier_card.dart';

class ChooseAccountScreen extends ConsumerStatefulWidget {
  const ChooseAccountScreen({super.key});

  @override
  ConsumerState<ChooseAccountScreen> createState() => _ChooseAccountScreenState();
}

class _ChooseAccountScreenState extends ConsumerState<ChooseAccountScreen> {
  String _currentLanguage = 'العربية';

  Future<void> _handleContinue() async {
    FocusScope.of(context).unfocus();
    final controller = ref.read(chooseAccountControllerProvider.notifier);
    final state = ref.read(chooseAccountControllerProvider);

    final success = await controller.continueSelection();

    if (success && mounted) {
      final role = state.selectedAccountType;
      final authState = ref.read(authControllerProvider);

      if (authState.user != null && role != null) {
        await ref.read(sessionNotifierProvider.notifier).saveSession(
          accessToken: 'jwt_token_${DateTime.now().millisecondsSinceEpoch}',
          refreshToken: 'jwt_refresh_token',
          role: role,
        );
        if (mounted) {
          if (role == UserRole.supplier) {
            context.go('/supplier/dashboard');
          } else {
            context.go('/factory/home');
          }
        }
        return;
      }

      if (role == UserRole.supplier) {
        context.push('/auth/register', extra: UserRole.supplier);
      } else {
        context.push('/auth/register', extra: UserRole.factory);
      }
    } else if (mounted) {
      final err = ref.read(chooseAccountControllerProvider).errorMessage;
      if (err != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(err),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final state = ref.watch(chooseAccountControllerProvider);
    final controller = ref.read(chooseAccountControllerProvider.notifier);

    final isFactorySelected = state.selectedAccountType == UserRole.factory;
    final isSupplierSelected = state.selectedAccountType == UserRole.supplier;

    return Scaffold(
      backgroundColor: isDark ? colorScheme.surface : const Color(0xFFFAFCFF),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: AbsorbPointer(
            absorbing: state.isLoading,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Top AppBar (Back Button & Language Selector)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isDark ? colorScheme.surfaceContainerHighest : Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDark ? colorScheme.outline : const Color(0xFFE2E8F0),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.chevron_left_rounded,
                          size: 20,
                          color: isDark ? colorScheme.onSurface : const Color(0xFF334155),
                        ),
                      ),
                    ),
                    LanguageButton(
                      currentLanguage: _currentLanguage,
                      onLanguageChanged: (lang) {
                        setState(() {
                          _currentLanguage = lang;
                        });
                      },
                    ),
                  ],
                ),

                AppSpacing.hSM,

                // 2. Centered Logo Section
                const LogoSection(),

                AppSpacing.hMD,

                // 3. Horizontal Step Progress Indicator (Step 3 active)
                const RegistrationProgressIndicator(currentStep: 3),

                AppSpacing.hMD,

                // 4. Page Header Title & Subtitle
                const PageHeader(
                  title: 'اختيار نوع الحساب',
                  subtitle: 'اختر نوع الحساب الذي يناسبك للمتابعة',
                ),

                AppSpacing.hLG,

                // 5. Two Selection Cards (Factory & Supplier)
                SizedBox(
                  height: 340,
                  child: Row(
                    children: [
                      // Supplier Card (مورد)
                      Expanded(
                        child: SupplierCard(
                          isSelected: isSupplierSelected,
                          onTap: () => controller.selectSupplier(),
                        ),
                      ),
                      const SizedBox(width: 14),
                      // Factory Card (مصنع)
                      Expanded(
                        child: FactoryCard(
                          isSelected: isFactorySelected,
                          onTap: () => controller.selectFactory(),
                        ),
                      ),
                    ],
                  ),
                ),

                if (state.errorMessage != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: colorScheme.errorContainer.withValues(alpha: 0.3),
                      borderRadius: AppRadius.rSM,
                    ),
                    child: Text(
                      state.errorMessage!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.error,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],

                AppSpacing.hLG,

                // 6. Continue Action Button
                ContinueButton(
                  onPressed: state.selectedAccountType != null ? _handleContinue : null,
                  isLoading: state.isLoading,
                ),

                AppSpacing.hLG,

                // 7. Bottom Info Card ("لماذا نطلب نوع الحساب؟")
                const InfoCard(),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

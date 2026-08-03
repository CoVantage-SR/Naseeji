import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../domain/entities/account_type.dart';
import '../providers/account_type_provider.dart';
import '../widgets/account_type_card.dart';
import '../widgets/register_header.dart';
import '../widgets/register_logo.dart';

class AccountTypeScreen extends ConsumerStatefulWidget {
  const AccountTypeScreen({super.key});

  @override
  ConsumerState<AccountTypeScreen> createState() => _AccountTypeScreenState();
}

class _AccountTypeScreenState extends ConsumerState<AccountTypeScreen> {
  String _currentLanguage = 'العربية';

  void _handleContinue() {
    final selectedType = ref.read(accountTypeControllerProvider).selectedType;
    context.push('/auth/complete-profile', extra: selectedType.toUserRole());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final state = ref.watch(accountTypeControllerProvider);
    final controller = ref.read(accountTypeControllerProvider.notifier);

    return Scaffold(
      backgroundColor: isDark ? colorScheme.surface : const Color(0xFFFAFCFF),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
              const RegisterLogo(),
              AppSpacing.hMD,
              Text(
                'اختر نوع الحساب',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? colorScheme.onSurface : const Color(0xFF1E293B),
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'حدد طبيعة عملك على منصة نسيجي للبدء في الاستخدام',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDark ? colorScheme.onSurfaceVariant : const Color(0xFF64748B),
                  fontSize: 13.5,
                ),
              ),
              AppSpacing.hLG,
              AccountTypeCard(
                type: AccountType.factory,
                isSelected: state.selectedType == AccountType.factory,
                onTap: () => controller.selectAccountType(AccountType.factory),
              ),
              const SizedBox(height: 16),
              AccountTypeCard(
                type: AccountType.supplier,
                isSelected: state.selectedType == AccountType.supplier,
                onTap: () => controller.selectAccountType(AccountType.supplier),
              ),
              AppSpacing.hXL,
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: _handleContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  child: const Text('متابعة'),
                ),
              ),
              AppSpacing.hLG,
            ],
          ),
        ),
      ),
    );
  }
}

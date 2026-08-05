import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../domain/entities/account_type.dart';
import '../providers/account_type_provider.dart';
import '../widgets/account_type_card.dart';
import '../widgets/register_header.dart';
import '../widgets/register_logo.dart';

import '../../../../core/session/session_provider.dart';
import '../../../../shared/enums/user_role.dart';

class AccountTypeScreen extends ConsumerStatefulWidget {
  final bool isGuest;

  const AccountTypeScreen({
    super.key,
    this.isGuest = false,
  });

  @override
  ConsumerState<AccountTypeScreen> createState() => _AccountTypeScreenState();
}

class _AccountTypeScreenState extends ConsumerState<AccountTypeScreen> {
  String _currentLanguage = 'العربية';
  bool _isGuestModeSelected = false;

  Future<void> _handleContinue() async {
    final selectedType = ref.read(accountTypeControllerProvider).selectedType;
    final role = selectedType.toUserRole();

    if (widget.isGuest || _isGuestModeSelected) {
      await ref.read(sessionNotifierProvider.notifier).enterGuestMode(role);
      if (mounted) {
        if (role == UserRole.supplier) {
          context.go('/supplier/dashboard');
        } else {
          context.go('/factory/home');
        }
      }
    } else {
      context.push('/auth/basic-profile', extra: role);
    }
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
                widget.isGuest ? 'اختر نوع حساب الزائر' : 'اختر نوع الحساب (الخطوة 3 من 4)',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? colorScheme.onSurface : const Color(0xFF1E293B),
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                widget.isGuest
                    ? 'تصفح منصة نسيجي كزائر مصنع أو كزائر مورد'
                    : 'حدد طبيعة نشاطك على منصة نسيجي للانتقال لاستكمال البيانات',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDark ? colorScheme.onSurfaceVariant : const Color(0xFF64748B),
                  fontSize: 13.5,
                ),
              ),
              AppSpacing.hLG,
              AccountTypeCard(
                type: AccountType.factory,
                isSelected: state.selectedType == AccountType.factory && !_isGuestModeSelected,
                onTap: () {
                  setState(() => _isGuestModeSelected = false);
                  controller.selectAccountType(AccountType.factory);
                },
              ),
              const SizedBox(height: 16),
              AccountTypeCard(
                type: AccountType.supplier,
                isSelected: state.selectedType == AccountType.supplier && !_isGuestModeSelected,
                onTap: () {
                  setState(() => _isGuestModeSelected = false);
                  controller.selectAccountType(AccountType.supplier);
                },
              ),
              const SizedBox(height: 16),
              // Option 3: Guest Mode Card (👤 الزائر)
              Container(
                decoration: BoxDecoration(
                  color: _isGuestModeSelected
                      ? colorScheme.primary.withValues(alpha: isDark ? 0.2 : 0.08)
                      : (isDark ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.3) : Colors.white),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _isGuestModeSelected
                        ? colorScheme.primary
                        : (isDark ? colorScheme.outline.withValues(alpha: 0.3) : const Color(0xFFE2E8F0)),
                    width: _isGuestModeSelected ? 2 : 1,
                  ),
                ),
                child: ListTile(
                  onTap: () {
                    setState(() => _isGuestModeSelected = true);
                  },
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFF64748B),
                    child: Icon(Icons.person_outline_rounded, color: Colors.white),
                  ),
                  title: Text(
                    '👤 تصفح كزائر (Guest)',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  subtitle: const Text(
                    'تصفح المنتجات والمصانع مباشرة بدون إدخال بيانات شركة (خصائص محدودة)',
                    style: TextStyle(fontSize: 11.5),
                  ),
                  trailing: Icon(
                    _isGuestModeSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                    color: _isGuestModeSelected ? colorScheme.primary : colorScheme.outline,
                  ),
                ),
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
                  child: Text(
                    (widget.isGuest || _isGuestModeSelected) ? 'الدخول كزائر مباشرة' : 'متابعة لاستكمال الملف',
                  ),
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

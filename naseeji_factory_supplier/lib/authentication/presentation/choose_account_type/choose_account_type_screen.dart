import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/general_widgets.dart';
import '../../../shared/enums/account_mode.dart';
import '../../../shared/enums/user_role.dart';
import '../providers/auth_providers.dart';

class ChooseAccountTypeScreen extends ConsumerStatefulWidget {
  const ChooseAccountTypeScreen({super.key});

  @override
  ConsumerState<ChooseAccountTypeScreen> createState() => _ChooseAccountTypeScreenState();
}

class _ChooseAccountTypeScreenState extends ConsumerState<ChooseAccountTypeScreen> {
  UserRole _selectedRole = UserRole.factory;
  AccountMode _selectedMode = AccountMode.real;

  void _onContinue() async {
    await ref.read(authControllerProvider.notifier).selectRoleAndMode(
          _selectedRole,
          _selectedMode,
        );

    if (!mounted) return;

    if (_selectedRole == UserRole.supplier) {
      context.go('/supplier/dashboard');
    } else {
      context.go('/factory/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('اختيار نوع الحساب'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'اختر نوع حسابك في المنصة',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'يمكنك التبديل بين وضع الحساب الحقيقي والوضع التجريبي بسهولة',
                style: TextStyle(color: AppColors.outline),
              ),
              const SizedBox(height: 32),
              // Factory Selection Card
              _RoleCard(
                title: 'حساب مصنع (Factory)',
                subtitle: 'لطلب المواد الخام، إنشاء طلبات العروض (RFQ)، وتتبع الإنتاج.',
                icon: Icons.factory_rounded,
                isSelected: _selectedRole == UserRole.factory,
                onTap: () => setState(() => _selectedRole = UserRole.factory),
              ),
              const SizedBox(height: 16),
              // Supplier Selection Card
              _RoleCard(
                title: 'حساب مورد (Supplier)',
                subtitle: 'لعرض المنتجات، استقبال الطلبات، وتقديم عروض الأسعار.',
                icon: Icons.store_rounded,
                isSelected: _selectedRole == UserRole.supplier,
                onTap: () => setState(() => _selectedRole = UserRole.supplier),
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 12),
              // Real vs Demo Switcher
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'وضع العرض التجريبي (Demo Mode)',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      Text(
                        'استكشاف ميزات المنصة ببيانات توضيحية',
                        style: TextStyle(color: AppColors.outline, fontSize: 12),
                      ),
                    ],
                  ),
                  Switch(
                    value: _selectedMode == AccountMode.demo,
                    onChanged: (val) {
                      setState(() {
                        _selectedMode = val ? AccountMode.demo : AccountMode.real;
                      });
                    },
                  ),
                ],
              ),
              const Spacer(),
              PrimaryButton(
                text: 'المتابعة للوحة التحكم',
                onPressed: _onContinue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primary.withValues(alpha: 0.08)
              : colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? colorScheme.primary : AppColors.borderLight,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : colorScheme.primary,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? colorScheme.primary : colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.outline,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle_rounded, color: colorScheme.primary),
          ],
        ),
      ),
    );
  }
}


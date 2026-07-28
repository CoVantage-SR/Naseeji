import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/reusable_widgets.dart';
import '../providers/account_provider.dart';
import '../widgets/account_widgets.dart';

class FactoryAccountScreen extends ConsumerStatefulWidget {
  const FactoryAccountScreen({super.key});

  @override
  ConsumerState<FactoryAccountScreen> createState() => _FactoryAccountScreenState();
}

class _FactoryAccountScreenState extends ConsumerState<FactoryAccountScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final factoryProfile = ref.watch(factoryProvider);
    final wallet = ref.watch(walletProvider);
    final employeesSummary = ref.watch(employeesProvider);
    final rewardPoints = ref.watch(rewardPointsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Header Bar ─────────────────────────────────
            _AccountScreenHeader(
              onNotificationTap: () => context.push('/notifications'),
              onSettingsTap: () => context.push('/account/settings'),
            ),

            // ── Scrollable Body Content ────────────────────────
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                physics: const BouncingScrollPhysics(),
                children: [
                  // 1. Top Profile Header Card
                  FactoryProfileCard(
                    profile: factoryProfile,
                    onEditTap: () => checkGuestAction(
                      context,
                      ref,
                      () => context.push('/account/profile/edit'),
                    ),
                  ),

                  AppSpacing.hMD,

                  // 2. Quick Summary Cards (3 Compact Cards)
                  Row(
                    children: [
                      // Card 1: Employees
                      QuickStatCard(
                        label: 'الموظفين',
                        value: '${employeesSummary.totalEmployees}',
                        actionText: 'إدارة الموظفين',
                        icon: Icons.people_alt_outlined,
                        iconColor: const Color(0xFF2563EB),
                        iconBgColor: const Color(0xFFEFF6FF),
                        actionColor: const Color(0xFF2563EB),
                        onTap: () => checkGuestAction(
                          context,
                          ref,
                          () => context.push('/account/employees'),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Card 2: Wallet
                      QuickStatCard(
                        label: 'المحفظة',
                        value:
                            '${_formatCurrency(wallet.balance)} ${wallet.currency}',
                        actionText: 'طرق الدفع',
                        icon: Icons.account_balance_wallet_outlined,
                        iconColor: const Color(0xFF10B981),
                        iconBgColor: const Color(0xFFECFDF5),
                        actionColor: const Color(0xFF10B981),
                        onTap: () => checkGuestAction(
                          context,
                          ref,
                          () => context.push('/account/payment-methods'),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Card 3: Reward Points
                      QuickStatCard(
                        label: 'رصيد النقاط',
                        value:
                            '${_formatCurrency(rewardPoints.points.toDouble())} نقطة',
                        actionText: 'عرض المكافآت',
                        icon: Icons.star_outline_rounded,
                        iconColor: const Color(0xFFF59E0B),
                        iconBgColor: const Color(0xFFFFFBEB),
                        actionColor: const Color(0xFFF59E0B),
                        onTap: () => checkGuestAction(
                          context,
                          ref,
                          () => context.push('/account/subscription'),
                        ),
                      ),
                    ],
                  ),

                  AppSpacing.hLG,

                  // 3. Factory Management Section (إدارة المصنع)
                  SettingsGroup(
                    title: 'إدارة المصنع',
                    items: [
                      SettingsTile(
                        title: 'بيانات المصنع',
                        subtitle: 'عرض وتعديل بيانات المصنع والمستندات',
                        icon: Icons.business_outlined,
                        iconColor: const Color(0xFF2563EB),
                        onTap: () => checkGuestAction(
                          context,
                          ref,
                          () => context.push('/account/profile'),
                        ),
                      ),
                      SettingsTile(
                        title: 'الأمان والحساب',
                        subtitle: 'تغيير كلمة المرور وتفعيل المصادقة الثنائية',
                        icon: Icons.shield_outlined,
                        iconColor: const Color(0xFF2563EB),
                        onTap: () => checkGuestAction(
                          context,
                          ref,
                          () => context.push('/account/security'),
                        ),
                      ),
                      SettingsTile(
                        title: 'الإشعارات',
                        subtitle: 'إدارة تفضيلات الإشعارات والتنبيهات',
                        icon: Icons.notifications_none_rounded,
                        iconColor: const Color(0xFF2563EB),
                        onTap: () => checkGuestAction(
                          context,
                          ref,
                          () => context.push('/account/notifications'),
                        ),
                      ),
                      SettingsTile(
                        title: 'الاشتراك والفواتير',
                        subtitle: 'إدارة خطة الاشتراك والفواتير',
                        icon: Icons.credit_card_rounded,
                        iconColor: const Color(0xFF2563EB),
                        onTap: () => checkGuestAction(
                          context,
                          ref,
                          () => context.push('/account/subscription'),
                        ),
                      ),
                    ],
                  ),

                  AppSpacing.hLG,

                  // 4. General Settings Section (الإعدادات العامة)
                  SettingsGroup(
                    title: 'الإعدادات العامة',
                    items: [
                      SettingsTile(
                        title: 'اللغة',
                        subtitle: 'العربية',
                        icon: Icons.language_rounded,
                        iconColor: const Color(0xFF2563EB),
                        onTap: () => context.push('/account/language'),
                      ),
                      SettingsTile(
                        title: 'المظهر',
                        subtitle: isDark ? 'الوضع الداكن' : 'الوضع الفاتح',
                        icon: Icons.palette_outlined,
                        iconColor: const Color(0xFF2563EB),
                        onTap: () => context.push('/account/appearance'),
                      ),
                      SettingsTile(
                        title: 'مركز المساعدة',
                        subtitle: 'الأسئلة الشائعة والدعم',
                        icon: Icons.help_outline_rounded,
                        iconColor: const Color(0xFF2563EB),
                        onTap: () => context.push('/account/help'),
                      ),
                      SettingsTile(
                        title: 'الدعم الفني',
                        subtitle: 'تواصل مع فريق نسيجي',
                        icon: Icons.headset_mic_outlined,
                        iconColor: const Color(0xFF2563EB),
                        onTap: () => context.push('/account/support'),
                      ),
                      SettingsTile(
                        title: 'عن نسيجي',
                        subtitle: 'نسخة التطبيق 1.2.0',
                        icon: Icons.info_outline_rounded,
                        iconColor: const Color(0xFF2563EB),
                        onTap: () => context.push('/account/about'),
                      ),
                    ],
                  ),

                  AppSpacing.hLG,

                  // 5. Logout Button
                  LogoutButton(
                    onConfirmLogout: () {
                      ref.read(authProvider.notifier).logout();
                      context.go('/login');
                    },
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatCurrency(double amount) {
    return amount.toInt().toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+$)'),
          (match) => '${match[1]},',
        );
  }
}

// ── Top Header Bar Widget ──────────────────────────────────────────────

class _AccountScreenHeader extends StatelessWidget {
  final VoidCallback onNotificationTap;
  final VoidCallback onSettingsTap;

  const _AccountScreenHeader({
    required this.onNotificationTap,
    required this.onSettingsTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: surface,
        border: Border(bottom: BorderSide(color: border, width: 0.5)),
      ),
      child: Row(
        children: [
          // Notification bell icon (Left in RTL layout)
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark
                      ? AppColors.borderDark
                      : AppColors.backgroundLight,
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    Icons.notifications_outlined,
                    color: textPrimary,
                    size: 22,
                  ),
                  onPressed: onNotificationTap,
                ),
              ),
              Positioned(
                top: -2,
                right: -2,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: const BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      '3',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Title (Centered)
          Expanded(
            child: Text(
              'الحساب',
              textAlign: TextAlign.center,
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: textPrimary,
              ),
            ),
          ),

          // Settings gear icon (Right in RTL layout)
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark ? AppColors.borderDark : AppColors.backgroundLight,
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(
                Icons.settings_outlined,
                color: textPrimary,
                size: 22,
              ),
              onPressed: onSettingsTap,
            ),
          ),
        ],
      ),
    );
  }
}

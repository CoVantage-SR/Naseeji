import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/session/session_provider.dart';
import '../../../../shared/widgets/verification_status_card.dart';
import '../../../home/presentation/widgets/factory_bottom_navigation.dart';
import '../providers/account_provider.dart';
import '../widgets/account_reusable_widgets.dart';
import '../widgets/profile_widgets.dart';

class AccountProfileScreen extends ConsumerWidget {
  const AccountProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(accountNotifierProvider).profile;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      bottomNavigationBar: const FactoryBottomNavigation(currentIndex: 4),
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // ── 1. Header Profile Cover & Overlapping Avatar Stack ─────────
            Stack(
              clipBehavior: Clip.none,
              children: [
                // Cover Photo
                Image.network(
                  profile.coverUrl,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 180,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary, AppColors.primaryDark],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),

                // Gradient Overlay for readability
                Container(
                  height: 180,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withValues(alpha: 0.5),
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.6),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),

                // Top Navigation Bar (Back, Edit Cover, Settings)
                Positioned(
                  top: MediaQuery.of(context).padding.top + 8,
                  left: 16,
                  right: 16,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Back Button
                      IconButton(
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.black.withValues(alpha: 0.45),
                          foregroundColor: Colors.white,
                        ),
                        icon: const Icon(Icons.arrow_back_rounded),
                        onPressed: () {
                          if (context.canPop()) {
                            context.pop();
                          } else {
                            context.go('/factory/home');
                          }
                        },
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => context.push('/account/profile/edit'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.45),
                                borderRadius: AppRadius.rRound,
                              ),
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.edit_rounded,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'تعديل الغلاف',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.black.withValues(alpha: 0.45),
                              foregroundColor: Colors.white,
                            ),
                            icon: const Icon(Icons.settings_rounded),
                            onPressed: () => context.push('/account/settings'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Avatar Logo Circle Overlapping Cover Edge
                Positioned(
                  bottom: -40,
                  right: 20,
                  child: Stack(
                    children: [
                      Container(
                        width: 84,
                        height: 84,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3.5),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.network(
                            profile.logoUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              child: const Icon(
                                Icons.factory_rounded,
                                color: AppColors.primary,
                                size: 40,
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (profile.isVerified)
                        Positioned(
                          bottom: 2,
                          left: 2,
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.verified_rounded,
                              color: Color(0xFF2563EB),
                              size: 18,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),

            // ── 2. Main Profile Content ────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 52, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Factory Title & Status Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profile.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${profile.factoryType} • ${profile.city}، ${profile.country}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SubscriptionBadge(plan: profile.subscriptionPlan),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: profile.isAccountActive
                                  ? AppColors.success.withValues(alpha: 0.12)
                                  : AppColors.error.withValues(alpha: 0.12),
                              borderRadius: AppRadius.rRound,
                            ),
                            child: Text(
                              profile.isAccountActive ? 'الحساب نشط' : 'الحساب موقوف',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: profile.isAccountActive
                                    ? AppColors.success
                                    : AppColors.error,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  AppSpacing.hLG,

                  // Quick Action Buttons (تعديل، مشاركة، QR Code)
                  QuickActionsWidget(
                    onEditProfile: () => context.push('/account/profile/edit'),
                    onShareProfile: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('جاري مشاركة ملف المصنع...')),
                      );
                    },
                    onGenerateQR: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('جاري توليد رمز QR...')),
                      );
                    },
                  ),

                  AppSpacing.hMD,

                  // Verification Card
                  VerificationStatusCard(
                    status: ref.watch(sessionNotifierProvider).verificationStatus,
                    level: ref.watch(sessionNotifierProvider).verificationLevel,
                  ),

                  AppSpacing.hMD,

                  // Subscription Card
                  SubscriptionCardWidget(
                    profile: profile,
                    onUpgrade: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('صفحة الترقية قيد التطوير.')),
                      );
                    },
                  ),

                  AppSpacing.hMD,
                  const FactoryStatisticsWidget(),
                  AppSpacing.hMD,
                  FactorySummaryWidget(profile: profile),
                  AppSpacing.hMD,
                  CompanyInformationWidget(profile: profile),
                  AppSpacing.hMD,
                  ContactInformationWidget(profile: profile),
                  AppSpacing.hMD,

                  // Navigation Settings Tiles
                  _navTile(
                    context,
                    Icons.people_rounded,
                    'إدارة الموظفين والصلاحيات',
                    () => context.push('/account/employees'),
                  ),
                  _navTile(
                    context,
                    Icons.settings_rounded,
                    'الإعدادات العامة',
                    () => context.push('/account/settings'),
                  ),
                  _navTile(
                    context,
                    Icons.privacy_tip_rounded,
                    'سياسة الخصوصية',
                    () => context.push('/account/privacy'),
                  ),
                  _navTile(
                    context,
                    Icons.gavel_rounded,
                    'الشروط والأحكام',
                    () => context.push('/account/terms'),
                  ),

                  const SizedBox(height: 12),
                  const Divider(),

                  // Logout Button
                  ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.logout_rounded,
                        color: Colors.red,
                        size: 20,
                      ),
                    ),
                    title: const Text(
                      'تسجيل الخروج',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: Colors.red,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 14,
                      color: Colors.red,
                    ),
                    onTap: () => context.go('/auth/login'),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navTile(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return SettingTile(icon: icon, title: title, onTap: onTap);
  }
}

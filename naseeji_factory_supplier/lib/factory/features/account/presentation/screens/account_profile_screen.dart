import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_factory/core/constants/app_spacing.dart';
import 'package:naseeji_factory/core/session/session_provider.dart';
import 'package:naseeji_factory/shared/widgets/verification_status_card.dart';
import '../providers/account_provider.dart';
import '../widgets/account_reusable_widgets.dart';
import '../widgets/profile_widgets.dart';

class AccountProfileScreen extends ConsumerWidget {
  const AccountProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(accountNotifierProvider).profile;

    return Scaffold(
      bottomNavigationBar: const FactoryBottomNavigation(currentIndex: 4),
      body: CustomScrollView(
        slivers: [
          // Collapsible Header
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: ProfileHeaderWidget(
                profile: profile,
                onEdit: () => context.push('/account/profile/edit'),
                onBack: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/factory/home');
                  }
                },
                onSettings: () => context.push('/account/settings'),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Quick Actions Bar
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
                  VerificationStatusCard(
                    status: ref.watch(sessionNotifierProvider).verificationStatus,
                    level: ref.watch(sessionNotifierProvider).verificationLevel,
                  ),
                  AppSpacing.hMD,
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
                  // Navigation tiles
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
                  const SizedBox(height: 8),
                  const Divider(),
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
          ),
        ],
      ),
    );
  }

  Widget _navTile(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return SettingTile(icon: icon, title: title, onTap: onTap);
  }
}




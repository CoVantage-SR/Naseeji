import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_spacing.dart';
import '../providers/account_provider.dart';
import '../widgets/account_reusable_widgets.dart';
import '../widgets/general_settings/account_section_widget.dart';
import '../widgets/general_settings/application_section_widget.dart';
import '../widgets/general_settings/data_section_widget.dart';
import '../widgets/general_settings/logout_widget.dart';
import '../widgets/general_settings/security_section_widget.dart';

class GeneralSettingsScreen extends ConsumerWidget {
  const GeneralSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsNotifierProvider);
    final notifier = ref.read(settingsNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('الإعدادات العامة'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Account Section
              const SectionHeader(title: 'الحساب'),
              const AccountSectionWidget(),
              AppSpacing.hSM,

              // Security Section
              const SectionHeader(title: 'الأمان'),
              const SecuritySectionWidget(),
              AppSpacing.hSM,

              // Application Section
              const SectionHeader(title: 'التطبيق'),
              ApplicationSectionWidget(settings: settings, notifier: notifier),
              AppSpacing.hSM,

              // Data Section
              const SectionHeader(title: 'البيانات'),
              const DataSectionWidget(),
              AppSpacing.hSM,

              // Logout
              const SectionHeader(title: ''),
              LogoutWidget(onLogout: () => context.go('/login')),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}




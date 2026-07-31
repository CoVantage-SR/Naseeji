import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_spacing.dart';
import '../providers/mini_profile_provider.dart';
import '../widgets/mini_profile_widgets.dart';

class MiniProfileScreen extends ConsumerWidget {
  const MiniProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(miniProfileNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('الملف الشخصي للمصنع'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ProfileHeaderWidget(
                name: profile.name,
                legalEntity: profile.legalEntity,
                status: profile.accountStatus,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StatisticsWidget(
                      totalOrders: profile.totalOrders,
                      totalRfqs: profile.totalRfqs,
                      totalFavorites: profile.totalFavoriteSuppliers,
                    ),
                    AppSpacing.hLG,
                    FactoryInformationCardWidget(
                      governorate: profile.governorate,
                      city: profile.city,
                      legalEntity: profile.legalEntity,
                    ),
                    AppSpacing.hLG,
                    BusinessCategoryWidget(categories: profile.businessCategories),
                    AppSpacing.hLG,
                    const AccountStatusWidget(),
                    AppSpacing.hXL,
                    ShortcutButtonsWidget(
                      onEditProfile: () {},
                      onManageEmployees: () {},
                      onSettings: () => context.push('/settings'),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



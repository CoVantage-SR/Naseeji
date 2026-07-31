import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/reusable_widgets.dart';

/// 1. ProfileHeaderWidget
class ProfileHeaderWidget extends StatelessWidget {
  final String name;
  final String legalEntity;
  final String status;

  const ProfileHeaderWidget({
    super.key,
    required this.name,
    required this.legalEntity,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;

    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          clipBehavior: Clip.none,
          children: [
            // Banner Background
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryLight],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
              ),
            ),
            // Avatar Overlay
            Positioned(
              bottom: -40,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDark ? AppColors.backgroundDark : Colors.white,
                    width: 4,
                  ),
                ),
                child: SupplierAvatar(name: name, size: 80),
              ),
            ),
          ],
        ),
        const SizedBox(height: 52),
        Text(
          name,
          style: context.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StatusChip(label: legalEntity, color: AppColors.primary),
            const SizedBox(width: 8),
            if (status == 'verified')
              const StatusChip(label: 'حساب موثق ✅', color: AppColors.success)
            else
              const StatusChip(label: 'قيد المراجعة', color: AppColors.warning),
          ],
        ),
      ],
    );
  }
}

/// 2. FactoryInformationCardWidget
class FactoryInformationCardWidget extends StatelessWidget {
  final String governorate;
  final String city;
  final String legalEntity;

  const FactoryInformationCardWidget({
    super.key,
    required this.governorate,
    required this.city,
    required this.legalEntity,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;

    return PrimaryCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'معلومات المنشأة',
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          AppSpacing.hMD,
          _buildInfoRow(context, Icons.location_on_outlined, 'المحافظة', governorate, isDark),
          const Divider(height: 20),
          _buildInfoRow(context, Icons.location_city_outlined, 'المدينة / المنطقة', city, isDark),
          const Divider(height: 20),
          _buildInfoRow(context, Icons.business_center_outlined, 'الشكل القانوني', legalEntity, isDark),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String label, String value, bool isDark) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(width: 12),
        Text(
          label,
          style: TextStyle(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

/// 3. BusinessCategoryWidget
class BusinessCategoryWidget extends StatelessWidget {
  final List<String> categories;

  const BusinessCategoryWidget({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Text(
            'مجالات عمل المصنع',
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        AppSpacing.hSM,
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: categories.map((cat) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: AppRadius.rRound,
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.15),
                ),
              ),
              child: Text(
                cat,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

/// 4. StatisticsWidget
class StatisticsWidget extends StatelessWidget {
  final int totalOrders;
  final int totalRfqs;
  final int totalFavorites;

  const StatisticsWidget({
    super.key,
    required this.totalOrders,
    required this.totalRfqs,
    required this.totalFavorites,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;

    return PrimaryCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem(context, totalOrders.toString(), 'الطلبات', isDark),
          _buildDivider(isDark),
          _buildStatItem(context, totalRfqs.toString(), 'عروض الأسعار', isDark),
          _buildDivider(isDark),
          _buildStatItem(context, totalFavorites.toString(), 'المفضلة', isDark),
        ],
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String value, String label, bool isDark) {
    return Column(
      children: [
        Text(
          value,
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: context.textTheme.bodySmall?.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider(bool isDark) {
    return Container(
      width: 1,
      height: 36,
      color: isDark ? AppColors.borderDark : AppColors.borderLight,
    );
  }
}

/// 5. ShortcutButtonsWidget
class ShortcutButtonsWidget extends StatelessWidget {
  final VoidCallback onEditProfile;
  final VoidCallback onManageEmployees;
  final VoidCallback onSettings;

  const ShortcutButtonsWidget({
    super.key,
    required this.onEditProfile,
    required this.onManageEmployees,
    required this.onSettings,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: onEditProfile,
          icon: const Icon(Icons.edit_outlined),
          label: const Text('تعديل الملف الشخصي'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(borderRadius: AppRadius.rMD),
          ),
        ),
        AppSpacing.hSM,
        OutlinedButton.icon(
          onPressed: onManageEmployees,
          icon: const Icon(Icons.people_outline_rounded),
          label: const Text('إدارة الموظفين والمسؤولين'),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppColors.primary),
            foregroundColor: AppColors.primary,
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(borderRadius: AppRadius.rMD),
          ),
        ),
        AppSpacing.hSM,
        OutlinedButton.icon(
          onPressed: onSettings,
          icon: const Icon(Icons.settings_outlined),
          label: const Text('إعدادات الحساب والأمان'),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppColors.primary),
            foregroundColor: AppColors.primary,
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(borderRadius: AppRadius.rMD),
          ),
        ),
      ],
    );
  }
}

/// 6. AccountStatusWidget
class AccountStatusWidget extends StatelessWidget {
  const AccountStatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const SecondaryCard(
      child: Row(
        children: [
          Icon(Icons.verified_user_outlined, color: AppColors.success),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'حالة الحساب: مفعل بالكامل',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                SizedBox(height: 2),
                Text(
                  'حساب مصنعك موثق رسمياً. يمكنك إرسال طلبات عروض أسعار بلا حدود.',
                  style: TextStyle(color: Colors.grey, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}




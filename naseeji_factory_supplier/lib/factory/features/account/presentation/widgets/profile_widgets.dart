// ignore_for_file: unnecessary_underscores

import 'package:flutter/material.dart';
import 'package:naseeji_factory/factory/core/constants/app_colors.dart';
import 'package:naseeji_factory/factory/core/constants/app_radius.dart';
import 'package:naseeji_factory/factory/core/extensions/context_extensions.dart';

import '../providers/account_provider.dart';
import 'account_reusable_widgets.dart';


// ─── Profile Header Widget ─────────────────────────────────────────────────
class ProfileHeaderWidget extends StatelessWidget {
  final FactoryProfileModel profile;
  final VoidCallback onEdit;

  const ProfileHeaderWidget({super.key, required this.profile, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Cover Image
        ClipRRect(
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(0)),
          child: Image.network(
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
        ),
        // Gradient overlay
        Container(
          height: 180,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.transparent, Colors.black.withValues(alpha: 0.4)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        // Edit cover button
        Positioned(
          top: 12,
          left: 12,
          child: GestureDetector(
            onTap: onEdit,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.4),
                borderRadius: AppRadius.rRound,
              ),
              child: const Row(
                children: [
                  Icon(Icons.edit_rounded, color: Colors.white, size: 14),
                  SizedBox(width: 4),
                  Text('تعديل', style: TextStyle(color: Colors.white, fontSize: 11)),
                ],
              ),
            ),
          ),
        ),
        // Logo & info positioned at the bottom
        Positioned(
          bottom: -50,
          right: 16,
          left: 16,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Stack(
                children: [
                  Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      color: Colors.white,
                    ),
                    child: ClipOval(
                      child: Image.network(
                        profile.logoUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          child: const Icon(Icons.factory_rounded, color: AppColors.primary, size: 42),
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
                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        child: const Icon(Icons.verified_rounded, color: AppColors.info, size: 18),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SubscriptionBadge(plan: profile.subscriptionPlan),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: profile.isAccountActive
                              ? AppColors.success.withValues(alpha: 0.15)
                              : AppColors.error.withValues(alpha: 0.15),
                          borderRadius: AppRadius.rRound,
                        ),
                        child: Text(
                          profile.isAccountActive ? 'الحساب نشط' : 'الحساب موقوف',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: profile.isAccountActive ? AppColors.success : AppColors.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Factory Summary Widget ────────────────────────────────────────────────
class FactorySummaryWidget extends StatelessWidget {
  final FactoryProfileModel profile;
  const FactorySummaryWidget({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.rMD,
        side: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              profile.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 6),
            Text(profile.description, style: const TextStyle(fontSize: 12, height: 1.5, color: Colors.grey)),
            const Divider(height: 20),
            _row('تأسس عام', profile.establishedYear),
            _row('الصناعة', profile.industry),
            _row('نوع المصنع', profile.factoryType),
            _row('طاقة إنتاجية', profile.productionCapacity),
            _row('عدد الموظفين', '${profile.employeeCount} موظف'),
            _row('أدنى كمية طلب', '${profile.minOrderQuantity} وحدة'),
            _row('أسواق مخدومة', profile.marketsServed.join(' • ')),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Company Information Widget ────────────────────────────────────────────
class CompanyInformationWidget extends StatelessWidget {
  final FactoryProfileModel profile;
  const CompanyInformationWidget({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.rMD,
        side: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('بيانات الشركة القانونية',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary)),
            const SizedBox(height: 12),
            InformationCard(icon: Icons.description_rounded, label: 'السجل التجاري', value: profile.commercialRegNo),
            InformationCard(icon: Icons.receipt_long_rounded, label: 'البطاقة الضريبية', value: profile.taxCardNo),
            InformationCard(icon: Icons.location_city_rounded, label: 'المحافظة / المدينة', value: '${profile.country} — ${profile.city}'),
            InformationCard(icon: Icons.place_rounded, label: 'العنوان الكامل', value: profile.address),
          ],
        ),
      ),
    );
  }
}

// ─── Contact Information Widget ────────────────────────────────────────────
class ContactInformationWidget extends StatelessWidget {
  final FactoryProfileModel profile;
  const ContactInformationWidget({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.rMD,
        side: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('بيانات التواصل',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary)),
            const SizedBox(height: 12),
            InformationCard(icon: Icons.phone_rounded, label: 'رقم الهاتف', value: profile.phone),
            InformationCard(icon: Icons.email_rounded, label: 'البريد الإلكتروني', value: profile.email),
            InformationCard(icon: Icons.language_rounded, label: 'الموقع الإلكتروني', value: profile.website),
          ],
        ),
      ),
    );
  }
}

// ─── Factory Statistics Widget ─────────────────────────────────────────────
class FactoryStatisticsWidget extends StatelessWidget {
  const FactoryStatisticsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('إحصائيات المصنع',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary)),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 3,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          children: const [
            StatisticCard(icon: Icons.pending_rounded, value: '١٢', label: 'طلبات نشطة', color: AppColors.info),
            StatisticCard(icon: Icons.check_circle_rounded, value: '٤٨', label: 'طلبات مكتملة', color: AppColors.success),
            StatisticCard(icon: Icons.favorite_rounded, value: '٢٣', label: 'موردون مفضلون', color: Colors.red),
            StatisticCard(icon: Icons.request_quote_rounded, value: '٧', label: 'عروض مفتوحة', color: AppColors.warning),
            StatisticCard(icon: Icons.attach_money_rounded, value: '٢.٥م', label: 'مشتريات الشهر', color: AppColors.secondary),
            StatisticCard(icon: Icons.people_rounded, value: '٥', label: 'الموظفون', color: AppColors.primaryDark),
          ],
        ),
      ],
    );
  }
}

// ─── Subscription Card Widget ──────────────────────────────────────────────
class SubscriptionCardWidget extends StatelessWidget {
  final FactoryProfileModel profile;
  final VoidCallback onUpgrade;

  const SubscriptionCardWidget({super.key, required this.profile, required this.onUpgrade});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7C3AED), Color(0xFF4F46E5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppRadius.rMD,
      ),
      child: Row(
        children: [
          const Icon(Icons.workspace_premium_rounded, color: Colors.white, size: 36),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('اشتراك PRO', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                Text(
                  'ينتهي في ${profile.subscriptionExpiry}',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 11),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: onUpgrade,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF7C3AED),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: AppRadius.rSM),
              elevation: 0,
            ),
            child: const Text('ترقية', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

// ─── Quick Actions Widget ──────────────────────────────────────────────────
class QuickActionsWidget extends StatelessWidget {
  final VoidCallback onEditProfile;
  final VoidCallback onShareProfile;
  final VoidCallback onGenerateQR;

  const QuickActionsWidget({
    super.key,
    required this.onEditProfile,
    required this.onShareProfile,
    required this.onGenerateQR,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _actionBtn(Icons.edit_rounded, 'تعديل', AppColors.primary, onEditProfile)),
        const SizedBox(width: 10),
        Expanded(child: _actionBtn(Icons.share_rounded, 'مشاركة', AppColors.info, onShareProfile)),
        const SizedBox(width: 10),
        Expanded(child: _actionBtn(Icons.qr_code_rounded, 'QR Code', AppColors.success, onGenerateQR)),
      ],
    );
  }

  Widget _actionBtn(IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: AppRadius.rSM,
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 6),
            Text(label, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

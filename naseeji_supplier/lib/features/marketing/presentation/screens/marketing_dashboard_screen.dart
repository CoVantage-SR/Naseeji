import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import 'package:naseeji_supplier/core/widgets/app_bottom_navigation_bar.dart';
import '../controllers/marketing_controllers.dart';
import '../widgets/marketing_summary_card.dart';
import '../../domain/entities/marketing_models.dart';

class MarketingDashboardScreen extends ConsumerWidget {
  const MarketingDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(marketingDashboardControllerProvider);
    final adsAsync = ref.watch(marketingAdvertisementsControllerProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          title: const Text(
            'التسويق والإعلانات B2B',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.onSurface),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.onSurface),
            onPressed: () => context.go('/home'),
          ),
        ),
        body: Material(
          color: const Color(0xFFF8F9FF),
          child: dashboardAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('حدث خطأ: $err')),
            data: (stats) => RefreshIndicator(
              onRefresh: () => ref.read(marketingDashboardControllerProvider.notifier).refresh(),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Top Summary Row 1
                    Row(
                      children: [
                        Expanded(
                          child: MarketingSummaryCard(
                            title: 'عائد الإعلانات ROAS',
                            value: '${stats.roas.toStringAsFixed(1)}x',
                            trendText: '+2.4x هذا الشهر',
                            isPositiveTrend: true,
                            icon: Icons.trending_up,
                            iconColor: const Color(0xFF006B5F),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: MarketingSummaryCard(
                            title: 'الإيرادات الناتجة',
                            value: '${stats.revenueGenerated.toStringAsFixed(0)} ر.س',
                            trendText: '+12% عن الشهر الماضي',
                            isPositiveTrend: true,
                            icon: Icons.account_balance_wallet,
                            iconColor: const Color(0xFF0040E0),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Top Summary Row 2
                    Row(
                      children: [
                        Expanded(
                          child: MarketingSummaryCard(
                            title: 'نسبة النقر CTR',
                            value: '${stats.ctr.toStringAsFixed(2)}%',
                            trendText: '+0.45% منذ الأسبوع الماضي',
                            isPositiveTrend: true,
                            icon: Icons.ads_click,
                            iconColor: const Color(0xFFFF9800),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: MarketingSummaryCard(
                            title: 'الوصول الكلي (المصانع)',
                            value: '${stats.reach}',
                            trendText: 'نمو مستمر',
                            isPositiveTrend: true,
                            icon: Icons.people_outline,
                            iconColor: const Color(0xFF9C27B0),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Summary status indicators
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildMiniIndicator('الحملات النشطة', '${stats.runningCampaignsCount}'),
                          _buildVerticalDivider(),
                          _buildMiniIndicator('الإعلانات الجارية', '${stats.activeAdsCount}'),
                          _buildVerticalDivider(),
                          _buildMiniIndicator('قيد المراجعة', '${stats.pendingReviewCount}'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Quick Actions
                    const Text(
                      'الإجراءات السريعة',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 12),
                    GridView.count(
                      crossAxisCount: 3,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 1.1,
                      children: [
                        _buildQuickActionItem(
                          context,
                          icon: Icons.campaign_outlined,
                          label: 'إنشاء إعلان',
                          route: '/marketing/create-ad',
                        ),
                        _buildQuickActionItem(
                          context,
                          icon: Icons.playlist_add_circle_outlined,
                          label: 'حملة جديدة',
                          route: '/marketing/campaigns',
                        ),
                        _buildQuickActionItem(
                          context,
                          icon: Icons.star_border,
                          label: 'ترويج منتج',
                          route: '/marketing/featured',
                        ),
                        _buildQuickActionItem(
                          context,
                          icon: Icons.local_offer_outlined,
                          label: 'عرض ترويجي',
                          route: '/marketing/offers',
                        ),
                        _buildQuickActionItem(
                          context,
                          icon: Icons.card_giftcard,
                          label: 'كوبون خصم',
                          route: '/marketing/coupons',
                        ),
                        _buildQuickActionItem(
                          context,
                          icon: Icons.insights_outlined,
                          label: 'توصيات الذكاء',
                          route: '/marketing/insights',
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Navigation Sub-links (Targeting, Budget, Analytics, Notifications)
                    Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      clipBehavior: Clip.antiAlias,
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                        ),
                        title: const Text('المستهدفون الذكيون (Audience Targeting)', textAlign: TextAlign.right),
                        trailing: const Icon(Icons.arrow_back_ios, size: 14),
                        leading: const Icon(Icons.track_changes, color: Color(0xFF006B5F)),
                        onTap: () => context.push('/marketing/targeting'),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      clipBehavior: Clip.antiAlias,
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                        ),
                        title: const Text('تحليلات وتقارير التسويق', textAlign: TextAlign.right),
                        trailing: const Icon(Icons.arrow_back_ios, size: 14),
                        leading: const Icon(Icons.bar_chart, color: Color(0xFF0040E0)),
                        onTap: () => context.push('/marketing/analytics'),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      clipBehavior: Clip.antiAlias,
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                        ),
                        title: const Text('إدارة الميزانية الإعلانية', textAlign: TextAlign.right),
                        trailing: const Icon(Icons.arrow_back_ios, size: 14),
                        leading: const Icon(Icons.monetization_on_outlined, color: Color(0xFFFF9800)),
                        onTap: () => context.push('/marketing/budget'),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      clipBehavior: Clip.antiAlias,
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                        ),
                        title: const Text('إرسال إشعارات وعروض للمصانع', textAlign: TextAlign.right),
                        trailing: const Icon(Icons.arrow_back_ios, size: 14),
                        leading: const Icon(Icons.notifications_active_outlined, color: Color(0xFFE91E63)),
                        onTap: () => context.push('/marketing/notifications'),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      clipBehavior: Clip.antiAlias,
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                        ),
                        title: const Text('المنتجات المدعومة (Sponsored Products)', textAlign: TextAlign.right),
                        trailing: const Icon(Icons.arrow_back_ios, size: 14),
                        leading: const Icon(Icons.star_purple500, color: Color(0xFF9C27B0)),
                        onTap: () => context.push('/marketing/sponsored'),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Recent Activity list preview
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () => context.push('/marketing/ads'),
                          child: const Text('عرض الكل', style: TextStyle(fontSize: 12, color: Color(0xFF0040E0))),
                        ),
                        const Text(
                          'الإعلانات الجارية مؤخراً',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    adsAsync.when(
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (e, _) => Text('خطأ: $e'),
                      data: (ads) {
                        final active = ads.where((ad) => ad.status == AdStatus.active).take(3).toList();
                        if (active.isEmpty) {
                          return const Card(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text('لا توجد إعلانات نشطة حالياً.', textAlign: TextAlign.center),
                            ),
                          );
                        }
                        return Column(
                          children: active.map((ad) {
                            return Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: ListTile(
                                leading: const Icon(Icons.campaign, color: Color(0xFF0040E0)),
                                title: Text(ad.title, textAlign: TextAlign.right, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                subtitle: Text('النقرات: ${ad.clicks} | التحويلات: ${ad.orders}', textAlign: TextAlign.right, style: const TextStyle(fontSize: 10)),
                                trailing: const Icon(Icons.arrow_back_ios, size: 12),
                                onTap: () => context.push('/marketing/ads/${ad.id}', extra: ad),
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMiniIndicator(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 9, color: AppColors.onSurfaceVariant)),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      width: 1,
      height: 28,
      color: AppColors.outlineVariant,
    );
  }

  Widget _buildQuickActionItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String route,
  }) {
    return Card(
      elevation: 0.5,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: InkWell(
        onTap: () => context.push(route),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: const Color(0xFF0040E0), size: 22),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

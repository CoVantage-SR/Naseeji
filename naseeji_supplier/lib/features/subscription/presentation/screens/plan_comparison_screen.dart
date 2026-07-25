import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:naseeji_supplier/core/mock/mock_data.dart';
import '../controllers/subscription_controllers.dart';
import '../widgets/plan_comparison_widgets.dart';

class PlanComparisonScreen extends ConsumerWidget {
  const PlanComparisonScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch active subscription state for reactive updates
    ref.watch(activeSubscriptionControllerProvider);

    final currentSub = MockDatabase.getCurrentSubscription();
    final currentPlanName = currentSub.planName; // 'الباقة الاحترافية' or 'Starter' etc.

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAFB),
        body: SafeArea(
          child: Column(
            children: [
              // 1. Header Bar
              PlansHeader(
                onBack: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/subscription');
                  }
                },
              ),

              // Main Scrollable Body
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    children: [
                      // SECTION 1: Top 3 Plan Cards (Starter, Professional, Enterprise)
                      Row(
                        children: [
                          PlanCard(
                            title: 'الأساسية',
                            subtitle: 'لبداية أعمالك',
                            monthlyPrice: '29',
                            yearlyPrice: '290',
                            icon: Icons.star_border_rounded,
                            iconColor: const Color(0xFF16A34A),
                            isCurrent: currentPlanName.contains('الأساسية') || currentPlanName.contains('Starter'),
                            buttonText: (currentPlanName.contains('الأساسية') || currentPlanName.contains('Starter'))
                                ? 'الباقة الحالية'
                                : 'اختر الباقة',
                            buttonColor: (currentPlanName.contains('الأساسية') || currentPlanName.contains('Starter'))
                                ? const Color(0xFFDCFCE7)
                                : const Color(0xFFF0FDF4),
                            buttonTextColor: const Color(0xFF16A34A),
                            onPressed: () => _handlePlanSelect(context, ref, 'الأساسية', 29.0),
                          ),
                          const SizedBox(width: 8),
                          PlanCard(
                            title: 'الإحترافية',
                            subtitle: 'لنمو أعمالك',
                            monthlyPrice: '79',
                            yearlyPrice: '790',
                            icon: Icons.workspace_premium_rounded,
                            iconColor: const Color(0xFF9333EA),
                            isPopular: true,
                            isCurrent: currentPlanName.contains('الاحترافية') || currentPlanName.contains('Professional'),
                            buttonText: (currentPlanName.contains('الاحترافية') || currentPlanName.contains('Professional'))
                                ? 'الباقة الحالية'
                                : 'ترقية الباقة',
                            buttonColor: (currentPlanName.contains('الاحترافية') || currentPlanName.contains('Professional'))
                                ? const Color(0xFFF3E8FF)
                                : const Color(0xFF9333EA),
                            buttonTextColor: (currentPlanName.contains('الاحترافية') || currentPlanName.contains('Professional'))
                                ? const Color(0xFF9333EA)
                                : Colors.white,
                            onPressed: () => _handlePlanSelect(context, ref, 'الباقة الاحترافية', 79.0),
                          ),
                          const SizedBox(width: 8),
                          PlanCard(
                            title: 'المؤسسية',
                            subtitle: 'للمؤسسات الكبيرة',
                            monthlyPrice: '199',
                            yearlyPrice: '1990',
                            icon: Icons.crown_rounded,
                            iconColor: const Color(0xFFEA580C),
                            isCurrent: currentPlanName.contains('المؤسسية') || currentPlanName.contains('Enterprise'),
                            buttonText: (currentPlanName.contains('المؤسسية') || currentPlanName.contains('Enterprise'))
                                ? 'الباقة الحالية'
                                : 'ترقية الباقة',
                            buttonColor: const Color(0xFFFFF7ED),
                            buttonTextColor: const Color(0xFFEA580C),
                            onPressed: () => _handlePlanSelect(context, ref, 'الباقة المؤسسية', 199.0),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // SECTION 2: Feature Comparison Table
                      FeatureComparisonTable(
                        rows: const [
                          ComparisonRowData(
                            title: 'عدد المنتجات',
                            icon: Icons.inventory_2_outlined,
                            starterValue: '20 منتج',
                            professionalValue: '100 منتج',
                            enterpriseValue: 'غير محدود',
                          ),
                          ComparisonRowData(
                            title: 'عدد الصور لكل منتج',
                            icon: Icons.image_outlined,
                            starterValue: '5 صور',
                            professionalValue: '20 صورة',
                            enterpriseValue: '50 صورة',
                          ),
                          ComparisonRowData(
                            title: 'عدد الفيديوهات',
                            icon: Icons.videocam_outlined,
                            starterValue: '2 فيديو',
                            professionalValue: '10 فيديو',
                            enterpriseValue: 'غير محدود',
                          ),
                          ComparisonRowData(
                            title: 'ملفات PDF',
                            icon: Icons.picture_as_pdf_outlined,
                            starterValue: '5 ملفات',
                            professionalValue: '20 ملف',
                            enterpriseValue: 'غير محدود',
                          ),
                          ComparisonRowData(
                            title: 'أعضاء الفريق',
                            icon: Icons.people_outline_rounded,
                            starterValue: '2 عضو',
                            professionalValue: '10 أعضاء',
                            enterpriseValue: 'غير محدود',
                          ),
                          ComparisonRowData(
                            title: 'طلبات الأسعار (RFQ)',
                            icon: Icons.chat_bubble_outline_rounded,
                            starterValue: '50 طلب / شهر',
                            professionalValue: '200 طلب / شهر',
                            enterpriseValue: 'غير محدود',
                          ),
                          ComparisonRowData(
                            title: 'المنتجات المميزة',
                            icon: Icons.stars_rounded,
                            starterValue: '1 منتج',
                            professionalValue: '5 منتجات',
                            enterpriseValue: 'غير محدود',
                          ),
                          ComparisonRowData(
                            title: 'الإعلانات الممولة',
                            icon: Icons.campaign_outlined,
                            starterValue: false,
                            professionalValue: true,
                            enterpriseValue: true,
                          ),
                          ComparisonRowData(
                            title: 'التحليلات والتقارير',
                            icon: Icons.analytics_outlined,
                            starterValue: true,
                            professionalValue: true,
                            enterpriseValue: true,
                          ),
                          ComparisonRowData(
                            title: 'دعم فني',
                            icon: Icons.headset_mic_outlined,
                            starterValue: 'عبر البريد الإلكتروني',
                            professionalValue: 'دعم سريع',
                            enterpriseValue: 'مدير حساب مخصص',
                          ),
                          ComparisonRowData(
                            title: 'فترة تجربة مجانية',
                            icon: Icons.calendar_today_rounded,
                            starterValue: '7 أيام',
                            professionalValue: '14 يوم',
                            enterpriseValue: '30 يوم',
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // SECTION 3: Included Features Card ("جميع الباقات تشمل")
                      const IncludedFeaturesCard(),

                      const SizedBox(height: 24),

                      // SECTION 4: Bottom Action Section ("لست متأكداً؟")
                      BottomActionSection(
                        onStartTrial: () => _handlePlanSelect(context, ref, 'الباقة الاحترافية', 79.0),
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handlePlanSelect(BuildContext context, WidgetRef ref, String planName, double price) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.stars_rounded, color: Color(0xFF9333EA), size: 24),
                    const SizedBox(width: 8),
                    Text(
                      'تأكيد اختيار $planName',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'قيمة الاشتراك: \$$price شهرياً. سيتم فتح جميع مميزات الباقة فوراً.',
                  style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('إلغاء'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          // Update subscription in MockDatabase
                          MockDatabase.currentSubscription = MockDatabase.currentSubscription.copyWith(
                            planName: planName,
                            priceMonthly: price,
                            status: 'active',
                            isExpired: false,
                          );
                          ref.invalidate(activeSubscriptionControllerProvider);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('تمت الترقية إلى $planName بنجاح! 🎉'),
                              backgroundColor: const Color(0xFF16A34A),
                              duration: const Duration(seconds: 3),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF9333EA),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('تأكيد واشتراك', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

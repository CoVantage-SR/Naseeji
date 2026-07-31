import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:naseeji_factory/core/mock/mock_data.dart';
import 'package:naseeji_factory/core/mock/subscription_mock.dart';
import '../controllers/subscription_controllers.dart';

class SubscriptionManagementScreen extends ConsumerStatefulWidget {
  const SubscriptionManagementScreen({super.key});

  @override
  ConsumerState<SubscriptionManagementScreen> createState() =>
      _SubscriptionManagementScreenState();
}

class _SubscriptionManagementScreenState
    extends ConsumerState<SubscriptionManagementScreen> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _plansKey = GlobalKey();

  String _selectedPaymentMethod = 'creditCard'; // creditCard, bankTransfer, instaPay, wallet
  bool _isYearly = false;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToPlans() {
    final context = _plansKey.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch subscription state for reactive updates
    ref.watch(activeSubscriptionControllerProvider);

    final sub = MockDatabase.getCurrentSubscription();
    final isExpired = sub.isExpired;
    final isExpiringSoon = sub.remainingDays <= 7 && !isExpired;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF9FAFB),
        body: SafeArea(
          child: Column(
            children: [
              // 1. Top Header Bar
              _buildHeaderBar(context),

              // 2. Expired / Warning Banner
              if (isExpired)
                _buildWarningBanner(
                  title: 'تنبيه: اشتراكك منتهي حالياً!',
                  subtitle:
                      'تم قفل إضافة وتعديل المنتجات والميديا. تجديد الاشتراك يعيد تفعيل جميع المميزات فوراً.',
                  bgColor: const Color(0xFFFEF2F2),
                  borderColor: const Color(0xFFFCA5A5),
                  textColor: const Color(0xFF991B1B),
                  icon: Icons.error_outline_rounded,
                  buttonText: 'تجديد الاشتراك الآن',
                  onPressed: () => _showCheckoutModal(context, planName: 'الباقة الاحترافية', price: 79.0, action: 'renew'),
                )
              else if (isExpiringSoon)
                _buildWarningBanner(
                  title: 'اشتراكك ينتهي قريباً (${sub.remainingDays} أيام متبقية)',
                  subtitle:
                      'جدد اشتراكك الآن لتجنب انقطاع الخدمة والوصول إلى أ أدوات التسويق.',
                  bgColor: const Color(0xFFFFF7ED),
                  borderColor: const Color(0xFFFDBA74),
                  textColor: const Color(0xFF9A3412),
                  icon: Icons.access_time_filled_rounded,
                  buttonText: 'تجديد الاشتراك',
                  onPressed: () => _showCheckoutModal(context, planName: 'الباقة الاحترافية', price: 79.0, action: 'renew'),
                ),

              // Main Scrollable Body
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // SECTION 1: Subscription Summary & Current Plan Box
                      _buildSubscriptionSummaryBox(context, sub),

                      const SizedBox(height: 20),

                      // SECTION 2: Available Plans ("الباقات المتاحة")
                      Container(key: _plansKey, child: _buildAvailablePlansSection(context, sub)),

                      const SizedBox(height: 20),

                      // SECTION 3: Payment Methods ("طرق الدفع")
                      _buildPaymentMethodsSection(context),

                      const SizedBox(height: 20),

                      // SECTION 4: Saved Cards ("البطاقات المحفوظة")
                      _buildSavedCardsSection(context),

                      const SizedBox(height: 20),

                      // SECTION 5: Billing History / Transactions ("سجل المعاملات")
                      _buildBillingHistorySection(context),

                      const SizedBox(height: 20),

                      // SECTION 6: Support Banner ("تحتاج مساعدة؟")
                      _buildSupportBanner(context),

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

  // ---------------------------------------------------------------------------
  // 1. Top Header Bar
  // ---------------------------------------------------------------------------
  Widget _buildHeaderBar(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Right: Crown Icon + Title & Subtitle
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2D1B4E) : const Color(0xFFF3E8FF),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.workspace_premium_rounded,
                  color: isDark ? const Color(0xFFC084FC) : const Color(0xFF9333EA),
                  size: 22,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'الاشتراك',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF111827),
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'إدارة باقتك وطرق الدفع',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Left: Back Arrow
          IconButton(
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/profile');
              }
            },
            icon: Icon(
              Icons.arrow_forward_rounded,
              color: isDark ? Colors.white : const Color(0xFF111827),
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Warning Banner
  // ---------------------------------------------------------------------------
  Widget _buildWarningBanner({
    required String title,
    required String subtitle,
    required Color bgColor,
    required Color borderColor,
    required Color textColor,
    required IconData icon,
    required String buttonText,
    required VoidCallback onPressed,
  }) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Icon(icon, color: textColor, size: 24),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 10.5,
                    color: textColor.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: textColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(
              buttonText,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // SECTION 1: Subscription Summary Box (Matching Top Card in Image)
  // ---------------------------------------------------------------------------
  Widget _buildSubscriptionSummaryBox(BuildContext context, SubscriptionModel sub) {
    final remainingDays = sub.remainingDays;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 600;

          if (isNarrow) {
            return Column(
              children: [
                // Top Row: Circular Gauge & Current Plan
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Circular Gauge
                    _buildDaysRemainingGauge(context, remainingDays),
                    // Current Plan Box
                    _buildCurrentPlanInfo(context, sub),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Divider(height: 1, color: isDark ? const Color(0xFF334155) : const Color(0xFFF3F4F6)),
                ),
                // Usage Limits Progress List
                _buildUsageProgressList(context, sub),
              ],
            );
          }

          // Wide / Desktop layout
          return Row(
            children: [
              _buildDaysRemainingGauge(context, remainingDays),
              const SizedBox(width: 16),
              Expanded(child: _buildUsageProgressList(context, sub)),
              const SizedBox(width: 16),
              _buildCurrentPlanInfo(context, sub),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDaysRemainingGauge(BuildContext context, int days) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: 110,
      height: 110,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 100,
            height: 100,
            child: CircularProgressIndicator(
              value: (days / 30).clamp(0.0, 1.0),
              strokeWidth: 8,
              backgroundColor: isDark ? const Color(0xFF334155) : const Color(0xFFF3E8FF),
              valueColor: AlwaysStoppedAnimation<Color>(isDark ? const Color(0xFFC084FC) : const Color(0xFF9333EA)),
              strokeCap: StrokeCap.round,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$days',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF111827),
                  height: 1.0,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'يوماً متبقية',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'من أصل 30 يوم',
                style: TextStyle(
                  fontSize: 8.5,
                  color: isDark ? const Color(0xFF64748B) : const Color(0xFF9CA3AF),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUsageProgressList(BuildContext context, SubscriptionModel sub) {
    return Column(
      children: [
        _buildUsageMetricRow(context, 'عدد أعضاء الفريق', '10 / 10', Icons.group_outlined),
        const SizedBox(height: 8),
        _buildUsageMetricRow(context, 'عدد المنتجات', '${sub.productsUsed} / ${sub.productsLimit}', Icons.inventory_2_outlined),
        const SizedBox(height: 8),
        _buildUsageMetricRow(context, 'طلبات الأسعار شهرياً', '85 / 100', Icons.request_quote_outlined),
        const SizedBox(height: 8),
        _buildUsageMetricRow(context, 'المساحة التخزينية', '2.4 GB / 5 GB', Icons.cloud_outlined),
      ],
    );
  }

  Widget _buildUsageMetricRow(BuildContext context, String label, String value, IconData icon) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280)),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF4B5563)),
            ),
          ],
        ),
        Text(
          value,
          style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF111827)),
        ),
      ],
    );
  }

  Widget _buildCurrentPlanInfo(BuildContext context, SubscriptionModel sub) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'باقتك الحالية',
          style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280)),
        ),
        const SizedBox(height: 2),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF14532D) : const Color(0xFFDCFCE7),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(color: isDark ? const Color(0xFF4ADE80) : const Color(0xFF16A34A), shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'نشطة',
                    style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: isDark ? const Color(0xFF4ADE80) : const Color(0xFF16A34A)),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            Text(
              sub.planName.replaceAll(' (Professional)', ''),
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: isDark ? const Color(0xFFC084FC) : const Color(0xFF6D28D9),
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Text(
          'تجدد في 23 مايو 2025',
          style: TextStyle(fontSize: 9.5, color: isDark ? const Color(0xFF64748B) : const Color(0xFF9CA3AF)),
        ),
        const SizedBox(height: 8),
        // Emblem graphic & Change plan button
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2D1B4E) : const Color(0xFFF3E8FF),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.workspace_premium_rounded, color: isDark ? const Color(0xFFC084FC) : const Color(0xFF9333EA), size: 22),
            ),
          ],
        ),
        const SizedBox(height: 8),
        OutlinedButton(
          onPressed: _scrollToPlans,
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            side: BorderSide(color: isDark ? const Color(0xFFC084FC) : const Color(0xFFD8B4FE), width: 1.2),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: Text(
            'تغيير الباقة',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isDark ? const Color(0xFFC084FC) : const Color(0xFF9333EA)),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // SECTION 2: Available Plans ("الباقات المتاحة")
  // ---------------------------------------------------------------------------
  Widget _buildAvailablePlansSection(BuildContext context, SubscriptionModel currentSub) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'الباقات المتاحة',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF111827)),
            ),
            Row(
              children: [
                Text('شهري', style: TextStyle(fontSize: 11, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF4B5563))),
                Switch(
                  value: _isYearly,
                  activeTrackColor: isDark ? const Color(0xFFC084FC) : const Color(0xFF9333EA),
                  onChanged: (val) => setState(() => _isYearly = val),
                ),
                Text('سنوي (خصم 20%)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isDark ? const Color(0xFF4ADE80) : const Color(0xFF16A34A))),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),

        // 3 Cards Layout
        LayoutBuilder(
          builder: (context, constraints) {
            final isNarrow = constraints.maxWidth < 650;

            final cards = [
              _buildPlanCard(
                context,
                title: 'الباقة الأساسية',
                subtitle: 'لبداية أعمالك',
                icon: Icons.star_outline_rounded,
                iconColor: const Color(0xFF16A34A),
                price: _isYearly ? '\$290 / سنوياً' : '\$29 / شهر',
                buttonText: 'اختر الباقة',
                buttonStyle: _PlanButtonStyle.outlineGreen,
                features: const [
                  '2 أعضاء فريق',
                  '100 منتج',
                  '20 طلب سعر شهرياً',
                  '1 GB مساحة تخزينية',
                  'دعم فني عبر البريد',
                ],
                onPressed: () => _showCheckoutModal(context, planName: 'الباقة الأساسية', price: _isYearly ? 290 : 29, action: 'downgrade'),
              ),
              _buildPlanCard(
                context,
                title: 'الباقة الاحترافية',
                subtitle: 'لنمو أعمالك',
                icon: Icons.workspace_premium_rounded,
                iconColor: const Color(0xFF9333EA),
                price: _isYearly ? '\$790 / سنوياً' : '\$79 / شهر',
                buttonText: 'باقتك الحالية',
                buttonStyle: _PlanButtonStyle.solidCurrent,
                badgeText: 'الأكثر إختياراً',
                isCurrent: true,
                features: const [
                  '10 أعضاء فريق',
                  '300 منتج',
                  '100 طلب سعر شهرياً',
                  '5 GB مساحة تخزينية',
                  'دعم فني أولوي',
                ],
                onPressed: null,
              ),
              _buildPlanCard(
                context,
                title: 'الباقة المؤسسية',
                subtitle: 'للمؤسسات الكبيرة',
                icon: Icons.corporate_fare_rounded,
                iconColor: const Color(0xFFEA580C),
                price: _isYearly ? '\$1990 / سنوياً' : '\$199 / شهر',
                buttonText: 'ترقية الآن',
                buttonStyle: _PlanButtonStyle.outlineOrange,
                features: const [
                  'عدد غير محدود من الأعضاء',
                  'عدد غير محدود من المنتجات',
                  'طلبات سعر غير محدودة',
                  'مساحة تخزينية غير محدودة',
                  'مدير حساب مخصص',
                ],
                onPressed: () => _showCheckoutModal(context, planName: 'الباقة المؤسسية (Enterprise)', price: _isYearly ? 1990 : 199, action: 'upgrade'),
              ),
            ];

            if (isNarrow) {
              return Column(
                children: cards.map((c) => Padding(padding: const EdgeInsets.only(bottom: 12), child: c)).toList(),
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: cards.map((c) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4), child: c))).toList(),
            );
          },
        ),

        const SizedBox(height: 10),

        // Comparison link
        Center(
          child: TextButton.icon(
            onPressed: () => context.push('/subscription/comparison'),
            icon: Icon(Icons.scale_rounded, size: 16, color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB)),
            label: Text(
              'مقارنة تفصيلية للمميزات والباقات',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlanCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required String price,
    required String buttonText,
    required _PlanButtonStyle buttonStyle,
    required List<String> features,
    String? badgeText,
    bool isCurrent = false,
    VoidCallback? onPressed,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isCurrent
            ? (isDark ? const Color(0xFF2D1B4E) : const Color(0xFFFAF5FF))
            : (isDark ? const Color(0xFF1E293B) : Colors.white),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isCurrent ? const Color(0xFFC084FC) : (isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB)),
          width: isCurrent ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top Badge
          if (badgeText != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 4),
              decoration: const BoxDecoration(
                color: Color(0xFF9333EA),
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Text(
                badgeText,
                style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),

          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, size: 18, color: iconColor),
                    const SizedBox(width: 6),
                    Text(title, style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF111827))),
                  ],
                ),
                const SizedBox(height: 2),
                Text(subtitle, style: TextStyle(fontSize: 10, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280))),
                const SizedBox(height: 10),

                // Price
                Text(
                  price,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF111827)),
                ),
                const SizedBox(height: 12),

                // Action Button
                SizedBox(
                  width: double.infinity,
                  height: 38,
                  child: _buildPlanButton(context, buttonText, buttonStyle, onPressed),
                ),
                const SizedBox(height: 14),

                // Features
                ...features.map((f) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle_rounded, size: 14, color: isDark ? const Color(0xFF4ADE80) : const Color(0xFF16A34A)),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              f,
                              style: TextStyle(fontSize: 10.5, color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF374151), fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanButton(BuildContext context, String text, _PlanButtonStyle style, VoidCallback? onPressed) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    switch (style) {
      case _PlanButtonStyle.solidCurrent:
        return Container(
          decoration: BoxDecoration(color: isDark ? const Color(0xFF3B0764) : const Color(0xFFDDD6FE), borderRadius: BorderRadius.circular(10)),
          alignment: Alignment.center,
          child: Text(text, style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: isDark ? const Color(0xFFF3E8FF) : const Color(0xFF6D28D9))),
        );
      case _PlanButtonStyle.outlineGreen:
        return OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: isDark ? const Color(0xFF4ADE80) : const Color(0xFF86EFAC), width: 1.2),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: Text(text, style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: isDark ? const Color(0xFF4ADE80) : const Color(0xFF16A34A))),
        );
      case _PlanButtonStyle.outlineOrange:
        return OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: isDark ? const Color(0xFFFB923C) : const Color(0xFFFDBA74), width: 1.2),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: Text(text, style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: isDark ? const Color(0xFFFB923C) : const Color(0xFFEA580C))),
        );
    }
  }

  // ---------------------------------------------------------------------------
  // SECTION 3: Payment Methods ("طرق الدفع")
  // ---------------------------------------------------------------------------
  Widget _buildPaymentMethodsSection(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final methods = [
      {
        'id': 'creditCard',
        'title': 'بطاقة ائتمانية',
        'subtitle': 'Visa, MasterCard',
        'icon': Icons.credit_card_rounded,
      },
      {
        'id': 'bankTransfer',
        'title': 'تحويل بنكي',
        'subtitle': 'تحويل مباشر',
        'icon': Icons.account_balance_rounded,
      },
      {
        'id': 'instaPay',
        'title': 'إنستاباي',
        'subtitle': 'محفظة إلكترونية',
        'icon': Icons.flash_on_rounded,
      },
      {
        'id': 'wallet',
        'title': 'محفظة إلكترونية',
        'subtitle': 'فودافون كاش، أورنج كاش',
        'icon': Icons.account_balance_wallet_rounded,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'طرق الدفع',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF111827)),
        ),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2.3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: methods.length,
          itemBuilder: (context, index) {
            final m = methods[index];
            final id = m['id'] as String;
            final isSelected = _selectedPaymentMethod == id;

            return InkWell(
              onTap: () => setState(() => _selectedPaymentMethod = id),
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (isDark ? const Color(0xFF2D1B4E) : const Color(0xFFFAF5FF))
                      : (isDark ? const Color(0xFF1E293B) : Colors.white),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected ? const Color(0xFFC084FC) : (isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB)),
                    width: isSelected ? 1.8 : 1.0,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected ? const Color(0xFF9333EA) : Colors.transparent,
                        border: isSelected ? null : Border.all(color: isDark ? const Color(0xFF64748B) : const Color(0xFF9CA3AF)),
                      ),
                      child: isSelected ? const Icon(Icons.check_rounded, size: 12, color: Colors.white) : null,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            m['title'] as String,
                            style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF111827)),
                          ),
                          Text(
                            m['subtitle'] as String,
                            style: TextStyle(fontSize: 9.5, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280)),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Icon(m['icon'] as IconData, size: 20, color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB)),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // SECTION 4: Saved Cards ("البطاقات المحفوظة")
  // ---------------------------------------------------------------------------
  Widget _buildSavedCardsSection(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'البطاقات المحفوظة',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF111827)),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.chevron_left_rounded, size: 20, color: isDark ? const Color(0xFF64748B) : const Color(0xFF9CA3AF)),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Text('•••• •••• •••• 4242', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF111827))),
                          const SizedBox(width: 8),
                          const Icon(Icons.payment_rounded, color: Color(0xFFEA580C), size: 18),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text('تنتهي في 12 / 26', style: TextStyle(fontSize: 9.5, color: isDark ? const Color(0xFF64748B) : const Color(0xFF9CA3AF))),
                          const SizedBox(width: 6),
                          Text('الافتراضية', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: isDark ? const Color(0xFF4ADE80) : const Color(0xFF16A34A))),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        TextButton.icon(
          onPressed: () => _showAddCardBottomSheet(context),
          icon: Icon(Icons.add_rounded, size: 16, color: isDark ? const Color(0xFFC084FC) : const Color(0xFF9333EA)),
          label: Text(
            'إضافة بطاقة جديدة',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? const Color(0xFFC084FC) : const Color(0xFF9333EA)),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // SECTION 5: Billing History / Transactions ("سجل المعاملات")
  // ---------------------------------------------------------------------------
  Widget _buildBillingHistorySection(BuildContext context) {
    final invoices = MockDatabase.subscriptionInvoices;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'سجل المعاملات',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF111827)),
        ),
        const SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: invoices.length,
          itemBuilder: (context, index) {
            final inv = invoices[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB)),
              ),
              child: Row(
                children: [
                  Icon(Icons.chevron_left_rounded, size: 18, color: isDark ? const Color(0xFF64748B) : const Color(0xFF9CA3AF)),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${inv.invoiceDate.day}/${inv.invoiceDate.month}/${inv.invoiceDate.year} 10:30 ص',
                        style: TextStyle(fontSize: 9.5, color: isDark ? const Color(0xFF64748B) : const Color(0xFF9CA3AF)),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            'تم الدفع بنجاح',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isDark ? const Color(0xFF4ADE80) : const Color(0xFF16A34A)),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '\$${inv.amount.toStringAsFixed(2)}',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? const Color(0xFF4ADE80) : const Color(0xFF16A34A)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'تجديد ${inv.planName}',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF111827)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'بطاقة ائتمانية • 4242',
                          style: TextStyle(fontSize: 10, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(color: isDark ? const Color(0xFF334155) : const Color(0xFFF3F4F6), shape: BoxShape.circle),
                    child: Icon(Icons.receipt_long_rounded, size: 18, color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF4B5563)),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // SECTION 6: Support Banner ("تحتاج مساعدة؟")
  // ---------------------------------------------------------------------------
  Widget _buildSupportBanner(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2D1B4E) : const Color(0xFFF5F3FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? const Color(0xFF581C87) : const Color(0xFFDDD6FE)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: isDark ? const Color(0xFF3B0764) : const Color(0xFFF3E8FF), shape: BoxShape.circle),
            child: Icon(Icons.headset_mic_rounded, color: isDark ? const Color(0xFFC084FC) : const Color(0xFF9333EA), size: 20),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'تحتاج مساعدة؟',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
                ),
                SizedBox(height: 2),
                Text(
                  'تواصل معنا في أي وقت وسنكون سعداء لمساعدتك',
                  style: TextStyle(fontSize: 10.5, color: Color(0xFF6B7280)),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => context.push('/messages/support'),
            child: const Text('تواصل معنا', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF9333EA))),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Checkout Modal Sheet (Payment Workflow)
  // ---------------------------------------------------------------------------
  void _showCheckoutModal(BuildContext context, {required String planName, required double price, required String action}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      action == 'renew' ? 'تأكيد تجديد الاشتراك' : 'مراجعة وتأكيد الاشتراك',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const Divider(height: 1),
                const SizedBox(height: 14),

                // Order summary
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('\$$price.00', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF16A34A))),
                      Text(planName, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                    ],
                  ),
                ),

                const SizedBox(height: 14),
                const Text('وسيلة الدفع المختارة:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF374151))),
                const SizedBox(height: 6),
                const Row(
                  children: [
                    Icon(Icons.credit_card_rounded, color: Color(0xFF2563EB), size: 18),
                    SizedBox(width: 8),
                    Text('بطاقة ائتمانية (Visa / MasterCard •••• 4242)', style: TextStyle(fontSize: 12, color: Color(0xFF111827))),
                  ],
                ),

                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _processPayment(planName, price, action);
                    },
                    icon: const Icon(Icons.lock_outline_rounded, color: Colors.white, size: 18),
                    label: const Text('تأكيد وإتمام الدفع', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9333EA),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _processPayment(String planName, double price, String action) {
    if (action == 'renew') {
      MockDatabase.renewSubscription();
    } else {
      MockDatabase.upgradeSubscriptionPlan(
        SubscriptionPlanMock(
          id: 'plan_${DateTime.now().millisecondsSinceEpoch}',
          name: planName,
          type: SubscriptionPlanType.professional,
          pricePerMonth: price,
          pricePerYear: price * 10,
          productsLimit: 300,
          imagesPerProduct: 10,
          videosPerProduct: 3,
          pdfPerProduct: 5,
          employeeLimit: 10,
          analyticsEnabled: true,
          prioritySupport: true,
          description: 'تم التحديث بنجاح',
        ),
      );
    }

    // Invalidate Riverpod controller for immediate reactive refresh
    ref.invalidate(activeSubscriptionControllerProvider);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم إتمام عملية الدفع وتحديث الاشتراك لـ ($planName) بنجاح!'),
        backgroundColor: const Color(0xFF16A34A),
      ),
    );
  }

  void _showAddCardBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 16, top: 16, left: 16, right: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('إضافة بطاقة ائتمانية جديدة', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              TextField(decoration: InputDecoration(hintText: 'رقم البطاقة (16 رقم)', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: TextField(decoration: InputDecoration(hintText: 'MM/YY', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))))),
                  const SizedBox(width: 10),
                  Expanded(child: TextField(decoration: InputDecoration(hintText: 'CVV', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))))),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم إضافة البطاقة بنجاح')));
                  },
                  child: const Text('حفظ البطاقة'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum _PlanButtonStyle {
  solidCurrent,
  outlineGreen,
  outlineOrange,
}



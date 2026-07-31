import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/reusable_widgets.dart';

/// 1. HomeAppBarWidget
class HomeAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String factoryName;
  final String logoUrl;
  final int notificationCount;
  final VoidCallback onNotificationTap;
  final VoidCallback onAvatarTap;

  const HomeAppBarWidget({
    super.key,
    required this.factoryName,
    required this.logoUrl,
    required this.notificationCount,
    required this.onNotificationTap,
    required this.onAvatarTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Builder(
        builder: (context) {
          return IconButton(
            icon: const Icon(Icons.menu_rounded, color: AppColors.primary),
            onPressed: () => Scaffold.of(context).openDrawer(),
          );
        },
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.blur_on_rounded, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 8),
          Text(
            factoryName,
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      actions: [
        NotificationBadge(
          count: notificationCount,
          child: IconButton(
            icon: const Icon(Icons.notifications_none_rounded, color: AppColors.primary),
            onPressed: onNotificationTap,
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: onAvatarTap,
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: SupplierAvatar(name: factoryName, size: 36),
          ),
        ),
      ],
      elevation: 0,
      scrolledUnderElevation: 1,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// 2. GreetingCardWidget
class GreetingCardWidget extends StatelessWidget {
  final String factoryName;

  const GreetingCardWidget({super.key, required this.factoryName});

  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    final greeting = hour < 12 ? 'صباح الخير 👋' : 'مساء الخير 👋';
    final isDark = context.theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [AppColors.surfaceDark, AppColors.borderDark]
              : [AppColors.primary.withValues(alpha: 0.08), AppColors.primary.withValues(alpha: 0.02)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: AppRadius.rLG,
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.primary.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            greeting,
            style: context.textTheme.bodySmall?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            factoryName,
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6.0),
          Text(
            'مرحباً بك في لوحة تحكم نسيجي. تابع عمليات التوريد والإنتاج الخاصة بمصنعك اليوم.',
            style: context.textTheme.bodySmall?.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }
}

/// 3. FactorySummaryCardWidget
class FactorySummaryCardWidget extends ConsumerWidget {
  final Map<String, dynamic> stats;

  const FactorySummaryCardWidget({super.key, required this.stats});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeOrders = stats['active_orders']?.toString() ?? '٠';
    final completedOrders = stats['completed_orders']?.toString() ?? '٠';
    final newRfqs = stats['new_rfqs']?.toString() ?? '٠';
    final shippingOrders = stats['shipping_orders']?.toString() ?? '٠';

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: context.responsiveValue(mobile: 2, tablet: 4).toInt(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: context.responsiveValue(mobile: 1.35, tablet: 1.4),
      children: [
        StatisticsCard(
          label: 'طلبات نشطة',
          value: activeOrders,
          icon: Icons.receipt_long_outlined,
          color: AppColors.primary,
          onTap: () => checkGuestAction(context, ref, () => context.go('/orders')),
        ),
        StatisticsCard(
          label: 'طلبات مكتملة',
          value: completedOrders,
          icon: Icons.check_circle_outline_rounded,
          color: AppColors.success,
          onTap: () => checkGuestAction(context, ref, () => context.go('/orders')),
        ),
        StatisticsCard(
          label: 'عروض أسعار جديدة',
          value: newRfqs,
          icon: Icons.request_quote_outlined,
          color: AppColors.secondary,
          onTap: () => checkGuestAction(context, ref, () => context.go('/rfq')),
        ),
        StatisticsCard(
          label: 'طلبات قيد الشحن',
          value: shippingOrders,
          icon: Icons.local_shipping_outlined,
          color: AppColors.info,
          onTap: () => checkGuestAction(context, ref, () => context.go('/orders')),
        ),
      ],
    );
  }
}

/// 4. QuickActionsWidget
class QuickActionsWidget extends StatelessWidget {
  const QuickActionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'إجراءات سريعة'),
        AppSpacing.hMD,
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: context.responsiveValue(mobile: 2, tablet: 4).toInt(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: context.responsiveValue(mobile: 1.35, tablet: 1.4),
          children: [
            QuickActionButtonWidget(
              title: 'إرسال طلب عرض سعر',
              icon: Icons.add_circle_outline_rounded,
              color: AppColors.primary,
              onTap: () => context.push('/rfq'),
            ),
            QuickActionButtonWidget(
              title: 'البحث عن مورد',
              icon: Icons.search_rounded,
              color: AppColors.secondary,
              onTap: () => context.push('/search?type=suppliers'),
            ),
            QuickActionButtonWidget(
              title: 'متابعة الطلبات',
              icon: Icons.receipt_long_outlined,
              color: AppColors.info,
              onTap: () => context.push('/orders'),
            ),
            QuickActionButtonWidget(
              title: 'الموردين المفضلين',
              icon: Icons.favorite_rounded,
              color: AppColors.success,
              onTap: () => context.push('/search?type=suppliers&favorites=true'),
            ),
          ],
        ),
      ],
    );
  }
}

/// 5. QuickActionButtonWidget
class QuickActionButtonWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const QuickActionButtonWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return QuickActionCard(
      title: title,
      icon: icon,
      color: color,
      onTap: onTap,
    );
  }
}

/// 6. StatisticsCardsWidget - Statistics section on dashboard
class StatisticsCardsWidget extends ConsumerWidget {
  const StatisticsCardsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Expanded(
          child: StatisticsCard(
            label: 'إجمالي المشتريات الشهرية',
            value: '٢٤٠,٠٠٠ ج.م',
            icon: Icons.payment_rounded,
            color: AppColors.primary,
            trendText: '+١٢%',
            trendPositive: true,
            onTap: () => checkGuestAction(context, ref, () => context.push('/statistics')),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: StatisticsCard(
            label: 'متوسط قيمة الطلبات',
            value: '١٨,٥٠٠ ج.م',
            icon: Icons.analytics_outlined,
            color: AppColors.secondary,
            trendText: '-٥%',
            trendPositive: false,
            onTap: () => checkGuestAction(context, ref, () => context.push('/statistics')),
          ),
        ),
      ],
    );
  }
}

/// 7. LatestRFQWidget
class LatestRFQWidget extends StatelessWidget {
  final List<Map<String, dynamic>> rfqs;
  final VoidCallback onActionTap;

  const LatestRFQWidget({
    super.key,
    required this.rfqs,
    required this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'آخر عروض الأسعار',
          onActionTap: onActionTap,
        ),
        AppSpacing.hMD,
        if (rfqs.isEmpty)
          const SecondaryCard(
            child: Text(
              'لا توجد عروض أسعار جديدة حالياً.',
              textAlign: TextAlign.center,
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: rfqs.length,
            separatorBuilder: (context, index) => AppSpacing.hMD,
            itemBuilder: (context, index) {
              final rfq = rfqs[index];
              return LatestRFQCardWidget(rfq: rfq);
            },
          ),
      ],
    );
  }
}

/// 8. LatestRFQCardWidget
class LatestRFQCardWidget extends ConsumerWidget {
  final Map<String, dynamic> rfq;

  const LatestRFQCardWidget({super.key, required this.rfq});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.theme.brightness == Brightness.dark;
    final String supplierName = rfq['supplier_name'] ?? 'مورد غير معروف';
    final String price = rfq['price'] ?? 'غير محدد';
    final String duration = rfq['duration'] ?? 'غير محدد';
    final String status = rfq['status'] ?? 'معلق';

    Color statusColor = AppColors.warning;
    if (status == 'مقبول') statusColor = AppColors.success;
    if (status == 'مرفوض') statusColor = AppColors.error;

    return PrimaryCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  supplierName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              StatusChip(label: status, color: statusColor),
            ],
          ),
          AppSpacing.hMD,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'السعر المقترح',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    price,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'مدة التجهيز',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    duration,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              OutlinedButton(
                onPressed: () {
                  checkGuestAction(
                    context,
                    ref,
                    () => context.push('/rfq/${rfq['id']}'),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.rSM),
                ),
                child: const Text('عرض التفاصيل'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 9. CurrentOrdersWidget
class CurrentOrdersWidget extends StatelessWidget {
  final List<Map<String, dynamic>> orders;
  final VoidCallback onActionTap;

  const CurrentOrdersWidget({
    super.key,
    required this.orders,
    required this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'الطلبات الحالية',
          onActionTap: onActionTap,
        ),
        AppSpacing.hMD,
        if (orders.isEmpty)
          const SecondaryCard(
            child: Text(
              'لا توجد طلبات جارية حالياً.',
              textAlign: TextAlign.center,
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: orders.length,
            separatorBuilder: (context, index) => AppSpacing.hMD,
            itemBuilder: (context, index) {
              final order = orders[index];
              return OrderCardWidget(order: order);
            },
          ),
      ],
    );
  }
}

/// 10. OrderCardWidget
class OrderCardWidget extends ConsumerWidget {
  final Map<String, dynamic> order;

  const OrderCardWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String orderId = order['id'] ?? 'ORD-0000';
    final String supplierName = order['supplier_name'] ?? 'مورد غير معروف';
    final String status = order['status'] ?? 'معلق';
    final double progress = order['progress'] ?? 0.0;
    final String expectedDelivery = order['expected_delivery'] ?? '';

    Color progressColor = AppColors.primary;
    if (status == 'قيد الشحن') progressColor = AppColors.info;
    if (status == 'تم التسليم') progressColor = AppColors.success;

    return ProgressCard(
      title: orderId,
      subtitle: supplierName,
      progress: progress,
      progressColor: progressColor,
      footerLeft: 'حالة الطلب: $status',
      footerRight: 'التسليم المتوقع: $expectedDelivery',
      onTap: () {
        checkGuestAction(
          context,
          ref,
          () => context.push('/orders/$orderId'),
        );
      },
    );
  }
}

/// 11. RecommendedSuppliersWidget
class RecommendedSuppliersWidget extends StatelessWidget {
  final List<Map<String, dynamic>> suppliers;
  final VoidCallback onActionTap;

  const RecommendedSuppliersWidget({
    super.key,
    required this.suppliers,
    required this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'موردين مقترحين',
          onActionTap: onActionTap,
        ),
        AppSpacing.hMD,
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: context.responsiveValue(mobile: 1, tablet: 2).toInt(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.1,
          ),
          itemCount: suppliers.length,
          itemBuilder: (context, index) {
            final supplier = suppliers[index];
            return SupplierCardWidget(supplier: supplier);
          },
        ),
      ],
    );
  }
}

/// 12. SupplierCardWidget
class SupplierCardWidget extends ConsumerWidget {
  final Map<String, dynamic> supplier;

  const SupplierCardWidget({super.key, required this.supplier});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.theme.brightness == Brightness.dark;
    final String id = supplier['id']?.toString() ?? 'sup_1';
    final String name = supplier['name']?.toString() ?? 'مورد غير معروف';
    final double rating = (supplier['rating'] as num?)?.toDouble() ?? 0.0;
    final String specialization = supplier['specialization']?.toString() ?? '';
    final String minOrder = supplier['min_order']?.toString() ?? '';

    return PrimaryCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SupplierAvatar(name: name, size: 56),
          AppSpacing.wMD,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                        const SizedBox(width: 2),
                        Text(
                          rating.toString(),
                          style: context.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  specialization,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
                AppSpacing.hSM,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'حد أدنى للطلب: $minOrder',
                      style: context.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        context.push('/suppliers/$id');
                      },
                      child: const Text(
                        'عرض الملف الشخصي',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 13. RecentActivityWidget
class RecentActivityWidget extends StatelessWidget {
  final List<Map<String, dynamic>> activities;

  const RecentActivityWidget({super.key, required this.activities});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'آخر النشاطات'),
        AppSpacing.hMD,
        if (activities.isEmpty)
          const SecondaryCard(
            child: Text(
              'لا توجد نشاطات حديثة.',
              textAlign: TextAlign.center,
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: activities.length,
            itemBuilder: (context, index) {
              final act = activities[index];
              final isLast = index == activities.length - 1;

              IconData icon = Icons.notifications_active_outlined;
              Color color = AppColors.primary;

              if (act['type'] == 'order_accepted') {
                icon = Icons.check_rounded;
                color = AppColors.success;
              } else if (act['type'] == 'shipment_started') {
                icon = Icons.local_shipping_outlined;
                color = AppColors.info;
              } else if (act['type'] == 'new_quotation') {
                icon = Icons.request_quote_outlined;
                color = AppColors.secondary;
              } else if (act['type'] == 'delivery_confirmed') {
                icon = Icons.done_all_rounded;
                color = AppColors.success;
              }

              return TimelineTile(
                title: act['title'] ?? '',
                description: act['description'] ?? '',
                time: act['time'] ?? '',
                icon: icon,
                color: color,
                isLast: isLast,
              );
            },
          ),
      ],
    );
  }
}

/// 14. BottomNavigationWidget - Standalone navigation preview
class BottomNavigationWidget extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavigationWidget({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard_rounded),
          label: 'الرئيسية',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_bag_outlined),
          label: 'المنتجات',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.request_quote_outlined),
          label: 'عروض الأسعار',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt_long_outlined),
          label: 'الطلبات',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline_rounded),
          label: 'حسابنا',
        ),
      ],
    );
  }
}



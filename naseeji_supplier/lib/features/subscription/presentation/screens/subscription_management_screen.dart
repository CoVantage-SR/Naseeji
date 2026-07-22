import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/subscription_models.dart';
import '../controllers/subscription_controllers.dart';
import '../widgets/plan_card.dart';
import '../widgets/subscription_card.dart';

class SubscriptionManagementScreen extends ConsumerStatefulWidget {
  const SubscriptionManagementScreen({super.key});

  @override
  ConsumerState<SubscriptionManagementScreen> createState() =>
      _SubscriptionManagementScreenState();
}

class _SubscriptionManagementScreenState
    extends ConsumerState<SubscriptionManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final subAsync = ref.watch(activeSubscriptionControllerProvider);
    final usageAsync = ref.watch(subscriptionUsageControllerProvider);
    final plansAsync = ref.watch(subscriptionPlansControllerProvider);
    final historyAsync = ref.watch(subscriptionHistoryControllerProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'إدارة اشتراك المورد',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.science_outlined),
              tooltip: 'شاشة تجربة القيود',
              onPressed: () => context.push('/subscription/test-demo'),
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'الباقة الحالية والباقات'),
              Tab(text: 'مقارنة المميزات'),
              Tab(text: 'سجل الاشتراكات'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            // Tab 1: Current Plan & All Plans
            subAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('خطأ: $e')),
              data: (sub) => usageAsync.when(
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('خطأ: $e')),
                data: (usage) => plansAsync.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text('خطأ: $e')),
                  data: (plans) => SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'اشتراكك الحالي',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        SubscriptionCard(
                          subscription: sub,
                          usage: usage,
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'جميع الباقات المتاحة',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () => _tabController.animateTo(1),
                              icon: const Icon(Icons.compare_arrows, size: 16),
                              label: const Text('مقارنة تفصيلية'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: plans.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 16),
                          itemBuilder: (ctx, index) {
                            final plan = plans[index];
                            final isCurrent = plan.id == sub.planId;
                            return PlanCard(
                              plan: plan,
                              isCurrentPlan: isCurrent,
                              onSelectPlan: () async {
                                await ref
                                    .read(
                                        activeSubscriptionControllerProvider
                                            .notifier)
                                    .upgrade(plan.id, BillingCycle.monthly);
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'تم تغيير الباقة إلى ${plan.name} بنجاح!'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                }
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Tab 2: Feature Comparison Matrix
            plansAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('خطأ: $e')),
              data: (plans) => SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: _FeatureComparisonTable(plans: plans),
              ),
            ),

            // Tab 3: Subscription History
            historyAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('خطأ: $e')),
              data: (history) => history.isEmpty
                  ? const Center(child: Text('لا يوجد سجل اشتراكات سابق.'))
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: history.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (ctx, index) {
                        final item = history[index];
                        final start =
                            '${item.startDate.day}/${item.startDate.month}/${item.startDate.year}';
                        final end =
                            '${item.endDate.day}/${item.endDate.month}/${item.endDate.year}';

                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: colorScheme.outlineVariant
                                  .withValues(alpha: 0.5),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      item.planName,
                                      style:
                                          theme.textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: item.status == 'نشط'
                                            ? Colors.green.shade50
                                            : Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        item.status,
                                        style: TextStyle(
                                          color: item.status == 'نشط'
                                              ? Colors.green.shade800
                                              : Colors.grey.shade700,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'تاريخ البداية: $start',
                                      style: theme.textTheme.bodySmall,
                                    ),
                                    Text(
                                      'تاريخ النهاية: $end',
                                      style: theme.textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'المبلغ: ${item.price == 0 ? 'مجاناً' : '${item.price.toInt()} ر.س'}',
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: colorScheme.primary,
                                      ),
                                    ),
                                    Text(
                                      'الفاتورة: ${item.invoiceNumber}',
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureComparisonTable extends StatelessWidget {
  final List<SubscriptionPlan> plans;

  const _FeatureComparisonTable({required this.plans});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    String formatLimit(int val, [String unit = '']) {
      if (val == -1) return 'غير محدود';
      return '$val $unit'.trim();
    }

    final rows = [
      {'feature': 'عدد المنتجات المتاحة', 'key': 'products'},
      {'feature': 'عدد الصور لكل منتج', 'key': 'images'},
      {'feature': 'فيديو للمنتج', 'key': 'video'},
      {'feature': 'ملفات PDF لكل منتج', 'key': 'pdf'},
      {'feature': 'عدد الإعلانات', 'key': 'ads'},
      {'feature': 'طلبات الأسعار (RFQ)', 'key': 'rfqs'},
      {'feature': 'المنتجات المميزة', 'key': 'featured'},
    ];

    return Table(
      border: TableBorder.all(
        color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      columnWidths: const {
        0: FlexColumnWidth(2.2),
        1: FlexColumnWidth(1.2),
        2: FlexColumnWidth(1.2),
        3: FlexColumnWidth(1.4),
        4: FlexColumnWidth(1.4),
      },
      children: [
        TableRow(
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
          ),
          children: [
            const Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                'الميزة / القيود',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
            ...plans.map(
              (p) => Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  p.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
            ),
          ],
        ),
        ...rows.map((row) {
          final key = row['key'];
          return TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  row['feature']!,
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                ),
              ),
              ...plans.map((p) {
                final l = p.limits;
                String display = '';
                if (key == 'products') display = formatLimit(l.maxProducts);
                if (key == 'images') display = formatLimit(l.maxImagesPerProduct, 'صور');
                if (key == 'video') {
                  display = l.maxVideosPerProduct == 0
                      ? 'غير متاح'
                      : formatLimit(l.maxVideosPerProduct, 'فيديو');
                }
                if (key == 'pdf') display = formatLimit(l.maxPdfsPerProduct, 'ملف');
                if (key == 'ads') display = formatLimit(l.maxAdvertisements);
                if (key == 'rfqs') display = formatLimit(l.maxMonthlyRfqs);
                if (key == 'featured') {
                  display = l.maxFeaturedProducts == 0
                      ? 'غير متاح'
                      : formatLimit(l.maxFeaturedProducts);
                }

                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    display,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10,
                      color: display == 'غير متاح' ? Colors.red : null,
                      fontWeight: display == 'غير محدود'
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                );
              }),
            ],
          );
        }),
      ],
    );
  }
}

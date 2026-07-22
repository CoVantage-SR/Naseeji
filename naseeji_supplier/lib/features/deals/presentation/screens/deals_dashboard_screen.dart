import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import 'package:naseeji_supplier/core/widgets/app_bottom_navigation_bar.dart';

import '../providers/deals_providers.dart';
import '../widgets/deals_dashboard_widget.dart';
import '../widgets/action_required_widget.dart';
import '../widgets/deal_card_widget.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/loading_widget.dart';

class DealsDashboardScreen extends ConsumerWidget {
  const DealsDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final dealsAsync = ref.watch(dealsProvider);
    final statusFilter = ref.watch(dealStatusFilterProvider);
    final searchQuery = ref.watch(dealSearchQueryProvider);
    final onlyActionRequired = ref.watch(onlyActionRequiredProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: colorScheme.surface,
          elevation: 0.5,
          centerTitle: true,
          title: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.handshake_rounded, size: 18, color: AppColors.primary),
              SizedBox(width: 6),
              Text(
                'نظام إدارة الصفقات B2B',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/home');
              }
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_alt_off_rounded, size: 20),
              tooltip: 'إلغاء الفلاتر',
              onPressed: () {
                ref.read(dealStatusFilterProvider.notifier).state = null;
                ref.read(dealSearchQueryProvider.notifier).state = '';
                ref.read(onlyActionRequiredProvider.notifier).state = false;
              },
            ),
          ],
        ),
        body: dealsAsync.when(
          loading: () => const LoadingWidget(),
          error: (err, _) => Center(
            child: Text('حدث خطأ أثناء تحميل الصفقات: $err', style: const TextStyle(color: Colors.red, fontSize: 11)),
          ),
          data: (deals) {
            final actionDeals = deals.where((d) => d.status.requiresSupplierAction).toList();

            return Column(
              children: [
                const SizedBox(height: 6),

                // 1. Action Required Section (العنصر الأهم)
                ActionRequiredWidget(actionDeals: actionDeals),

                // 2. Dashboard Status Cards (أجهزة القياس المصغرة)
                DealsDashboardWidget(
                  deals: deals,
                  activeFilter: statusFilter,
                  isOnlyActionRequired: onlyActionRequired,
                  onSelectFilter: (filterKey) {
                    ref.read(dealStatusFilterProvider.notifier).state = filterKey;
                  },
                  onToggleActionRequired: (val) {
                    ref.read(onlyActionRequiredProvider.notifier).state = val;
                  },
                ),
                const SizedBox(height: 6),

                // 3. Compact Search Bar Input
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: TextField(
                    onChanged: (val) {
                      ref.read(dealSearchQueryProvider.notifier).state = val;
                    },
                    style: const TextStyle(fontSize: 11.5),
                    decoration: InputDecoration(
                      hintText: 'ابحث برقم الصفقة، اسم المصنع، أو المنتج...',
                      hintStyle: TextStyle(fontSize: 11, color: colorScheme.outline),
                      prefixIcon: Icon(Icons.search_rounded, size: 18, color: colorScheme.primary),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      filled: true,
                      fillColor: colorScheme.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 6),

                // 4. Deals Cards List
                Expanded(
                  child: deals.isEmpty
                      ? EmptyStateWidget(
                          onResetFilter: () {
                            ref.read(dealStatusFilterProvider.notifier).state = null;
                            ref.read(dealSearchQueryProvider.notifier).state = '';
                            ref.read(onlyActionRequiredProvider.notifier).state = false;
                          },
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                          itemCount: deals.length,
                          itemBuilder: (context, index) {
                            return DealCardWidget(deal: deals[index]);
                          },
                        ),
                ),
              ],
            );
          },
        ),
        bottomNavigationBar: const Directionality(
          textDirection: TextDirection.ltr,
          child: AppBottomNavigationBar(currentIndex: 2), // Orders/Deals index
        ),
      ),
    );
  }
}

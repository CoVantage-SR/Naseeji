// ignore_for_file: unnecessary_underscores

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/deals_providers.dart';
import '../widgets/deals_dashboard_widget.dart';
import '../widgets/deal_filter_bar_widget.dart';
import '../widgets/deal_card_widget.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/loading_widget.dart';
import '../../../core/widgets/app_bottom_navigation_bar.dart';

class DealsDashboardScreen extends ConsumerWidget {
  const DealsDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dealsAsync = ref.watch(dealsProvider);
    final statusFilter = ref.watch(dealStatusFilterProvider);
    final searchQuery = ref.watch(dealSearchQueryProvider);
    final onlyActionRequired = ref.watch(onlyActionRequiredProvider);

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        bottomNavigationBar: const AppBottomNavigationBar(currentIndex: 2),
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              // 1. Top Custom App Bar Header (RTL)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Right Side: Shopping Bag Icon + Title & Subtitle
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFEFF6FF),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.local_mall_outlined,
                            color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB),
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'الصفقات',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : const Color(0xFF111827),
                                height: 1.1,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'إدارة جميع صفقاتك ومفاوضاتك',
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

                    // Left Side: Action Icons (Filter & Notifications with Badge 3)
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            ref.read(dealStatusFilterProvider.notifier).state = null;
                            ref.read(dealSearchQueryProvider.notifier).state = '';
                            ref.read(onlyActionRequiredProvider.notifier).state = false;
                          },
                          icon: Icon(
                            Icons.filter_list_rounded,
                            color: isDark ? Colors.white : const Color(0xFF4B5563),
                            size: 24,
                          ),
                        ),
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            IconButton(
                              onPressed: () {
                                context.push('/notifications');
                              },
                              icon: Icon(
                                Icons.notifications_none_rounded,
                                color: isDark ? Colors.white : const Color(0xFF4B5563),
                                size: 24,
                              ),
                            ),
                            Positioned(
                              top: 6,
                              right: 6,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFEF4444),
                                  shape: BoxShape.circle,
                                ),
                                child: const Text(
                                  '3',
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    height: 1.0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // 2. Filter Pills Horizontal Tab Bar
              DealFilterBarWidget(
                selectedStatus: statusFilter,
                onStatusChanged: (val) {
                  ref.read(dealStatusFilterProvider.notifier).state = val;
                },
              ),
              const SizedBox(height: 12),

              // 3. 5 Summary Statistics Cards (51 / 8 / 12 / 7 / 24)
              dealsAsync.when(
                data: (deals) => DealsDashboardWidget(
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
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),
              const SizedBox(height: 12),

              // 4. Search Bar + Sort Dropdown Row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    // Sort Dropdown Pill ("الأحدث") on Left
                    Container(
                      height: 42,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 18,
                            color: Color(0xFF6B7280),
                          ),
                          SizedBox(width: 4),
                          Text(
                            'الأحدث',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF374151),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Search Input Field on Right
                    Expanded(
                      child: Container(
                        height: 42,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                        ),
                        child: TextField(
                          controller: TextEditingController(text: searchQuery)
                            ..selection = TextSelection.collapsed(offset: searchQuery.length),
                          onChanged: (val) {
                            ref.read(dealSearchQueryProvider.notifier).state = val;
                          },
                          style: const TextStyle(fontSize: 12, color: Color(0xFF111827)),
                          decoration: const InputDecoration(
                            hintText: 'ابحث برقم الطلب أو اسم المصنع أو المنتج...',
                            hintStyle: TextStyle(
                              fontSize: 11.5,
                              color: Color(0xFF9CA3AF),
                            ),
                            suffixIcon: Icon(
                              Icons.search_rounded,
                              size: 18,
                              color: Color(0xFF6B7280),
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // 5. Deals List Items
              Expanded(
                child: dealsAsync.when(
                  loading: () => const LoadingWidget(),
                  error: (err, _) => Center(
                    child: Text(
                      'حدث خطأ أثناء تحميل الصفقات: $err',
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                  data: (deals) {
                    if (deals.isEmpty) {
                      return EmptyStateWidget(
                        onResetFilter: () {
                          ref.read(dealStatusFilterProvider.notifier).state = null;
                          ref.read(dealSearchQueryProvider.notifier).state = '';
                          ref.read(onlyActionRequiredProvider.notifier).state = false;
                        },
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      itemCount: deals.length,
                      itemBuilder: (context, index) {
                        return DealCardWidget(deal: deals[index]);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),

        // Floating Action Button (+)
        floatingActionButton: FloatingActionButton(
          heroTag: 'deals_add_fab',
          onPressed: () {
            context.push('/quotations/create');
          },
          backgroundColor: const Color(0xFF2563EB),
          foregroundColor: Colors.white,
          elevation: 4,
          shape: const CircleBorder(),
          child: const Icon(Icons.add_rounded, size: 26),
        ),
      ),
    );
  }
}




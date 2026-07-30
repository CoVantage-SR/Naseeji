import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/widgets/reusable_widgets.dart';
import '../providers/rfq_provider.dart';
import '../widgets/factory_orders_widgets.dart';

class FactoryOrdersScreen extends ConsumerStatefulWidget {
  const FactoryOrdersScreen({super.key});

  @override
  ConsumerState<FactoryOrdersScreen> createState() => _FactoryOrdersScreenState();
}

class _FactoryOrdersScreenState extends ConsumerState<FactoryOrdersScreen>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  static const List<_TabItem> _tabs = [
    _TabItem(key: RFQTab.all, label: 'كل الطلبات'),
    _TabItem(key: RFQTab.drafts, label: 'مسودات'),
    _TabItem(key: RFQTab.waitingQuotations, label: 'بانتظار عروض'),
    _TabItem(key: RFQTab.receivedQuotations, label: 'عروض مستلمة'),
    _TabItem(key: RFQTab.closed, label: 'مغلقة'),
  ];

  // Pagination
  static const int _pageSize = 4;
  int _currentPage = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(_onTabChanged);
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging) return;
    ref.read(rFQFilterNotifierProvider.notifier).setFilter(_tabs[_tabController.index].key);
    setState(() => _currentPage = 0);
  }

  @override
  void dispose() {
    _tabController
      ..removeListener(_onTabChanged)
      ..dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    ref.read(rFQSearchNotifierProvider.notifier).setQuery(value);
    setState(() => _currentPage = 0);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final filteredList = ref.watch(filteredRFQsProvider);
    final summary = ref.watch(rfqSummaryProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Pagination slice
    final totalPages = (filteredList.length / _pageSize).ceil().clamp(1, 999);
    final start = _currentPage * _pageSize;
    final end = (start + _pageSize).clamp(0, filteredList.length);
    final pageItems = filteredList.sublist(start, end);

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──────────────────────────────────────────
            FactoryOrdersHeader(
              onNewOrderTap: () => checkGuestAction(
                context,
                ref,
                () => context.push('/rfq/create'),
              ),
              onNotificationTap: () => context.push('/notifications'),
            ),

            // ── Tabs ────────────────────────────────────────────
            OrdersTabs(
              controller: _tabController,
              tabs: _tabs.map((t) => t.label).toList(),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                physics: const BouncingScrollPhysics(),
                children: [
                  // ── Summary Cards ──────────────────────────────
                  OrderSummaryCards(
                    summary: summary,
                    onCardTap: (tabIndex) {
                      _tabController.animateTo(tabIndex);
                      ref
                          .read(rFQFilterNotifierProvider.notifier)
                          .setFilter(_tabs[tabIndex].key);
                    },
                  ),

                  AppSpacing.hMD,

                  // ── Search + Filter + Sort ─────────────────────
                  OrdersSearchBar(
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                    onFilterTap: () => _showFilterSheet(context),
                    onSortTap: () => _showSortSheet(context),
                  ),

                  AppSpacing.hMD,

                  // ── Orders List ────────────────────────────────
                  if (filteredList.isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: EmptyState(
                        icon: Icons.inbox_rounded,
                        title: 'لا توجد طلبات',
                        description: 'لا توجد طلبات تطابق الفلتر الحالي.',
                      ),
                    )
                  else ...[
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: pageItems.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final rfq = pageItems[index];
                        return OrderCard(
                          key: ValueKey(rfq.id),
                          rfq: rfq,
                          onTap: () => context.push('/rfq/${rfq.id}'),
                          onActionTap: (action) => _handleCardAction(context, rfq, action),
                        );
                      },
                    ),

                    // ── Pagination ─────────────────────────────
                    const SizedBox(height: 16),
                    _PaginationRow(
                      currentPage: _currentPage,
                      totalPages: totalPages,
                      totalItems: filteredList.length,
                      pageSize: _pageSize,
                      startIndex: start,
                      endIndex: end,
                      onPrev: _currentPage > 0
                          ? () => setState(() => _currentPage--)
                          : null,
                      onNext: _currentPage < totalPages - 1
                          ? () => setState(() => _currentPage++)
                          : null,
                    ),
                    const SizedBox(height: 24),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Action Handlers ─────────────────────────────────────────

  void _handleCardAction(BuildContext context, RFQ rfq, String action) {
    switch (action) {
      case 'edit':
        context.push('/rfq/${rfq.id}');
      case 'send':
        ref.read(rFQNotifierProvider.notifier).sendRFQ(rfq.id);
      case 'delete':
        _confirmDelete(context, rfq);
      case 'view_suppliers':
        context.push('/rfq/${rfq.id}/quotations');
      case 'cancel':
        ref.read(rFQNotifierProvider.notifier).cancelRFQ(rfq.id);
      case 'compare':
        context.push('/rfq/${rfq.id}/compare-quotations');
      case 'negotiate':
        context.push('/rfq/${rfq.id}/quotations');
      case 'accept_offer':
        context.push('/rfq/${rfq.id}/quotations');
      case 'open_chat':
        context.push('/chat');
      case 'counter_offer':
        context.push('/rfq/${rfq.id}/quotations');
      case 'timeline':
        context.push('/orders/${rfq.id}/timeline');
      case 'open_deal':
        context.push('/rfq/${rfq.id}');
      case 'open':
        context.push('/rfq/${rfq.id}');
    }
  }

  void _confirmDelete(BuildContext context, RFQ rfq) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: Text('هل تريد حذف طلب ${rfq.id}؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              ref.read(rFQNotifierProvider.notifier).deleteRFQ(rfq.id);
              Navigator.of(ctx).pop();
            },
            child: const Text('حذف', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => OrdersFilterSheet(
        onApply: (filter) {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  void _showSortSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => OrdersSortSheet(
        onApply: (sort) {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}

// ── Tab Item Data ────────────────────────────────────────────

class _TabItem {
  final String key;
  final String label;

  const _TabItem({required this.key, required this.label});
}

// ── Pagination Row ───────────────────────────────────────────

class _PaginationRow extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int pageSize;
  final int startIndex;
  final int endIndex;
  final VoidCallback? onPrev;
  final VoidCallback? onNext;

  const _PaginationRow({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.pageSize,
    required this.startIndex,
    required this.endIndex,
    this.onPrev,
    this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: onPrev,
          icon: const Icon(Icons.chevron_left_rounded),
          color: onPrev != null ? AppColors.primary : textSecondary.withValues(alpha: 0.4),
          iconSize: 20,
        ),
        Text(
          'عرض ${startIndex + 1} - $endIndex من $totalItems طلب',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: textSecondary,
              ),
        ),
        IconButton(
          onPressed: onNext,
          icon: const Icon(Icons.chevron_right_rounded),
          color: onNext != null ? AppColors.primary : textSecondary.withValues(alpha: 0.4),
          iconSize: 20,
        ),
      ],
    );
  }
}

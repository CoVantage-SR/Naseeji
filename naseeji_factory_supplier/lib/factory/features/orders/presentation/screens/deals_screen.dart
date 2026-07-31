import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/reusable_widgets.dart';
import '../providers/deals_provider.dart';
import '../widgets/deals_widgets.dart';

// ─────────────────────────────────────────────────────────────
//  Tab Configuration
// ─────────────────────────────────────────────────────────────

class _TabItem {
  final String key;
  final String label;

  const _TabItem({required this.key, required this.label});
}

const List<_TabItem> _kTabs = [
  _TabItem(key: DealTab.all, label: 'كل الصفقات'),
  _TabItem(key: DealTab.active, label: 'نشطة'),
  _TabItem(key: DealTab.inProduction, label: 'قيد الإنتاج'),
  _TabItem(key: DealTab.inShipping, label: 'قيد الشحن'),
  _TabItem(key: DealTab.completed, label: 'مكتملة'),
  _TabItem(key: DealTab.cancelled, label: 'ملغاة'),
];

// ─────────────────────────────────────────────────────────────
//  Deals Screen
// ─────────────────────────────────────────────────────────────

class DealsScreen extends ConsumerStatefulWidget {
  const DealsScreen({super.key});

  @override
  ConsumerState<DealsScreen> createState() => _DealsScreenState();
}

class _DealsScreenState extends ConsumerState<DealsScreen>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  // Pagination
  static const int _pageSize = 4;
  int _currentPage = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _kTabs.length, vsync: this);
    _tabController.addListener(_onTabChanged);
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging) return;
    ref
        .read(dealsFilterNotifierProvider.notifier)
        .setFilter(_kTabs[_tabController.index].key);
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
    ref.read(dealsSearchNotifierProvider.notifier).setQuery(value);
    setState(() => _currentPage = 0);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // Riverpod select — avoids full rebuild when unrelated state changes
    final filteredDeals =
        ref.watch(filteredDealsProvider);
    final summary = ref.watch(dealsSummaryProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Pagination
    final totalPages =
        (filteredDeals.length / _pageSize).ceil().clamp(1, 9999);
    final start = _currentPage * _pageSize;
    final end = (start + _pageSize).clamp(0, filteredDeals.length);
    final pageItems = filteredDeals.sublist(start, end);

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ───────────────────────────────────────
            DealsHeader(
              notificationCount: 3,
              onNotificationTap: () => context.push('/notifications'),
              onNewDealTap: () => checkGuestAction(
                context,
                ref,
                () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('يمكن إنشاء صفقة من قبول عرض سعر')),
                ),
              ),
            ),

            // ── Tabs ─────────────────────────────────────────
            DealsTabs(
              controller: _tabController,
              labels: _kTabs.map((t) => t.label).toList(),
            ),

            // ── Scrollable content ────────────────────────────
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                physics: const BouncingScrollPhysics(),
                children: [
                  // ── Summary Cards ──────────────────────────
                  DealsSummaryCards(
                    summary: summary,
                    onCardTap: (index) {
                      _tabController.animateTo(index);
                      ref
                          .read(dealsFilterNotifierProvider.notifier)
                          .setFilter(_kTabs[index].key);
                    },
                  ),

                  const SizedBox(height: 16),

                  // ── Search + Filter ────────────────────────
                  DealsSearchBar(
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                    onFilterTap: () => _showFilterSheet(context),
                    onSortTap: () {},
                  ),

                  const SizedBox(height: 16),

                  // ── Deal Cards ─────────────────────────────
                  if (filteredDeals.isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: EmptyState(
                        icon: Icons.handshake_outlined,
                        title: 'لا توجد صفقات',
                        description:
                            'لا توجد صفقات تطابق الفلتر الحالي.',
                      ),
                    )
                  else ...[
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: pageItems.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final deal = pageItems[index];
                        return DealCard(
                          key: ValueKey(deal.id),
                          deal: deal,
                          onTap: () =>
                              context.push('/orders/${deal.id}'),
                          onAction: (action) =>
                              _handleAction(context, deal, action),
                        );
                      },
                    ),

                    const SizedBox(height: 16),

                    // ── Pagination ─────────────────────────
                    _PaginationRow(
                      currentPage: _currentPage,
                      totalItems: filteredDeals.length,
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

  // ── Action Handler ────────────────────────────────────────

  void _handleAction(
      BuildContext context, DealModel deal, String action) {
    switch (action) {
      case 'advance':
        ref.read(dealsNotifierProvider.notifier).advanceStep(deal.id);
      case 'cancel':
        ref.read(dealsNotifierProvider.notifier).cancelDeal(deal.id);
      case 'production':
        context.push('/orders/${deal.id}/production');
      case 'shipment':
        context.push('/orders/${deal.id}/shipment');
      case 'timeline':
        context.push('/orders/${deal.id}/timeline');
      case 'quality':
        context.push('/orders/${deal.id}/quality-inspection');
      case 'confirm':
        context.push('/orders/${deal.id}/confirm');
      default:
        context.push('/orders/${deal.id}');
    }
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DealsFilterSheet(
        onApply: (filter) {
          final idx = _kTabs.indexWhere((t) => t.key == filter);
          if (idx >= 0) {
            _tabController.animateTo(idx);
            ref
                .read(dealsFilterNotifierProvider.notifier)
                .setFilter(filter);
          }
          Navigator.of(context).pop();
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Pagination Row
// ─────────────────────────────────────────────────────────────

class _PaginationRow extends StatelessWidget {
  final int currentPage;
  final int totalItems;
  final int pageSize;
  final int startIndex;
  final int endIndex;
  final VoidCallback? onPrev;
  final VoidCallback? onNext;

  const _PaginationRow({
    required this.currentPage,
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
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: onPrev,
          icon: const Icon(Icons.chevron_left_rounded),
          color: onPrev != null
              ? AppColors.primary
              : textSecondary.withValues(alpha: 0.4),
          iconSize: 20,
        ),
        Text(
          'عرض ${startIndex + 1} - $endIndex من $totalItems صفقة',
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: textSecondary),
        ),
        IconButton(
          onPressed: onNext,
          icon: const Icon(Icons.chevron_right_rounded),
          color: onNext != null
              ? AppColors.primary
              : textSecondary.withValues(alpha: 0.4),
          iconSize: 20,
        ),
      ],
    );
  }
}



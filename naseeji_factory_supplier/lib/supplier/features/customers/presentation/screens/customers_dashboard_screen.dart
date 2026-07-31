// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../controllers/customers_controller.dart';
import '../../domain/entities/customer_model.dart';
import '../widgets/customer_card.dart';
import '../widgets/customer_statistics_card.dart';
import '../../../dashboard/presentation/screens/drawer/navigation_drawer_view.dart';

class CustomersDashboardScreen extends ConsumerStatefulWidget {
  const CustomersDashboardScreen({super.key});

  @override
  ConsumerState<CustomersDashboardScreen> createState() => _CustomersDashboardScreenState();
}

class _CustomersDashboardScreenState extends ConsumerState<CustomersDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  String _sortBy = 'revenue'; // 'revenue' | 'orders' | 'rating' | 'recent'
  bool _showFilters = false;

  final List<(String, CustomerStatus?)> _tabs = const [
    ('الكل', null),
    ('نشط', CustomerStatus.active),
    ('VIP', CustomerStatus.vip),
    ('جديد', CustomerStatus.newCustomer),
    ('غير نشط', CustomerStatus.inactive),
    ('محظور', CustomerStatus.blocked),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<CustomerModel> _filter(List<CustomerModel> all, CustomerStatus? status) {
    var list = all.where((c) {
      if (status != null && c.status != status) return false;
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        return c.factoryName.toLowerCase().contains(q) ||
            c.contactPerson.toLowerCase().contains(q) ||
            c.city.toLowerCase().contains(q) ||
            c.businessCategory.toLowerCase().contains(q);
      }
      return true;
    }).toList();

    switch (_sortBy) {
      case 'orders':
        list.sort((a, b) => b.totalOrders.compareTo(a.totalOrders));
        break;
      case 'rating':
        list.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'recent':
        list.sort((a, b) => b.lastPurchaseDate.compareTo(a.lastPurchaseDate));
        break;
      default:
        list.sort((a, b) => b.totalRevenue.compareTo(a.totalRevenue));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final stateAsync = ref.watch(customersControllerProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        drawer: const NavigationDrawerView(),
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: 0.5,
          leading: Builder(
            builder: (ctx) => IconButton(
              icon: Icon(Icons.menu, color: AppColors.onSurfaceVariant),
              onPressed: () => Scaffold.of(ctx).openDrawer(),
            ),
          ),
          title: Text('إدارة العملاء', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 16)),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.search, color: AppColors.onSurfaceVariant),
              onPressed: () => setState(() => _showFilters = !_showFilters),
            ),
            IconButton(
              icon: Icon(Icons.sort, color: AppColors.onSurfaceVariant),
              onPressed: () => _showSortSheet(context),
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            labelColor: AppColors.primary,
            unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant,
            indicatorColor: AppColors.primary,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: _tabs.map((t) => Tab(text: t.$1)).toList(),
          ),
        ),
        body: stateAsync.when(
          loading: () => Center(child: CircularProgressIndicator(color: AppColors.primary)),
          error: (e, _) => Center(child: Text('خطأ في تحميل العملاء: $e')),
          data: (customers) {
            return Column(
              children: [
                // Search bar
                if (_showFilters)
                  Container(
                    color: Theme.of(context).colorScheme.surface,
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: TextField(
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: 'ابحث باسم المصنع، المدينة، التخصص...',
                        hintStyle: TextStyle(fontSize: 12),
                        prefixIcon: const Icon(Icons.search, size: 18),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surfaceContainerLow,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      onChanged: (v) => setState(() => _searchQuery = v),
                    ),
                  ),
                // Summary cards
                _buildSummaryCards(customers),
                // Tabs
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: _tabs.map((tab) {
                      final filtered = _filter(customers, tab.$2);
                      return RefreshIndicator(
                        onRefresh: () => ref.read(customersControllerProvider.notifier).refresh(),
                        child: filtered.isEmpty
                            ? _buildEmpty()
                            : ListView.builder(
                                padding: const EdgeInsets.all(16),
                                itemCount: filtered.length,
                                itemBuilder: (_, i) {
                                  final c = filtered[i];
                                  return CustomerCard(
                                    customer: c,
                                    onTap: () => context.push('/customers/details/${c.id}'),
                                    onChat: () => context.push('/messages'),
                                    onOrders: () => context.push('/customers/orders/${c.id}'),
                                  );
                                },
                              ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSummaryCards(List<CustomerModel> customers) {
    final total = customers.length;
    final active = customers.where((c) => c.status == CustomerStatus.active).length;
    final vip = customers.where((c) => c.status == CustomerStatus.vip).length;
    final newC = customers.where((c) => c.status == CustomerStatus.newCustomer).length;
    final revenue = customers.fold<double>(0, (s, c) => s + c.totalRevenue);
    final activeOrders = customers.fold<int>(0, (s, c) => s + c.activeOrdersCount);

    return Container(
      color: Theme.of(context).colorScheme.surface,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: SizedBox(
        height: 100,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            _summaryTile('إجمالي العملاء', total.toString(), Icons.people_outlined, AppColors.primary),
            SizedBox(width: 10),
            _summaryTile('النشطون', active.toString(), Icons.check_circle_outline, Colors.green),
            SizedBox(width: 10),
            _summaryTile('VIP', vip.toString(), Icons.star_outlined, const Color(0xFFFFB800)),
            SizedBox(width: 10),
            _summaryTile('جدد', newC.toString(), Icons.fiber_new_outlined, AppColors.secondary),
            SizedBox(width: 10),
            _summaryTile('الإيرادات', '${(revenue / 1000).toStringAsFixed(0)}ك', Icons.payments_outlined, const Color(0xFF006B5F)),
            SizedBox(width: 10),
            _summaryTile('طلبات نشطة', activeOrders.toString(), Icons.shopping_bag_outlined, AppColors.tertiary),
          ],
        ),
      ),
    );
  }

  Widget _summaryTile(String label, String value, IconData icon, Color color) {
    return SizedBox(
      width: 110,
      child: CustomerStatisticsCard(label: label, value: value, icon: icon, color: color),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.people_outline, size: 56, color: AppColors.outlineVariant),
          SizedBox(height: 12),
          Text('لا يوجد عملاء في هذا التصنيف', style: TextStyle(color: AppColors.outline, fontSize: 13)),
        ],
      ),
    );
  }

  void _showSortSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Text('ترتيب حسب', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ),
            _sortOption('إجمالي الإيرادات', 'revenue'),
            _sortOption('عدد الطلبات', 'orders'),
            _sortOption('التقييم', 'rating'),
            _sortOption('آخر طلب', 'recent'),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _sortOption(String label, String value) {
    final isSelected = _sortBy == value;
    return ListTile(
      leading: Icon(
        isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
        color: isSelected ? AppColors.primary : AppColors.outline,
        size: 20,
      ),
      title: Text(label, style: TextStyle(fontSize: 13, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? AppColors.primary : Theme.of(context).colorScheme.onSurface)),
      onTap: () {
        setState(() => _sortBy = value);
        Navigator.pop(context);
      },
    );
  }
}
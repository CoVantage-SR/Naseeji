import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/orders_provider.dart';
import '../widgets/orders_list_widgets.dart';

class OrdersScreen extends ConsumerStatefulWidget {
  const OrdersScreen({super.key});

  @override
  ConsumerState<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';

  final List<Map<String, String>> _orderTabs = const [
    {'key': 'all', 'label': 'الكل'},
    {'key': 'new', 'label': 'جديد'},
    {'key': 'preparing', 'label': 'تحت التحضير'},
    {'key': 'readyToShip', 'label': 'جاهز للشحن'},
    {'key': 'shipping', 'label': 'جاري الشحن'},
    {'key': 'delivered', 'label': 'المستلمة'},
    {'key': 'cancelled', 'label': 'الملغية/النزاعات'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _orderTabs.length, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allOrders = ref.watch(ordersNotifierProvider);
    final activeTabKey = _orderTabs[_tabController.index]['key']!;

    var filtered = allOrders;

    if (activeTabKey != 'all') {
      filtered = filtered.where((o) => o.status == activeTabKey).toList();
    }

    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((o) =>
              o.id.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              o.supplierName.contains(_searchQuery) ||
              o.productName.contains(_searchQuery))
          .toList();
    }

    return Scaffold(
      appBar: const OrdersAppBarWidget(),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SearchWidget(
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val;
                  });
                },
              ),
            ),
            StatusTabsWidget(
              tabController: _tabController,
              tabs: _orderTabs,
            ),
            const Divider(height: 1),
            Expanded(
              child: OrdersListWidget(orders: filtered),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingSearchButtonWidget(
        onTap: () {
          setState(() {
            _searchQuery = '';
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تمت إعادة تعيين البحث.')),
          );
        },
      ),
    );
  }
}

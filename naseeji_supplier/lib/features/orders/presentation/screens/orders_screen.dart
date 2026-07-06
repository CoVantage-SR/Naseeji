import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import 'package:naseeji_supplier/features/dashboard/presentation/screens/drawer/navigation_drawer_view.dart';
import '../../domain/entities/rfq_item.dart';
import '../controllers/orders_controller.dart';
import 'widgets/rfq_item_card.dart';
import 'widgets/rfq_stats_grid.dart';

class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    final stateAsync = ref.watch(ordersControllerProvider);

    return Scaffold(
      key: scaffoldKey,
      endDrawer: const NavigationDrawerView(),
      appBar: RfqAppBar(scaffoldKey: scaffoldKey),
      body: Container(
        color: const Color(0xFFF8F9FF),
        child: stateAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
          error: (err, stack) => Center(child: Text('خطأ: $err')),
          data: (stateData) {
            return RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () =>
                  ref.read(ordersControllerProvider.notifier).refreshOrders(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 80.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    RfqStatsGrid(stats: stateData.stats),
                    const SizedBox(height: 20),
                    const RfqSearchBar(),
                    const SizedBox(height: 16),
                    const RfqFilterSortRow(),
                    const SizedBox(height: 20),
                    RfqItemsList(items: stateData.items),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: const RfqBottomNavigationBar(),
    );
  }
}

class RfqAppBar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const RfqAppBar({super.key, required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.5,
      leadingWidth: 110,
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.onSurfaceVariant),
            onPressed: () => context.push('/search'),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.notifications_none,
                  color: AppColors.onSurfaceVariant,
                ),
                onPressed: () => context.push('/notifications'),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 14,
                    minHeight: 14,
                  ),
                  child: const Text(
                    '3',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      centerTitle: true,
      title: const Text(
        'طلبات الأسعار (RFQ)',
        style: TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.menu, color: AppColors.onSurfaceVariant),
          onPressed: () => scaffoldKey.currentState?.openEndDrawer(),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class RfqSearchBar extends StatelessWidget {
  const RfqSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: TextField(
        decoration: InputDecoration(
          hintText: 'ابحث في طلبات الأسعار...',
          hintStyle: const TextStyle(
            color: AppColors.outline,
            fontSize: 13,
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: AppColors.outline,
            size: 20,
          ),
          fillColor: Colors.white,
          filled: true,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Color(0xFFE2E1EF),
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Color(0xFFE2E1EF),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: AppColors.primary,
              width: 1,
            ),
          ),
        ),
      ),
    );
  }
}

class RfqFilterSortRow extends StatelessWidget {
  const RfqFilterSortRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(
              Icons.tune,
              size: 16,
              color: AppColors.onSurfaceVariant,
            ),
            label: const Text(
              'تصفية',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.onSurfaceVariant,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(
                color: Color(0xFFE2E1EF),
                width: 1,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 10),
              backgroundColor: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(
              Icons.sort,
              size: 16,
              color: AppColors.onSurfaceVariant,
            ),
            label: const Text(
              'ترتيب',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.onSurfaceVariant,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(
                color: Color(0xFFE2E1EF),
                width: 1,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 10),
              backgroundColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

class RfqItemsList extends StatelessWidget {
  final List<RfqItem> items;

  const RfqItemsList({super.key, required this.items});

  IconData? _getIconData(String? type) {
    if (type == 'more') {
      return Icons.more_horiz;
    } else if (type == 'chat') {
      return Icons.chat_bubble_outline;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return RfqItemCard(
          companyName: item.companyName,
          rfqNumber: item.rfqNumber,
          material: item.material,
          status: item.status,
          statusColor: Color(item.statusColorValue),
          statusBgColor: Color(item.statusBgColorValue),
          quantity: item.quantity,
          location: item.location,
          dateLabel: item.dateLabel,
          dateValue: item.dateValue,
          logoText: item.logoText,
          logoBgColor: Color(item.logoBgColorValue),
          actionButtonText: item.actionButtonText,
          actionButtonColor: Color(item.actionButtonColorValue),
          actionButtonTextColor: Color(item.actionButtonTextColorValue),
          actionButtonIsOutlined: item.actionButtonIsOutlined,
          hasIconButton: item.hasIconButton,
          iconButtonIcon: _getIconData(item.iconButtonIconType),
          onActionButtonPressed: () {
            final id = item.rfqNumber.replaceAll("RFQ-", "");
            if (item.actionButtonText == 'تقديم عرض') {
              context.push('/rfq-details?rfqId=$id');
            } else if (item.actionButtonText == 'متابعة العرض') {
              context.push('/orders/chat?rfqId=$id');
            } else if (item.actionButtonText == 'تم إرسال العرض') {
              context.push('/orders/offer-details?rfqId=$id');
            } else {
              context.push('/rfq-details?rfqId=$id');
            }
          },
        );
      },
    );
  }
}

class RfqBottomNavigationBar extends StatelessWidget {
  const RfqBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: 2,
      backgroundColor: Colors.white,
      elevation: 8,
      indicatorColor: const Color(0xFF72F8E4).withValues(alpha: 0.6),
      onDestinationSelected: (index) {
        if (index == 0) {
          context.go('/home');
        } else if (index == 4) {
          context.go('/profile');
        }
      },
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined, color: AppColors.onSurfaceVariant),
          selectedIcon: Icon(Icons.home, color: AppColors.secondary),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(
            Icons.category_outlined,
            color: AppColors.onSurfaceVariant,
          ),
          selectedIcon: Icon(Icons.category, color: AppColors.secondary),
          label: 'Products',
        ),
        NavigationDestination(
          icon: Icon(
            Icons.shopping_cart_outlined,
            color: AppColors.onSurfaceVariant,
          ),
          selectedIcon: Icon(Icons.shopping_cart, color: AppColors.secondary),
          label: 'Orders',
        ),
        NavigationDestination(
          icon: Icon(
            Icons.chat_bubble_outline,
            color: AppColors.onSurfaceVariant,
          ),
          selectedIcon: Icon(Icons.chat_bubble, color: AppColors.secondary),
          label: 'Messages',
        ),
        NavigationDestination(
          icon: Icon(
            Icons.person_outline,
            color: AppColors.onSurfaceVariant,
          ),
          selectedIcon: Icon(Icons.person, color: AppColors.secondary),
          label: 'Account',
        ),
      ],
    );
  }
}

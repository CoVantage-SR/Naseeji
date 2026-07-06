import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import 'package:naseeji_supplier/features/dashboard/presentation/screens/drawer/navigation_drawer_view.dart';
import 'widgets/rfq_stats_grid.dart';
import 'widgets/rfq_item_card.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      endDrawer: const NavigationDrawerView(),
      appBar: AppBar(
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
      ),
      body: Container(
        color: const Color(0xFFF8F9FF),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 80.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // 4 Metrics Grid
              const RfqStatsGrid(),
              const SizedBox(height: 20),

              // Search Bar
              Directionality(
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
              ),
              const SizedBox(height: 16),

              // Filter and Sort buttons row
              Row(
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
              ),
              const SizedBox(height: 20),

              // RFQ items list
              RfqItemCard(
                companyName: 'مصنع الرياض للملابس',
                rfqNumber: 'RFQ-8820',
                material: 'Cotton 100%',
                status: 'جديد',
                statusColor: const Color(0xFF0040E0),
                statusBgColor: const Color(0xFFE8F0FE),
                quantity: '5,000 م',
                location: 'الرياض، SA',
                dateLabel: 'تاريخ الطلب',
                dateValue: 'منذ ساعتين',
                logoText: 'RC',
                logoBgColor: const Color(0xFF0040E0),
                actionButtonText: 'تقديم عرض',
                actionButtonColor: const Color(0xFF0040E0),
                actionButtonTextColor: Colors.white,
                hasIconButton: true,
                iconButtonIcon: Icons.more_horiz,
                onActionButtonPressed: () {},
              ),
              RfqItemCard(
                companyName: 'حلول جدة للنسيج',
                rfqNumber: 'RFQ-8794',
                material: 'Polyester Silk Blend',
                status: 'تفاوض',
                statusColor: const Color(0xFFEA580C),
                statusBgColor: const Color(0xFFFFEDD5),
                quantity: '12,500 م',
                location: 'جدة، SA',
                dateLabel: 'تاريخ الطلب',
                dateValue: 'منذ 5 ساعات',
                logoText: 'JT',
                logoBgColor: const Color(0xFF006B5F),
                actionButtonText: 'متابعة العرض',
                actionButtonColor: const Color(0xFF0040E0),
                actionButtonTextColor: const Color(0xFF0040E0),
                actionButtonIsOutlined: true,
                hasIconButton: true,
                iconButtonIcon: Icons.chat_bubble_outline,
                onActionButtonPressed: () {},
              ),
              RfqItemCard(
                companyName: 'مصنع الدمام للملابس',
                rfqNumber: 'RFQ-8710',
                material: 'Organic Linen',
                status: 'في الانتظار',
                statusColor: const Color(0xFF8B5CF6),
                statusBgColor: const Color(0xFFF3E8FF),
                quantity: '3,200 م',
                location: 'الدمام، SA',
                dateLabel: 'تاريخ الطلب',
                dateValue: 'أمس، 04:30 م',
                logoText: 'DC',
                logoBgColor: const Color(0xFF4B5563),
                actionButtonText: 'تم إرسال العرض',
                actionButtonColor: const Color(0xFF9CA3AF),
                actionButtonTextColor: const Color(0xFF4B5563),
                actionButtonIsOutlined: true,
                hasIconButton: false,
                onActionButtonPressed: () {},
              ),
              RfqItemCard(
                companyName: 'شركة الأزياء الموحدة',
                rfqNumber: 'RFQ-8655',
                material: 'Wool Blend',
                status: 'تمت الموافقة',
                statusColor: const Color(0xFF16A34A),
                statusBgColor: const Color(0xFFDCFCE7),
                quantity: '8,000 م',
                location: 'المدينة، SA',
                dateLabel: 'تاريخ الموافقة',
                dateValue: 'اليوم، 10:15 ص',
                logoText: 'UF',
                logoBgColor: const Color(0xFFD97706),
                actionButtonText: 'بدء الإنتاج',
                actionButtonColor: const Color(0xFF006B5F),
                actionButtonTextColor: Colors.white,
                hasIconButton: false,
                onActionButtonPressed: () {},
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: const Color(0xFF0040E0),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'إضافة عرض سعر',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
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
            icon: Icon(Icons.category_outlined, color: AppColors.onSurfaceVariant),
            selectedIcon: Icon(Icons.category, color: AppColors.secondary),
            label: 'Products',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_cart_outlined, color: AppColors.onSurfaceVariant),
            selectedIcon: Icon(Icons.shopping_cart, color: AppColors.secondary),
            label: 'Orders',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline, color: AppColors.onSurfaceVariant),
            selectedIcon: Icon(Icons.chat_bubble, color: AppColors.secondary),
            label: 'Messages',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline, color: AppColors.onSurfaceVariant),
            selectedIcon: Icon(Icons.person, color: AppColors.secondary),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}

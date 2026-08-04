import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../providers/account_provider.dart';

class NotificationCenterScreen extends ConsumerStatefulWidget {
  const NotificationCenterScreen({super.key});

  @override
  ConsumerState<NotificationCenterScreen> createState() => _NotificationCenterScreenState();
}

class _NotificationCenterScreenState extends ConsumerState<NotificationCenterScreen> {
  String _selectedCategory = 'الكل';

  final List<String> _categories = [
    'الكل',
    'Deals',
    'RFQ',
    'Marketplace',
    'Payments',
    'Messages',
    'System',
  ];

  @override
  Widget build(BuildContext context) {
    final notifications = ref.watch(notificationsProvider);
    final isDark = context.theme.brightness == Brightness.dark;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    final filtered = _selectedCategory == 'الكل'
        ? notifications
        : notifications.where((n) => n.category.toLowerCase() == _selectedCategory.toLowerCase()).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('مركز الإشعارات والتنبيهات'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_rounded),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all_rounded),
            tooltip: 'تحديد الكل كتقروء',
            onPressed: () {
              ref.read(accountNotifierProvider.notifier).markAllNotificationsRead();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم تعليم جميع الإشعارات كمقروءة.')),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Category Selector Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: _categories.map((cat) {
                  final isSelected = _selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: FilterChip(
                      selected: isSelected,
                      label: Text(cat),
                      selectedColor: AppColors.primary,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : textPrimary,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 12,
                      ),
                      onSelected: (val) {
                        setState(() => _selectedCategory = cat);
                      },
                    ),
                  );
                }).toList(),
              ),
            ),

            const Divider(height: 1),

            // Notifications list
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.notifications_off_outlined, size: 48, color: textSecondary.withValues(alpha: 0.5)),
                          const SizedBox(height: 12),
                          Text('لا توجد إشعارات حالية في هذه الفئة', style: TextStyle(color: textSecondary)),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final item = filtered[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Material(
                            color: item.isRead ? surface : AppColors.primary.withValues(alpha: 0.05),
                            borderRadius: AppRadius.rMD,
                            clipBehavior: Clip.antiAlias,
                            shape: RoundedRectangleBorder(
                              borderRadius: AppRadius.rMD,
                              side: BorderSide(
                                color: item.isRead ? border : AppColors.primary.withValues(alpha: 0.3),
                              ),
                            ),
                            child: ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: _categoryColor(item.category).withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(_categoryIcon(item.category), color: _categoryColor(item.category), size: 20),
                            ),
                            title: Text(
                              item.title,
                              style: TextStyle(
                                color: textPrimary,
                                fontWeight: item.isRead ? FontWeight.normal : FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text(item.description, style: TextStyle(color: textSecondary, fontSize: 11)),
                                const SizedBox(height: 4),
                                Text(item.timeAgo, style: const TextStyle(color: Colors.grey, fontSize: 9)),
                              ],
                            ),
                            trailing: PopupMenuButton<String>(
                              onSelected: (val) {
                                if (val == 'read') {
                                  ref.read(accountNotifierProvider.notifier).markNotificationRead(item.id);
                                } else if (val == 'delete') {
                                  ref.read(accountNotifierProvider.notifier).deleteNotification(item.id);
                                }
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem(value: 'read', child: Text('تعليم كمقروء')),
                                const PopupMenuItem(value: 'delete', child: Text('حذف الإشعار', style: TextStyle(color: Colors.red))),
                              ],
                            ),
                            onTap: () {
                              ref.read(accountNotifierProvider.notifier).markNotificationRead(item.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('تفاصيل الإشعار: ${item.title}')),
                              );
                            },
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

  Color _categoryColor(String cat) {
    switch (cat.toLowerCase()) {
      case 'deals':
        return AppColors.primary;
      case 'rfq':
        return AppColors.info;
      case 'payments':
        return AppColors.success;
      case 'messages':
        return AppColors.warning;
      case 'system':
        return AppColors.secondary;
      default:
        return AppColors.primary;
    }
  }

  IconData _categoryIcon(String cat) {
    switch (cat.toLowerCase()) {
      case 'deals':
        return Icons.handshake_outlined;
      case 'rfq':
        return Icons.request_quote_outlined;
      case 'payments':
        return Icons.account_balance_wallet_outlined;
      case 'messages':
        return Icons.chat_bubble_outline_rounded;
      case 'system':
        return Icons.security_rounded;
      default:
        return Icons.notifications_none_rounded;
    }
  }
}




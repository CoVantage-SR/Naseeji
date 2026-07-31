import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/dashboard_providers.dart';
import '../shared/dashboard_section_title.dart';
import '../shared/notification_card.dart';
import '../shared/loading_widget.dart';
import '../shared/empty_state_widget.dart';
import '../shared/error_state_widget.dart';

class RecentNotificationsWidget extends ConsumerWidget {
  const RecentNotificationsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifsAsync = ref.watch(notificationsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DashboardSectionTitle(
          title: 'التنبيهات والأحداث الأخيرة',
          subtitle: 'آخر 3 تحديثات وإشعارات هامة',
          icon: Icons.notifications_active_rounded,
          actionText: 'عرض الكل',
          onActionTap: () => context.push('/notifications'),
        ),
        notifsAsync.when(
          loading: () => const LoadingWidget(height: 140),
          error: (err, stack) => ErrorStateWidget(
            message: 'خطأ في تحميل التنبيهات: $err',
            onRetry: () => ref.invalidate(notificationsProvider),
          ),
          data: (notifications) {
            if (notifications.isEmpty) {
              return const EmptyStateWidget(
                title: 'لا توجد إشعارات جديدة',
                description: 'ستصلك التنبيهات حول المعاملات والمدفوعات هنا.',
                icon: Icons.notifications_off_outlined,
              );
            }

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: notifications.length, // Provider already trims to max 3 items
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final notif = notifications[index];
                return NotificationCard(notification: notif);
              },
            );
          },
        ),
      ],
    );
  }
}


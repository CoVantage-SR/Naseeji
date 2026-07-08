import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../controllers/subscription_controllers.dart';

class SubscriptionNotificationsScreen extends ConsumerWidget {
  const SubscriptionNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(subscriptionNotificationsControllerProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          title: const Text(
            'تنبيهات وأمور الفوترة',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.onSurface),
          ),
          centerTitle: true,
        ),
        body: Material(
          color: const Color(0xFFF8F9FF),
          child: notificationsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('خطأ: $e')),
            data: (notifications) {
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notif = notifications[index];
                  final timeStr = '${notif.timestamp.year}/${notif.timestamp.month.toString().padLeft(2, '0')}/${notif.timestamp.day.toString().padLeft(2, '0')} ${notif.timestamp.hour.toString().padLeft(2, '0')}:${notif.timestamp.minute.toString().padLeft(2, '0')}';

                  Color iconColor = const Color(0xFF0040E0);
                  IconData icon = Icons.info_outline;

                  if (notif.type == 'success') {
                    iconColor = const Color(0xFF006B5F);
                    icon = Icons.check_circle_outline;
                  } else if (notif.type == 'warning') {
                    iconColor = const Color(0xFFFF9800);
                    icon = Icons.warning_amber_rounded;
                  } else if (notif.type == 'error') {
                    iconColor = const Color(0xFFBA1A1A);
                    icon = Icons.error_outline;
                  }

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                notif.title,
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                notif.body,
                                style: const TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant, height: 1.4),
                                textAlign: TextAlign.right,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                timeStr,
                                style: const TextStyle(fontSize: 9, color: AppColors.outline),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: iconColor.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(icon, color: iconColor, size: 20),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

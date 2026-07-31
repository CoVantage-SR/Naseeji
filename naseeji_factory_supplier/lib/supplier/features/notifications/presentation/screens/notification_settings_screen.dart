import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/notification_settings_providers.dart';
import '../widgets/notification_setting_widgets.dart';

class NotificationSettingsScreen extends ConsumerWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(notificationSettingsProvider);
    final notifier = ref.read(notificationSettingsProvider.notifier);
    final isEnabled = settings.enableAll;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAFB),
        body: SafeArea(
          child: Column(
            children: [
              // 1. Top Custom App Bar Header (RTL)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Right: Purple Bell Icon + Title & Subtitle
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF3E8FF),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.notifications_active_rounded,
                            color: Color(0xFF9333EA),
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'إعدادات الإشعارات',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF111827),
                                height: 1.1,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'تحكم في الإشعارات التي تريد استقبالها',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF6B7280),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Left: Back Arrow
                    IconButton(
                      onPressed: () {
                        if (context.canPop()) {
                          context.pop();
                        } else {
                          context.go('/profile');
                        }
                      },
                      icon: const Icon(
                        Icons.arrow_forward_rounded,
                        color: Color(0xFF111827),
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),

              // Scrollable Main Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    children: [
                      // -------------------------------------------------------
                      // SECTION 1: التفعيل العام (General Notifications)
                      // -------------------------------------------------------
                      NotificationSection(
                        title: 'التفعيل العام',
                        child: NotificationSwitchTile(
                          title: 'تفعيل جميع الإشعارات',
                          description: 'استقبال جميع الإشعارات والتنبيهات',
                          icon: Icons.notifications_active_rounded,
                          iconColor: const Color(0xFF9333EA),
                          iconBgColor: const Color(0xFFF3E8FF),
                          value: settings.enableAll,
                          onChanged: (val) {
                            notifier.toggleAll(val);
                            _showToast(context, val ? 'تم تفعيل جميع الإشعارات' : 'تم تعطيل جميع الإشعارات');
                          },
                        ),
                      ),

                      const SizedBox(height: 18),

                      // -------------------------------------------------------
                      // SECTION 2: الإشعارات حسب النوع (Category Notifications)
                      // -------------------------------------------------------
                      NotificationSection(
                        title: 'الإشعارات حسب النوع',
                        child: Column(
                          children: [
                            NotificationSwitchTile(
                              title: 'الطلبات و الصفقات',
                              description: 'إشعارات الطلبات الجديدة وتحديثات الصفقات',
                              icon: Icons.shopping_bag_outlined,
                              iconColor: const Color(0xFF16A34A),
                              iconBgColor: const Color(0xFFDCFCE7),
                              value: settings.rfqNotifications && isEnabled,
                              enabled: isEnabled,
                              onChanged: (v) => _updateSetting(context, notifier, 'rfq', v),
                            ),
                            const Divider(height: 1, color: Color(0xFFF3F4F6)),
                            NotificationSwitchTile(
                              title: 'الرسائل والمحادثات',
                              description: 'إشعارات الرسائل الجديدة في المحادثات',
                              icon: Icons.chat_bubble_outline_rounded,
                              iconColor: const Color(0xFF2563EB),
                              iconBgColor: const Color(0xFFEFF6FF),
                              value: settings.chatNotifications && isEnabled,
                              enabled: isEnabled,
                              onChanged: (v) => _updateSetting(context, notifier, 'chat', v),
                            ),
                            const Divider(height: 1, color: Color(0xFFF3F4F6)),
                            NotificationSwitchTile(
                              title: 'المنتجات',
                              description: 'إشعارات إضافة المنتجات وتحديثها',
                              icon: Icons.inventory_2_outlined,
                              iconColor: const Color(0xFF9333EA),
                              iconBgColor: const Color(0xFFF3E8FF),
                              value: settings.productNotifications && isEnabled,
                              enabled: isEnabled,
                              onChanged: (v) => _updateSetting(context, notifier, 'product', v),
                            ),
                            const Divider(height: 1, color: Color(0xFFF3F4F6)),
                            NotificationSwitchTile(
                              title: 'المدفوعات والفواتير',
                              description: 'إشعارات الدفع والحوالات والفواتير',
                              icon: Icons.credit_card_rounded,
                              iconColor: const Color(0xFFEA580C),
                              iconBgColor: const Color(0xFFFFF7ED),
                              value: settings.paymentNotifications && isEnabled,
                              enabled: isEnabled,
                              onChanged: (v) => _updateSetting(context, notifier, 'payment', v),
                            ),
                            const Divider(height: 1, color: Color(0xFFF3F4F6)),
                            NotificationSwitchTile(
                              title: 'الشحن والتسليم',
                              description: 'إشعارات الشحن والتتبع وحالة التسليم',
                              icon: Icons.local_shipping_outlined,
                              iconColor: const Color(0xFF0D9488),
                              iconBgColor: const Color(0xFFCCFBF1),
                              value: settings.shippingNotifications && isEnabled,
                              enabled: isEnabled,
                              onChanged: (v) => _updateSetting(context, notifier, 'shipping', v),
                            ),
                            const Divider(height: 1, color: Color(0xFFF3F4F6)),
                            NotificationSwitchTile(
                              title: 'العروض والتخفيضات',
                              description: 'إشعارات العروض والتخفيضات الجديدة',
                              icon: Icons.discount_outlined,
                              iconColor: const Color(0xFFE11D48),
                              iconBgColor: const Color(0xFFFFE4E6),
                              value: settings.offersNotifications && isEnabled,
                              enabled: isEnabled,
                              onChanged: (v) => _updateSetting(context, notifier, 'offers', v),
                            ),
                            const Divider(height: 1, color: Color(0xFFF3F4F6)),
                            NotificationSwitchTile(
                              title: 'التقارير والتحليلات',
                              description: 'إشعارات التقارير والتحليلات الدورية',
                              icon: Icons.pie_chart_outline_rounded,
                              iconColor: const Color(0xFF2563EB),
                              iconBgColor: const Color(0xFFEFF6FF),
                              value: settings.reportsNotifications && isEnabled,
                              enabled: isEnabled,
                              onChanged: (v) => _updateSetting(context, notifier, 'reports', v),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 18),

                      // -------------------------------------------------------
                      // SECTION 3: طريقة استلام الإشعارات (Delivery Methods)
                      // -------------------------------------------------------
                      NotificationSection(
                        title: 'طريقة استلام الإشعارات',
                        child: Column(
                          children: [
                            NotificationSwitchTile(
                              title: 'داخل التطبيق',
                              description: 'استلام الإشعارات داخل التطبيق',
                              icon: Icons.smartphone_rounded,
                              iconColor: const Color(0xFF9333EA),
                              iconBgColor: const Color(0xFFF3E8FF),
                              value: settings.inAppNotifications && isEnabled,
                              enabled: isEnabled,
                              onChanged: (v) => _updateSetting(context, notifier, 'inApp', v),
                            ),
                            const Divider(height: 1, color: Color(0xFFF3F4F6)),
                            NotificationSwitchTile(
                              title: 'إشعارات بريد إلكتروني',
                              description: 'استلام الإشعارات على البريد الإلكتروني',
                              icon: Icons.mail_outline_rounded,
                              iconColor: const Color(0xFFEA580C),
                              iconBgColor: const Color(0xFFFFF7ED),
                              value: settings.emailNotifications && isEnabled,
                              enabled: isEnabled,
                              onChanged: (v) => _updateSetting(context, notifier, 'email', v),
                            ),
                            const Divider(height: 1, color: Color(0xFFF3F4F6)),
                            NotificationSwitchTile(
                              title: 'إشعارات SMS',
                              description: 'استلام الإشعارات على رقم الجوال',
                              icon: Icons.sms_outlined,
                              iconColor: const Color(0xFF16A34A),
                              iconBgColor: const Color(0xFFDCFCE7),
                              value: settings.smsNotifications && isEnabled,
                              enabled: isEnabled,
                              onChanged: (v) => _updateSetting(context, notifier, 'sms', v),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 18),

                      // -------------------------------------------------------
                      // SECTION 4: أوقات الإشعارات (Notification Schedule)
                      // -------------------------------------------------------
                      NotificationSection(
                        title: 'أوقات الإشعارات',
                        child: NotificationScheduleCard(
                          scheduleTitle: settings.notificationSchedule,
                          timeRange: '${settings.startTime} - ${settings.endTime}',
                          enabled: isEnabled,
                          onTap: () => _showScheduleModal(context, settings, notifier),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // -------------------------------------------------------
                      // SECTION 5: زر إعادة تعيين الإعدادات (Reset Button)
                      // -------------------------------------------------------
                      ResetSettingsButton(
                        onPressed: () {
                          notifier.reset();
                          _showToast(context, 'تم إعادة جميع الإعدادات إلى الوضع الافتراضي');
                        },
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateSetting(BuildContext context, NotificationSettingsNotifier notifier, String key, bool val) {
    notifier.toggleItem(key, val);
    _showToast(context, 'تم حفظ الإعدادات');
  }

  void _showToast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF16A34A),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showScheduleModal(BuildContext context, dynamic settings, NotificationSettingsNotifier notifier) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('تخصيص أوقات الإشعارات', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                ListTile(
                  title: const Text('دائماً'),
                  subtitle: const Text('استقبال الإشعارات على مدار 24 ساعة'),
                  trailing: settings.notificationSchedule == 'دائماً' ? const Icon(Icons.check_circle_rounded, color: Color(0xFF9333EA)) : null,
                  onTap: () {
                    notifier.updateSchedule(schedule: 'دائماً', startTime: '00:00', endTime: '24:00');
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text('ساعات العمل'),
                  subtitle: const Text('من 9:00 ص حتى 5:00 م'),
                  trailing: settings.notificationSchedule == 'ساعات العمل' ? const Icon(Icons.check_circle_rounded, color: Color(0xFF9333EA)) : null,
                  onTap: () {
                    notifier.updateSchedule(schedule: 'ساعات العمل', startTime: '9:00 ص', endTime: '5:00 م');
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text('عدم الإزعاج'),
                  subtitle: const Text('إيقاف الإشعارات ليلاً (11:00 م - 7:00 ص)'),
                  trailing: settings.notificationSchedule == 'عدم الإزعاج' ? const Icon(Icons.check_circle_rounded, color: Color(0xFF9333EA)) : null,
                  onTap: () {
                    notifier.updateSchedule(schedule: 'عدم الإزعاج', startTime: '11:00 م', endTime: '7:00 ص');
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}


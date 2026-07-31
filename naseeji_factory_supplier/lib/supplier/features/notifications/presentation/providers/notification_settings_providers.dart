import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naseeji_factory/core/mock/mock_data.dart';
import '../../domain/entities/notification_settings_model.dart';

class NotificationSettingsNotifier extends StateNotifier<NotificationSettingsModel> {
  NotificationSettingsNotifier() : super(MockDatabase.getNotificationSettings());

  void loadSettings() {
    state = MockDatabase.getNotificationSettings();
  }

  void saveSettings(NotificationSettingsModel newSettings) {
    MockDatabase.updateNotificationSettings(newSettings);
    state = newSettings;
  }

  void toggleAll(bool val) {
    final updated = state.copyWith(
      enableAll: val,
      updatedAt: DateTime.now(),
    );
    saveSettings(updated);
  }

  void toggleItem(String key, bool val) {
    NotificationSettingsModel updated;
    switch (key) {
      case 'rfq':
        updated = state.copyWith(rfqNotifications: val);
        break;
      case 'deal':
        updated = state.copyWith(dealNotifications: val);
        break;
      case 'chat':
        updated = state.copyWith(chatNotifications: val);
        break;
      case 'product':
        updated = state.copyWith(productNotifications: val);
        break;
      case 'subscription':
        updated = state.copyWith(subscriptionNotifications: val);
        break;
      case 'payment':
        updated = state.copyWith(paymentNotifications: val);
        break;
      case 'invoice':
        updated = state.copyWith(invoiceNotifications: val);
        break;
      case 'shipping':
        updated = state.copyWith(shippingNotifications: val);
        break;
      case 'delivery':
        updated = state.copyWith(deliveryNotifications: val);
        break;
      case 'reports':
        updated = state.copyWith(reportsNotifications: val);
        break;
      case 'analytics':
        updated = state.copyWith(analyticsNotifications: val);
        break;
      case 'offers':
        updated = state.copyWith(offersNotifications: val);
        break;
      case 'updates':
        updated = state.copyWith(updatesNotifications: val);
        break;
      case 'marketing':
        updated = state.copyWith(marketingNotifications: val);
        break;
      case 'inApp':
        updated = state.copyWith(inAppNotifications: val);
        break;
      case 'email':
        updated = state.copyWith(emailNotifications: val);
        break;
      case 'sms':
        updated = state.copyWith(smsNotifications: val);
        break;
      case 'push':
        updated = state.copyWith(pushNotifications: val);
        break;
      default:
        updated = state;
    }
    saveSettings(updated.copyWith(updatedAt: DateTime.now()));
  }

  void updateSchedule({required String schedule, String? startTime, String? endTime}) {
    final updated = state.copyWith(
      notificationSchedule: schedule,
      startTime: startTime ?? state.startTime,
      endTime: endTime ?? state.endTime,
      updatedAt: DateTime.now(),
    );
    saveSettings(updated);
  }

  void reset() {
    final defaultSet = NotificationSettingsModel.defaultSettings;
    saveSettings(defaultSet);
  }
}

final notificationSettingsProvider =
    StateNotifierProvider<NotificationSettingsNotifier, NotificationSettingsModel>((ref) {
  return NotificationSettingsNotifier();
});




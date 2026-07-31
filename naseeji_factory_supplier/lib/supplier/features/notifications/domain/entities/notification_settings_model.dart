class NotificationSettingsModel {
  final bool enableAll;
  final bool rfqNotifications;
  final bool dealNotifications;
  final bool chatNotifications;
  final bool productNotifications;
  final bool subscriptionNotifications;
  final bool paymentNotifications;
  final bool invoiceNotifications;
  final bool shippingNotifications;
  final bool deliveryNotifications;
  final bool reportsNotifications;
  final bool analyticsNotifications;
  final bool offersNotifications;
  final bool updatesNotifications;
  final bool marketingNotifications;
  final bool inAppNotifications;
  final bool emailNotifications;
  final bool smsNotifications;
  final bool pushNotifications;
  final String notificationSchedule; // 'دائماً', 'ساعات العمل', 'عدم الإزعاج', 'مخصص'
  final String startTime;
  final String endTime;
  final DateTime updatedAt;

  const NotificationSettingsModel({
    this.enableAll = true,
    this.rfqNotifications = true,
    this.dealNotifications = true,
    this.chatNotifications = true,
    this.productNotifications = true,
    this.subscriptionNotifications = true,
    this.paymentNotifications = true,
    this.invoiceNotifications = true,
    this.shippingNotifications = true,
    this.deliveryNotifications = true,
    this.reportsNotifications = true,
    this.analyticsNotifications = true,
    this.offersNotifications = false,
    this.updatesNotifications = true,
    this.marketingNotifications = false,
    this.inAppNotifications = true,
    this.emailNotifications = true,
    this.smsNotifications = false,
    this.pushNotifications = true,
    this.notificationSchedule = 'عدم الإزعاج',
    this.startTime = '11:00 م',
    this.endTime = '7:00 ص',
    required this.updatedAt,
  });

  NotificationSettingsModel copyWith({
    bool? enableAll,
    bool? rfqNotifications,
    bool? dealNotifications,
    bool? chatNotifications,
    bool? productNotifications,
    bool? subscriptionNotifications,
    bool? paymentNotifications,
    bool? invoiceNotifications,
    bool? shippingNotifications,
    bool? deliveryNotifications,
    bool? reportsNotifications,
    bool? analyticsNotifications,
    bool? offersNotifications,
    bool? updatesNotifications,
    bool? marketingNotifications,
    bool? inAppNotifications,
    bool? emailNotifications,
    bool? smsNotifications,
    bool? pushNotifications,
    String? notificationSchedule,
    String? startTime,
    String? endTime,
    DateTime? updatedAt,
  }) {
    return NotificationSettingsModel(
      enableAll: enableAll ?? this.enableAll,
      rfqNotifications: rfqNotifications ?? this.rfqNotifications,
      dealNotifications: dealNotifications ?? this.dealNotifications,
      chatNotifications: chatNotifications ?? this.chatNotifications,
      productNotifications: productNotifications ?? this.productNotifications,
      subscriptionNotifications: subscriptionNotifications ?? this.subscriptionNotifications,
      paymentNotifications: paymentNotifications ?? this.paymentNotifications,
      invoiceNotifications: invoiceNotifications ?? this.invoiceNotifications,
      shippingNotifications: shippingNotifications ?? this.shippingNotifications,
      deliveryNotifications: deliveryNotifications ?? this.deliveryNotifications,
      reportsNotifications: reportsNotifications ?? this.reportsNotifications,
      analyticsNotifications: analyticsNotifications ?? this.analyticsNotifications,
      offersNotifications: offersNotifications ?? this.offersNotifications,
      updatesNotifications: updatesNotifications ?? this.updatesNotifications,
      marketingNotifications: marketingNotifications ?? this.marketingNotifications,
      inAppNotifications: inAppNotifications ?? this.inAppNotifications,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      smsNotifications: smsNotifications ?? this.smsNotifications,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      notificationSchedule: notificationSchedule ?? this.notificationSchedule,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static NotificationSettingsModel get defaultSettings => NotificationSettingsModel(
        enableAll: true,
        rfqNotifications: true,
        dealNotifications: true,
        chatNotifications: true,
        productNotifications: true,
        subscriptionNotifications: true,
        paymentNotifications: true,
        invoiceNotifications: true,
        shippingNotifications: true,
        deliveryNotifications: true,
        reportsNotifications: true,
        analyticsNotifications: true,
        offersNotifications: false,
        updatesNotifications: true,
        marketingNotifications: false,
        inAppNotifications: true,
        emailNotifications: true,
        smsNotifications: false,
        pushNotifications: true,
        notificationSchedule: 'عدم الإزعاج',
        startTime: '11:00 م',
        endTime: '7:00 ص',
        updatedAt: DateTime.now(),
      );
}




enum NotificationType {
  newRfq,
  counterOffer,
  agreementApproved,
  shipmentCreated,
  paymentReleased,
  subscriptionExpiring,
  general,
}

class NotificationItemModel {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime timestamp;
  final bool isRead;
  final String? targetRoute;

  const NotificationItemModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    required this.isRead,
    this.targetRoute,
  });
}



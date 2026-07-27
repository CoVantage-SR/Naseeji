import 'package:flutter/foundation.dart';

@immutable
class FactoryDashboardData {
  final String factoryName;
  final bool isVerified;
  final int unreadNotificationsCount;
  final String greeting;
  final List<TodayTaskItem> todayTasks;

  const FactoryDashboardData({
    required this.factoryName,
    required this.isVerified,
    required this.unreadNotificationsCount,
    required this.greeting,
    required this.todayTasks,
  });
}

@immutable
class TodayTaskItem {
  final String id;
  final int count;
  final String title;
  final String colorTag; // 'blue', 'green', 'orange', 'red'
  final String iconType;
  final String routePath;

  const TodayTaskItem({
    required this.id,
    required this.count,
    required this.title,
    required this.colorTag,
    required this.iconType,
    required this.routePath,
  });
}

@immutable
class RecentQuotationItem {
  final String id;
  final String supplierName;
  final String supplierLogo;
  final String productName;
  final String price;
  final String deliveryTime;
  final String validity;
  final String status; // 'جديد', 'قيد التفاوض', 'تم استلامه', 'منتهي'

  const RecentQuotationItem({
    required this.id,
    required this.supplierName,
    required this.supplierLogo,
    required this.productName,
    required this.price,
    required this.deliveryTime,
    required this.validity,
    required this.status,
  });
}

@immutable
class ActiveDealItem {
  final String dealId;
  final String supplierName;
  final String productName;
  final String expectedDelivery;
  final String status; // 'في الإنتاج', 'تم الاتفاق', 'قيد التفاوض'
  final double progress; // 0.0 to 1.0

  const ActiveDealItem({
    required this.dealId,
    required this.supplierName,
    required this.productName,
    required this.expectedDelivery,
    required this.status,
    required this.progress,
  });
}

@immutable
class RecentRFQItem {
  final String id;
  final String productName;
  final String quantity;
  final String sentToCount;
  final String status; // 'بانتظار العروض', 'عروض مستلمة', 'قيد التفاوض'
  final String createdAt;

  const RecentRFQItem({
    required this.id,
    required this.productName,
    required this.quantity,
    required this.sentToCount,
    required this.status,
    required this.createdAt,
  });
}

@immutable
class FavoriteSupplierItem {
  final String id;
  final String supplierName;
  final bool isVerified;
  final double rating;
  final String country;
  final String flagEmoji;

  const FavoriteSupplierItem({
    required this.id,
    required this.supplierName,
    required this.isVerified,
    required this.rating,
    required this.country,
    required this.flagEmoji,
  });
}

@immutable
class NotificationPreviewItem {
  final String id;
  final String title;
  final String description;
  final String timeAgo;
  final String type; // 'shipment', 'deal', 'chat', 'quotation'

  const NotificationPreviewItem({
    required this.id,
    required this.title,
    required this.description,
    required this.timeAgo,
    required this.type,
  });
}

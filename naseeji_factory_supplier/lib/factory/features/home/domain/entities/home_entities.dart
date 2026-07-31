import 'package:flutter/foundation.dart';

@immutable
class HomeStatistics {
  final int completedOrders;
  final int pendingOrders;
  final int newQuotations;
  final int shipments;
  final double monthlyPurchases;
  final int favoriteSuppliers;

  const HomeStatistics({
    required this.completedOrders,
    required this.pendingOrders,
    required this.newQuotations,
    required this.shipments,
    required this.monthlyPurchases,
    required this.favoriteSuppliers,
  });

  HomeStatistics copyWith({
    int? completedOrders,
    int? pendingOrders,
    int? newQuotations,
    int? shipments,
    double? monthlyPurchases,
    int? favoriteSuppliers,
  }) {
    return HomeStatistics(
      completedOrders: completedOrders ?? this.completedOrders,
      pendingOrders: pendingOrders ?? this.pendingOrders,
      newQuotations: newQuotations ?? this.newQuotations,
      shipments: shipments ?? this.shipments,
      monthlyPurchases: monthlyPurchases ?? this.monthlyPurchases,
      favoriteSuppliers: favoriteSuppliers ?? this.favoriteSuppliers,
    );
  }
}

@immutable
class LatestRFQ {
  final String id;
  final String product;
  final int quantity;
  final double budget;
  final String status;
  final int supplierCount;

  const LatestRFQ({
    required this.id,
    required this.product,
    required this.quantity,
    required this.budget,
    required this.status,
    required this.supplierCount,
  });

  LatestRFQ copyWith({
    String? id,
    String? product,
    int? quantity,
    double? budget,
    String? status,
    int? supplierCount,
  }) {
    return LatestRFQ(
      id: id ?? this.id,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      budget: budget ?? this.budget,
      status: status ?? this.status,
      supplierCount: supplierCount ?? this.supplierCount,
    );
  }
}

@immutable
class LatestQuotation {
  final String id;
  final String supplier;
  final double price;
  final String deliveryTime;
  final double rating;

  const LatestQuotation({
    required this.id,
    required this.supplier,
    required this.price,
    required this.deliveryTime,
    required this.rating,
  });

  LatestQuotation copyWith({
    String? id,
    String? supplier,
    double? price,
    String? deliveryTime,
    double? rating,
  }) {
    return LatestQuotation(
      id: id ?? this.id,
      supplier: supplier ?? this.supplier,
      price: price ?? this.price,
      deliveryTime: deliveryTime ?? this.deliveryTime,
      rating: rating ?? this.rating,
    );
  }
}

@immutable
class CurrentOrder {
  final String orderNumber;
  final String supplier;
  final String status;
  final double progress; // between 0.0 and 1.0
  final String estimatedDelivery;

  const CurrentOrder({
    required this.orderNumber,
    required this.supplier,
    required this.status,
    required this.progress,
    required this.estimatedDelivery,
  });

  CurrentOrder copyWith({
    String? orderNumber,
    String? supplier,
    String? status,
    double? progress,
    String? estimatedDelivery,
  }) {
    return CurrentOrder(
      orderNumber: orderNumber ?? this.orderNumber,
      supplier: supplier ?? this.supplier,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      estimatedDelivery: estimatedDelivery ?? this.estimatedDelivery,
    );
  }
}

@immutable
class Shipment {
  final String shippingCompany;
  final String trackingNumber;
  final String currentLocation;
  final String eta;
  final double progress; // between 0.0 and 1.0

  const Shipment({
    required this.shippingCompany,
    required this.trackingNumber,
    required this.currentLocation,
    required this.eta,
    required this.progress,
  });

  Shipment copyWith({
    String? shippingCompany,
    String? trackingNumber,
    String? currentLocation,
    String? eta,
    double? progress,
  }) {
    return Shipment(
      shippingCompany: shippingCompany ?? this.shippingCompany,
      trackingNumber: trackingNumber ?? this.trackingNumber,
      currentLocation: currentLocation ?? this.currentLocation,
      eta: eta ?? this.eta,
      progress: progress ?? this.progress,
    );
  }
}

@immutable
class FavoriteSupplier {
  final String id;
  final String logo;
  final String supplierName;
  final double rating;
  final String lastDeal;

  const FavoriteSupplier({
    required this.id,
    required this.logo,
    required this.supplierName,
    required this.rating,
    required this.lastDeal,
  });

  FavoriteSupplier copyWith({
    String? id,
    String? logo,
    String? supplierName,
    double? rating,
    String? lastDeal,
  }) {
    return FavoriteSupplier(
      id: id ?? this.id,
      logo: logo ?? this.logo,
      supplierName: supplierName ?? this.supplierName,
      rating: rating ?? this.rating,
      lastDeal: lastDeal ?? this.lastDeal,
    );
  }
}

@immutable
class MonthlyStatistics {
  final double purchaseSummary;
  final double growthPercentage;
  final List<double> chartData;

  const MonthlyStatistics({
    required this.purchaseSummary,
    required this.growthPercentage,
    required this.chartData,
  });

  MonthlyStatistics copyWith({
    double? purchaseSummary,
    double? growthPercentage,
    List<double>? chartData,
  }) {
    return MonthlyStatistics(
      purchaseSummary: purchaseSummary ?? this.purchaseSummary,
      growthPercentage: growthPercentage ?? this.growthPercentage,
      chartData: chartData ?? this.chartData,
    );
  }
}

@immutable
class RecentActivity {
  final String id;
  final String title;
  final String description;
  final String time;
  final String type; // 'rfq_created', 'quotation_received', 'order_approved', 'shipment_started', 'shipment_delivered'

  const RecentActivity({
    required this.id,
    required this.title,
    required this.description,
    required this.time,
    required this.type,
  });

  RecentActivity copyWith({
    String? id,
    String? title,
    String? description,
    String? time,
    String? type,
  }) {
    return RecentActivity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      time: time ?? this.time,
      type: type ?? this.type,
    );
  }
}

@immutable
class SmartRecommendation {
  final String id;
  final String title;
  final String description;
  final String type; // 'cheaper_supplier', 'faster_delivery', 'trending_product', 'recommended_supplier'
  final String actionLabel;
  final String routePath;

  const SmartRecommendation({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.actionLabel,
    required this.routePath,
  });

  SmartRecommendation copyWith({
    String? id,
    String? title,
    String? description,
    String? type,
    String? actionLabel,
    String? routePath,
  }) {
    return SmartRecommendation(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      actionLabel: actionLabel ?? this.actionLabel,
      routePath: routePath ?? this.routePath,
    );
  }
}

@immutable
class ActionCenterAlert {
  final String id;
  final String title;
  final String description;
  final String type; // 'pending_rfq', 'shipment_today', 'supplier_replied', 'invoice_pending', 'delayed_shipment'
  final bool isClickable;
  final String routePath;

  const ActionCenterAlert({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.isClickable,
    required this.routePath,
  });

  ActionCenterAlert copyWith({
    String? id,
    String? title,
    String? description,
    String? type,
    bool? isClickable,
    String? routePath,
  }) {
    return ActionCenterAlert(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      isClickable: isClickable ?? this.isClickable,
      routePath: routePath ?? this.routePath,
    );
  }
}


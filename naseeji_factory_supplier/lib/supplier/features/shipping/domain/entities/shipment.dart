enum ShipmentStatus {
  ready,            // جاهز للشحن
  loaded,           // تم التحميل
  pickedUp,         // تم الاستلام
  inTransit,        // في الطريق
  arrived,          // وصلت الوجهة
  delivered,        // تم التسليم للمشتري
  paymentPending,   // انتظار تحرير الدفعة
  completed,        // مكتمل
}

class ShipmentTimelineEvent {
  final String time;
  final String date;
  final String status;
  final String user;
  final String notes;
  final List<String> attachments;

  const ShipmentTimelineEvent({
    required this.time,
    required this.date,
    required this.status,
    required this.user,
    required this.notes,
    this.attachments = const [],
  });
}

class ShipmentDocument {
  final String type; // e.g. "Commercial Invoice", "Packing List"
  final String name;
  final String url;
  final int version;
  final String uploadedAt;

  const ShipmentDocument({
    required this.type,
    required this.name,
    required this.url,
    required this.version,
    required this.uploadedAt,
  });

  ShipmentDocument copyWith({
    String? type,
    String? name,
    String? url,
    int? version,
    String? uploadedAt,
  }) {
    return ShipmentDocument(
      type: type ?? this.type,
      name: name ?? this.name,
      url: url ?? this.url,
      version: version ?? this.version,
      uploadedAt: uploadedAt ?? this.uploadedAt,
    );
  }
}

class ShipmentCost {
  final double shipping;
  final double insurance;
  final double taxes;
  final double handling;
  final double packaging;
  final double other;

  const ShipmentCost({
    required this.shipping,
    required this.insurance,
    required this.taxes,
    required this.handling,
    required this.packaging,
    required this.other,
  });

  double get total => shipping + insurance + taxes + handling + packaging + other;

  ShipmentCost copyWith({
    double? shipping,
    double? insurance,
    double? taxes,
    double? handling,
    double? packaging,
    double? other,
  }) {
    return ShipmentCost(
      shipping: shipping ?? this.shipping,
      insurance: insurance ?? this.insurance,
      taxes: taxes ?? this.taxes,
      handling: handling ?? this.handling,
      packaging: packaging ?? this.packaging,
      other: other ?? this.other,
    );
  }
}

class FactoryConfirmation {
  final bool received;
  final String inspectionStatus; // e.g. "مقبول بالكامل", "مقبول جزئياً"
  final double acceptedQty;
  final double rejectedQty;
  final String notes;
  final List<String> images;
  final String feedback;

  const FactoryConfirmation({
    required this.received,
    required this.inspectionStatus,
    required this.acceptedQty,
    required this.rejectedQty,
    required this.notes,
    required this.images,
    required this.feedback,
  });
}

class Shipment {
  final String id;
  final String orderNumber;
  final String rfqNumber;
  final String factoryName;
  final String factoryLogoText;
  final int factoryLogoBgColorValue;
  final String productName;
  final int quantity;
  final String unit;
  final double weight;
  final double volume;
  final int cartons;
  final int packages;
  final ShipmentStatus status;
  final String shippingCompany;
  final String trackingNumber;
  final String shippingMethod;
  final String vehicleNumber;
  final String driverName;
  final String driverPhone;
  final String estimatedDelivery;
  final String deliveryAddress;
  final String priority; // "عالي جداً", "عادي", "منخفض"
  final String lastUpdate;
  final double progress; // 0.0 to 1.0
  final List<ShipmentTimelineEvent> timeline;
  final Map<String, List<String>> media; // keys: beforeShipment, loading, afterShipment
  final List<ShipmentDocument> documents;
  final ShipmentCost cost;
  final FactoryConfirmation? factoryConfirmation;
  final String? issueReported;

  const Shipment({
    required this.id,
    required this.orderNumber,
    required this.rfqNumber,
    required this.factoryName,
    required this.factoryLogoText,
    required this.factoryLogoBgColorValue,
    required this.productName,
    required this.quantity,
    required this.unit,
    required this.weight,
    required this.volume,
    required this.cartons,
    required this.packages,
    required this.status,
    required this.shippingCompany,
    required this.trackingNumber,
    required this.shippingMethod,
    required this.vehicleNumber,
    required this.driverName,
    required this.driverPhone,
    required this.estimatedDelivery,
    required this.deliveryAddress,
    required this.priority,
    required this.lastUpdate,
    required this.progress,
    required this.timeline,
    required this.media,
    required this.documents,
    required this.cost,
    this.factoryConfirmation,
    this.issueReported,
  });

  Shipment copyWith({
    String? id,
    String? orderNumber,
    String? rfqNumber,
    String? factoryName,
    String? factoryLogoText,
    int? factoryLogoBgColorValue,
    String? productName,
    int? quantity,
    String? unit,
    double? weight,
    double? volume,
    int? cartons,
    int? packages,
    ShipmentStatus? status,
    String? shippingCompany,
    String? trackingNumber,
    String? shippingMethod,
    String? vehicleNumber,
    String? driverName,
    String? driverPhone,
    String? estimatedDelivery,
    String? deliveryAddress,
    String? priority,
    String? lastUpdate,
    double? progress,
    List<ShipmentTimelineEvent>? timeline,
    Map<String, List<String>>? media,
    List<ShipmentDocument>? documents,
    ShipmentCost? cost,
    FactoryConfirmation? factoryConfirmation,
    String? issueReported,
  }) {
    return Shipment(
      id: id ?? this.id,
      orderNumber: orderNumber ?? this.orderNumber,
      rfqNumber: rfqNumber ?? this.rfqNumber,
      factoryName: factoryName ?? this.factoryName,
      factoryLogoText: factoryLogoText ?? this.factoryLogoText,
      factoryLogoBgColorValue: factoryLogoBgColorValue ?? this.factoryLogoBgColorValue,
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      weight: weight ?? this.weight,
      volume: volume ?? this.volume,
      cartons: cartons ?? this.cartons,
      packages: packages ?? this.packages,
      status: status ?? this.status,
      shippingCompany: shippingCompany ?? this.shippingCompany,
      trackingNumber: trackingNumber ?? this.trackingNumber,
      shippingMethod: shippingMethod ?? this.shippingMethod,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      driverName: driverName ?? this.driverName,
      driverPhone: driverPhone ?? this.driverPhone,
      estimatedDelivery: estimatedDelivery ?? this.estimatedDelivery,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      priority: priority ?? this.priority,
      lastUpdate: lastUpdate ?? this.lastUpdate,
      progress: progress ?? this.progress,
      timeline: timeline ?? this.timeline,
      media: media ?? this.media,
      documents: documents ?? this.documents,
      cost: cost ?? this.cost,
      factoryConfirmation: factoryConfirmation ?? this.factoryConfirmation,
      issueReported: issueReported ?? this.issueReported,
    );
  }
}




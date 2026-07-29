import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'orders_provider.g.dart';

class OrderModel {
  final String id;
  final String dealNumber;
  final String rfqId;
  final String supplierName;
  final String supplierLogo;
  final bool supplierVerified;
  final String productName;
  final String productImage;
  final String specifications;
  final int quantity;
  final String unit;
  final double unitPrice;
  final double finalPrice;
  final String orderDate;
  final String agreementDate;
  final String expectedDeliveryDate;
  final String countryOfOrigin;
  final String leadTime;
  final double progressPercentage;
  final String status; // 'new', 'preparing', 'readyToShip', 'shipping', 'delivered', 'cancelled'
  final int currentStepIndex; // 0: الاتفاق, 1: الإنتاج, 2: الشحن, 3: التسليم, 4: التفتيش, 5: الدفع
  final String address;
  final String paymentMethod;
  final String paymentTerms;
  final String trackingNumber;
  final String shippingCompany;
  final String currentLocation;
  final String carrierStatus;
  final String estimatedArrival;

  // Financial breakdown
  final double financialProducts;
  final double financialShipping;
  final double financialInsurance;
  final double financialTax;

  OrderModel({
    required this.id,
    this.dealNumber = '#DEAL-2024-0045',
    required this.rfqId,
    required this.supplierName,
    this.supplierLogo = 'https://images.unsplash.com/photo-1560179707-f14e90ef3623?w=150',
    this.supplierVerified = true,
    required this.productName,
    required this.productImage,
    this.specifications = 'عرض 150 سم - 140 جم/م²',
    required this.quantity,
    this.unit = 'متر',
    this.unitPrice = 21.74,
    required this.finalPrice,
    required this.orderDate,
    this.agreementDate = '10 مايو 2024',
    required this.expectedDeliveryDate,
    this.countryOfOrigin = 'مصر 🇪🇬',
    this.leadTime = '7 - 10 أيام',
    required this.progressPercentage,
    required this.status,
    this.currentStepIndex = 2,
    required this.address,
    required this.paymentMethod,
    this.paymentTerms = '50% مقدم - 50% بعد الاستلام',
    required this.trackingNumber,
    required this.shippingCompany,
    required this.currentLocation,
    required this.carrierStatus,
    required this.estimatedArrival,
    this.financialProducts = 108695.0,
    this.financialShipping = 6000.0,
    this.financialInsurance = 2000.0,
    this.financialTax = 8305.0,
  });

  OrderModel copyWith({
    String? status,
    double? progressPercentage,
    String? currentLocation,
    String? carrierStatus,
    int? currentStepIndex,
  }) {
    return OrderModel(
      id: id,
      dealNumber: dealNumber,
      rfqId: rfqId,
      supplierName: supplierName,
      supplierLogo: supplierLogo,
      supplierVerified: supplierVerified,
      productName: productName,
      productImage: productImage,
      specifications: specifications,
      quantity: quantity,
      unit: unit,
      unitPrice: unitPrice,
      finalPrice: finalPrice,
      orderDate: orderDate,
      agreementDate: agreementDate,
      expectedDeliveryDate: expectedDeliveryDate,
      countryOfOrigin: countryOfOrigin,
      leadTime: leadTime,
      progressPercentage: progressPercentage ?? this.progressPercentage,
      status: status ?? this.status,
      currentStepIndex: currentStepIndex ?? this.currentStepIndex,
      address: address,
      paymentMethod: paymentMethod,
      paymentTerms: paymentTerms,
      trackingNumber: trackingNumber,
      shippingCompany: shippingCompany,
      currentLocation: currentLocation ?? this.currentLocation,
      carrierStatus: carrierStatus ?? this.carrierStatus,
      estimatedArrival: estimatedArrival,
      financialProducts: financialProducts,
      financialShipping: financialShipping,
      financialInsurance: financialInsurance,
      financialTax: financialTax,
    );
  }
}

class OrderTimelineItem {
  final String id;
  final String stage;
  final String date;
  final String time;
  final String updatedBy;
  final String notes;
  final List<String> attachments;

  OrderTimelineItem({
    required this.id,
    required this.stage,
    required this.date,
    required this.time,
    required this.updatedBy,
    required this.notes,
    required this.attachments,
  });
}

final List<OrderModel> _mockOrders = [
  OrderModel(
    id: 'ORD-201',
    dealNumber: '#DEAL-2024-0045',
    rfqId: '#RFQ-2024-0045',
    supplierName: 'مصر للغزل والنسيج',
    supplierLogo: 'https://images.unsplash.com/photo-1560179707-f14e90ef3623?w=150',
    supplierVerified: true,
    productName: 'قماش 100% قطن أبيض',
    productImage: 'https://images.unsplash.com/photo-1528301721190-186c3bd85418?w=500',
    specifications: 'عرض 150 سم - 140 جم/م²',
    quantity: 5000,
    unit: 'متر',
    unitPrice: 21.74,
    finalPrice: 125000.0,
    orderDate: '2024/05/10',
    agreementDate: '10 مايو 2024',
    expectedDeliveryDate: '25 مايو 2024',
    countryOfOrigin: 'مصر 🇪🇬',
    leadTime: '7 - 10 أيام',
    progressPercentage: 60.0,
    status: 'shipping',
    currentStepIndex: 2, // 0: الاتفاق, 1: الإنتاج, 2: الشحن (Active), 3: التسليم, 4: التفتيش, 5: الدفع
    address: 'المنطقة الصناعية، التجمع الخامس، القاهرة، مصر',
    paymentMethod: 'تحويل بنكي',
    paymentTerms: '50% مقدم - 50% بعد الاستلام',
    trackingNumber: 'TRK123456789EG',
    shippingCompany: 'شركة الشحن الوطنية',
    currentLocation: 'تم شحن طلبك وهو في طريقه إليك',
    carrierStatus: 'تم شحن الطلب بواسطة شركة الشحن الوطنية',
    estimatedArrival: '25 مايو 2024',
    financialProducts: 108695.0,
    financialShipping: 6000.0,
    financialInsurance: 2000.0,
    financialTax: 8305.0,
  ),
  OrderModel(
    id: 'ORD-202',
    dealNumber: '#DEAL-2024-0046',
    rfqId: '#RFQ-2024-0046',
    supplierName: 'مصنع النيل للأقمشة الحديثة',
    supplierLogo: '',
    supplierVerified: true,
    productName: 'قماش كتان طبيعي فاخر',
    productImage: 'https://images.unsplash.com/photo-1607604276583-eef5d076aa5f?w=500',
    specifications: 'عرض 160 سم - 180 جم/م²',
    quantity: 800,
    unit: 'متر',
    unitPrice: 77.50,
    finalPrice: 62000.0,
    orderDate: '2024/05/12',
    agreementDate: '12 مايو 2024',
    expectedDeliveryDate: '28 مايو 2024',
    countryOfOrigin: 'مصر',
    leadTime: '5 - 8 أيام',
    progressPercentage: 90.0,
    status: 'readyToShip',
    currentStepIndex: 1,
    address: 'شارع التسعين الشمالي، التجمع الخامس، القاهرة',
    paymentMethod: 'تحويل بنكي مباشر',
    paymentTerms: 'اعتماد مستندي (L/C)',
    trackingNumber: 'TRK-881245',
    shippingCompany: 'دي إتش إل (DHL)',
    currentLocation: 'مستودع الشحن الرئيسي بالإسكندرية',
    carrierStatus: 'جاهز للاستلام بواسطة شركة النقل',
    estimatedArrival: '28 مايو 2024',
    financialProducts: 54000.0,
    financialShipping: 3000.0,
    financialInsurance: 1000.0,
    financialTax: 4000.0,
  ),
  OrderModel(
    id: 'ORD-203',
    dealNumber: '#DEAL-2024-0047',
    rfqId: '#RFQ-2024-0047',
    supplierName: 'الفتح لخيوط البوليستر',
    supplierLogo: '',
    supplierVerified: false,
    productName: 'ألياف بوليستر معالجة',
    productImage: 'https://images.unsplash.com/photo-1605721911519-3dfeb3be25e7?w=500',
    specifications: 'نمرة 40/2 مغزول',
    quantity: 2000,
    unit: 'بكرة',
    unitPrice: 60.00,
    finalPrice: 120000.0,
    orderDate: '2024/05/15',
    agreementDate: '15 مايو 2024',
    expectedDeliveryDate: '30 مايو 2024',
    countryOfOrigin: 'الصين',
    leadTime: '10 - 15 يوم',
    progressPercentage: 95.0,
    status: 'delivered',
    currentStepIndex: 3,
    address: 'المنطقة الحرة ببرج العرب، الإسكندرية',
    paymentMethod: 'خطاب ضمان بنكي معتمد',
    paymentTerms: 'عند التسليم بالكامل',
    trackingNumber: 'TRK-771890',
    shippingCompany: 'نقل سريع إكسبريس',
    currentLocation: 'تم التسليم لمخازن المصنع',
    carrierStatus: 'تم التسليم بنجاح وجاري فحص الجودة',
    estimatedArrival: '30 مايو 2024',
    financialProducts: 105000.0,
    financialShipping: 5000.0,
    financialInsurance: 2000.0,
    financialTax: 8000.0,
  ),
];

final Map<String, List<OrderTimelineItem>> _mockTimelines = {
  'ORD-201': [
    OrderTimelineItem(
      id: 'TL-1',
      stage: 'تم شحن الطلب',
      date: '16 مايو 2024',
      time: '10:30 ص',
      updatedBy: 'شركة الشحن الوطنية',
      notes: 'تم شحن الطلب بواسطة شركة الشحن الوطنية برقم TRK123456789EG.',
      attachments: ['بوليسة_الشحن.pdf'],
    ),
    OrderTimelineItem(
      id: 'TL-2',
      stage: 'بدء الإنتاج',
      date: '12 مايو 2024',
      time: '09:00 ص',
      updatedBy: 'مصنع مصر للغزل والنسيج',
      notes: 'تم بدء الإنتاج وتجهيز الأنسجة القطنية بالمصنع.',
      attachments: ['تقرير_بدء_الإنتاج.pdf'],
    ),
    OrderTimelineItem(
      id: 'TL-3',
      stage: 'تم الاتفاق على الصفقة',
      date: '10 مايو 2024',
      time: '02:15 م',
      updatedBy: 'الطرفان (المصنع والمورد)',
      notes: 'تم الموافقة على العرض وإشعارات العقد وإنشاء الصفقة بنجاح.',
      attachments: ['عقد_اتفاقية_الصفقة.pdf'],
    ),
  ],
};

@riverpod
class OrdersNotifier extends _$OrdersNotifier {
  @override
  List<OrderModel> build() {
    return _mockOrders;
  }

  OrderModel? getOrderById(String orderId) {
    try {
      return state.firstWhere((o) => o.id == orderId || o.dealNumber == orderId);
    } catch (_) {
      return state.isNotEmpty ? state.first : null;
    }
  }

  void confirmDelivery(String orderId) {
    state = state.map((o) {
      if (o.id == orderId || o.dealNumber == orderId) {
        final updated = o.copyWith(
          status: 'delivered',
          progressPercentage: 100.0,
          currentStepIndex: 3, // Delivered
          currentLocation: 'مستودع المصنع الرئيسي',
          carrierStatus: 'تم تسليم الشحنة بنجاح',
        );

        // Update Timeline
        ref.read(timelineNotifierProvider.notifier).addTimelineItem(
              orderId,
              stage: 'تم تسليم الشحنة وتأكيد الاستلام',
              updatedBy: 'مصنع ناصيجي (المشتري)',
              notes: 'أكد مصنع ناصيجي استلام الشحنة وتوجيهها لفحص الجودة.',
              attachments: ['سند_الاستلام_الموقع.pdf'],
            );

        return updated;
      }
      return o;
    }).toList();
  }

  void reportProblem(String orderId, String reason, String description) {
    state = state.map((o) {
      if (o.id == orderId || o.dealNumber == orderId) {
        final updated = o.copyWith(
          status: 'cancelled',
          progressPercentage: 0.0,
          carrierStatus: 'موقوف / تحت النزاع',
        );

        // Update Timeline
        ref.read(timelineNotifierProvider.notifier).addTimelineItem(
              orderId,
              stage: 'تم الإبلاغ عن عدم تطابق مواصفات',
              updatedBy: 'مصنع ناصيجي (المشتري)',
              notes: 'السبب: $reason - التفاصيل: $description',
              attachments: ['صورة_الفحص_والعيوب.jpg'],
            );

        return updated;
      }
      return o;
    }).toList();
  }
}

@riverpod
class TimelineNotifier extends _$TimelineNotifier {
  @override
  Map<String, List<OrderTimelineItem>> build() {
    return _mockTimelines;
  }

  void addTimelineItem(
    String orderId, {
    required String stage,
    required String updatedBy,
    required String notes,
    required List<String> attachments,
  }) {
    final list = List<OrderTimelineItem>.from(state[orderId] ?? []);
    final now = DateTime.now();
    final hour = now.hour > 12 ? now.hour - 12 : now.hour;
    final amPm = now.hour >= 12 ? 'م' : 'ص';
    final timeStr = '${hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')} $amPm';
    final dateStr = '${now.year}/${now.month.toString().padLeft(2, '0')}/${now.day.toString().padLeft(2, '0')}';

    list.add(OrderTimelineItem(
      id: 'TL-${list.length + 10}',
      stage: stage,
      date: dateStr,
      time: timeStr,
      updatedBy: updatedBy,
      notes: notes,
      attachments: attachments,
    ));

    state = {
      ...state,
      orderId: list,
    };
  }
}

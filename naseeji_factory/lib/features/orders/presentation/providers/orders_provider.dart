import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'orders_provider.g.dart';

class OrderModel {
  final String id;
  final String rfqId;
  final String supplierName;
  final String productName;
  final String productImage;
  final int quantity;
  final double finalPrice;
  final String orderDate;
  final String expectedDeliveryDate;
  final double progressPercentage;
  final String status; // 'new', 'preparing', 'readyToShip', 'shipping', 'delivered', 'cancelled'
  final String address;
  final String paymentMethod;
  final String trackingNumber;
  final String shippingCompany;
  final String currentLocation;
  final String carrierStatus;
  final String estimatedArrival;

  OrderModel({
    required this.id,
    required this.rfqId,
    required this.supplierName,
    required this.productName,
    required this.productImage,
    required this.quantity,
    required this.finalPrice,
    required this.orderDate,
    required this.expectedDeliveryDate,
    required this.progressPercentage,
    required this.status,
    required this.address,
    required this.paymentMethod,
    required this.trackingNumber,
    required this.shippingCompany,
    required this.currentLocation,
    required this.carrierStatus,
    required this.estimatedArrival,
  });

  OrderModel copyWith({
    String? status,
    double? progressPercentage,
    String? currentLocation,
    String? carrierStatus,
  }) {
    return OrderModel(
      id: id,
      rfqId: rfqId,
      supplierName: supplierName,
      productName: productName,
      productImage: productImage,
      quantity: quantity,
      finalPrice: finalPrice,
      orderDate: orderDate,
      expectedDeliveryDate: expectedDeliveryDate,
      progressPercentage: progressPercentage ?? this.progressPercentage,
      status: status ?? this.status,
      address: address,
      paymentMethod: paymentMethod,
      trackingNumber: trackingNumber,
      shippingCompany: shippingCompany,
      currentLocation: currentLocation ?? this.currentLocation,
      carrierStatus: carrierStatus ?? this.carrierStatus,
      estimatedArrival: estimatedArrival,
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
    rfqId: 'RFQ-101',
    supplierName: 'مصنع غزل المحلة',
    productName: 'خيوط قطن ممشط 30/1',
    productImage: 'https://images.unsplash.com/photo-1528459801416-a9e53bbf4e17',
    quantity: 1500,
    finalPrice: 85000.0,
    orderDate: '2026/07/01',
    expectedDeliveryDate: '2026/07/20',
    progressPercentage: 60.0,
    status: 'preparing',
    address: 'المنطقة الصناعية الثالثة، السادس من أكتوبر، مصر',
    paymentMethod: 'بوابة دفع بنك مصر - 30% مقدم / 70% عند الاستلام',
    trackingNumber: 'TRK-990812',
    shippingCompany: 'أرامكس مصر (Aramex)',
    currentLocation: 'مركز فرز القاهرة الكبرى',
    carrierStatus: 'قيد التجهيز للشحن البري',
    estimatedArrival: '2026/07/20',
  ),
  OrderModel(
    id: 'ORD-202',
    rfqId: 'RFQ-102',
    supplierName: 'منسوجات النيل الحديثة',
    productName: 'قماش كتان طبيعي فاخر',
    productImage: 'https://images.unsplash.com/photo-1544816155-12df9643f363',
    quantity: 800,
    finalPrice: 62000.0,
    orderDate: '2026/07/02',
    expectedDeliveryDate: '2026/07/18',
    progressPercentage: 90.0,
    status: 'readyToShip',
    address: 'شارع التسعين الشمالي، التجمع الخامس، القاهرة',
    paymentMethod: 'تحويل بنكي مباشر - بنك CIB',
    trackingNumber: 'TRK-881245',
    shippingCompany: 'دي إتش إل (DHL)',
    currentLocation: 'مستودع الشحن الرئيسي بالإسكندرية',
    carrierStatus: 'جاهز للاستلام بواسطة شركة النقل',
    estimatedArrival: '2026/07/18',
  ),
  OrderModel(
    id: 'ORD-203',
    rfqId: 'RFQ-103',
    supplierName: 'المصرية لإنتاج الكتان',
    productName: 'ألياف كتان صناعي معالج',
    productImage: 'https://images.unsplash.com/photo-1584622650111-993a426fbf0a',
    quantity: 2000,
    finalPrice: 120000.0,
    orderDate: '2026/07/05',
    expectedDeliveryDate: '2026/07/15',
    progressPercentage: 95.0,
    status: 'shipping',
    address: 'المنطقة الحرة ببرج العرب، الإسكندرية',
    paymentMethod: 'خطاب ضمان بنكي معتمد',
    trackingNumber: 'TRK-771890',
    shippingCompany: 'نقل سريع إكسبريس',
    currentLocation: 'طريق القاهرة - الإسكندرية الصحراوي',
    carrierStatus: 'جاري النقل بالسيارة المبردة رقم ٨٤٢١ ط ج م',
    estimatedArrival: '2026/07/15',
  ),
  OrderModel(
    id: 'ORD-204',
    rfqId: 'RFQ-104',
    supplierName: 'حلوان لصناعة الغزل',
    productName: 'أقمشة بوليستر عالي الكثافة',
    productImage: 'https://images.unsplash.com/photo-1606744824163-985d376605aa',
    quantity: 3000,
    finalPrice: 175000.0,
    orderDate: '2026/06/15',
    expectedDeliveryDate: '2026/07/05',
    progressPercentage: 100.0,
    status: 'delivered',
    address: 'المنطقة الصناعية بحلوان، القاهرة',
    paymentMethod: 'شيك مصرفي مقبول الدفع',
    trackingNumber: 'TRK-552147',
    shippingCompany: 'مصر للخدمات اللوجستية',
    currentLocation: 'مقر مصنع نسيجي الرئيسي',
    carrierStatus: 'تم تسليم الشحنة بنجاح وتوقيع الاستلام',
    estimatedArrival: '2026/07/05',
  ),
  OrderModel(
    id: 'ORD-205',
    rfqId: 'RFQ-105',
    supplierName: 'النساجون المتحدون',
    productName: 'صوف خام نيوزيلندي معالج',
    productImage: 'https://images.unsplash.com/photo-1513542789411-b6a5d4f31634',
    quantity: 1200,
    finalPrice: 94000.0,
    orderDate: '2026/07/12',
    expectedDeliveryDate: '2026/07/28',
    progressPercentage: 10.0,
    status: 'new',
    address: 'المنطقة الصناعية بقويسنا، المنوفية',
    paymentMethod: 'نقدًا عن طريق فوري للمدفوعات الرقمية',
    trackingNumber: 'TRK-334109',
    shippingCompany: 'فيدكس إكسبريس (FedEx)',
    currentLocation: 'المقر الرئيسي للمورد بقويسنا',
    carrierStatus: 'بانتظار تجهيز الطلب وبدء الإنتاج',
    estimatedArrival: '2026/07/28',
  ),
  OrderModel(
    id: 'ORD-206',
    rfqId: 'RFQ-106',
    supplierName: 'منسوجات الدلتا الكبرى',
    productName: 'أقمشة جينز الدنيم الثقيل',
    productImage: 'https://images.unsplash.com/photo-1541099649105-f69ad21f3246',
    quantity: 1000,
    finalPrice: 78000.0,
    orderDate: '2026/06/10',
    expectedDeliveryDate: '2026/06/25',
    progressPercentage: 0.0,
    status: 'cancelled',
    address: 'المنطقة الصناعية بالمحلة الكبرى',
    paymentMethod: 'بوابة الدفع الإلكتروني كاش',
    trackingNumber: 'غير متوفر',
    shippingCompany: 'غير محددة',
    currentLocation: 'تم إلغاء الطلب',
    carrierStatus: 'ملغي بسبب عدم مطابقة العينات المبدئية للوزن المعتمد',
    estimatedArrival: 'غير متوفر',
  ),
];

final Map<String, List<OrderTimelineItem>> _mockTimelines = {
  'ORD-201': [
    OrderTimelineItem(
      id: 'TL-1',
      stage: 'تم إنشاء الطلب',
      date: '2026/07/01',
      time: '10:00 ص',
      updatedBy: 'المهندس إبراهيم (المشتري)',
      notes: 'تم اعتماد الاتفاق الفني وإصدار أمر الشراء بنجاح.',
      attachments: ['مستند_أمر_الشراء_المعتمد.pdf'],
    ),
    OrderTimelineItem(
      id: 'TL-2',
      stage: 'تم قبول الطلب من المورد',
      date: '2026/07/02',
      time: '02:30 م',
      updatedBy: 'مصنع غزل المحلة (المورد)',
      notes: 'تمت مراجعة المواصفات والكمية وجاري إعداد المواد الخام.',
      attachments: ['فاتورة_المبيعات_الأولية.pdf'],
    ),
    OrderTimelineItem(
      id: 'TL-3',
      stage: 'بدء مرحلة الإنتاج الفعلي',
      date: '2026/07/05',
      time: '09:00 ص',
      updatedBy: 'مراقب الجودة بالمصنع',
      notes: 'تم شحن وتغذية مكينات الغزل وبدء العمل على خط الإنتاج الأول.',
      attachments: ['صورة_تجهيز_المكينات.jpg'],
    ),
    OrderTimelineItem(
      id: 'TL-4',
      stage: 'إتمام 30% من الإنتاج',
      date: '2026/07/08',
      time: '04:00 م',
      updatedBy: 'مصنع غزل المحلة (المورد)',
      notes: 'تم غزل ونفش الدفعة الأولى من الخيوط بنجاح ومطابقتها للمقاييس.',
      attachments: ['فيديو_الإنتاج_الأولي.mp4', 'صورة_مراقبة_الجودة.jpg'],
    ),
    OrderTimelineItem(
      id: 'TL-5',
      stage: 'إتمام 60% من الإنتاج',
      date: '2026/07/12',
      time: '11:00 ص',
      updatedBy: 'مشرف خط الغزل والتعبئة',
      notes: 'جاري تشغيل خط اللف والتعبئة على البكر البلاستيكي.',
      attachments: ['بكر_القطن_المكتمل.jpg'],
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
      return state.firstWhere((o) => o.id == orderId);
    } catch (_) {
      return null;
    }
  }

  void confirmDelivery(String orderId) {
    state = state.map((o) {
      if (o.id == orderId) {
        final updated = o.copyWith(
          status: 'delivered',
          progressPercentage: 100.0,
          currentLocation: 'مستودع المشتري النهائي',
          carrierStatus: 'تم الاستلام والاعتماد',
        );

        // Update Timeline
        ref.read(timelineNotifierProvider.notifier).addTimelineItem(
              orderId,
              stage: 'تم تسليم الطلب واعتماده',
              updatedBy: 'المهندس إبراهيم (المشتري)',
              notes: 'أكد مصنع نسيجي استلام الشحنة وتطابق جودتها للمواصفات المتعاقد عليها.',
              attachments: ['سند_الاستلام_الموقع.pdf'],
            );

        return updated;
      }
      return o;
    }).toList();
  }

  void reportProblem(String orderId, String reason, String description) {
    state = state.map((o) {
      if (o.id == orderId) {
        final updated = o.copyWith(
          status: 'cancelled',
          progressPercentage: 0.0,
          carrierStatus: 'موقوف / تحت النزاع',
        );

        // Update Timeline
        ref.read(timelineNotifierProvider.notifier).addTimelineItem(
              orderId,
              stage: 'تم الإبلاغ عن مشكلة ونزاع',
              updatedBy: 'المهندس إبراهيم (المشتري)',
              notes: 'السبب: $reason - التفاصيل: $description',
              attachments: ['صورة_الخلل_والعيوب.jpg'],
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

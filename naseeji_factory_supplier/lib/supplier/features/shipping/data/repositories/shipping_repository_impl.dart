import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/shipment.dart';
import '../../domain/repositories/shipping_repository.dart';

part 'shipping_repository_impl.g.dart';

class ShippingRepositoryImpl implements ShippingRepository {
  final List<Shipment> _mockShipments = [
    Shipment(
      id: 'SH-882200',
      orderNumber: 'ORD-9022',
      rfqNumber: 'RFQ-8820',
      factoryName: 'مصنع الرياض للملابس',
      factoryLogoText: 'RC',
      factoryLogoBgColorValue: 0xFF0040E0,
      productName: 'قماش قطن ١٠٠٪ فاخر للثياب',
      quantity: 5000,
      unit: 'متر',
      weight: 1250.0,
      volume: 4.8,
      cartons: 25,
      packages: 2,
      status: ShipmentStatus.ready,
      shippingCompany: 'أرامكس Aramex',
      trackingNumber: '',
      shippingMethod: 'شحن بري سريع (Aramex Ground)',
      vehicleNumber: 'أ ب ج ١٢٣٤',
      driverName: 'محمد العتيبي',
      driverPhone: '+٩٦٦ ٥٠ ١٢٣ ٤٥٦٧',
      estimatedDelivery: '15 يوليو 2026',
      deliveryAddress: 'مستودعات الرياض الصناعية - بوابة رقم ٣',
      priority: 'عالي جداً',
      lastUpdate: 'جاري مراجعة تغليف الشحنة وإثباتاتها من المورد',
      progress: 0.12,
      timeline: [
        const ShipmentTimelineEvent(
          time: '08:00 ص',
          date: '2026-07-05',
          status: 'تأكيد الإنتاج',
          user: 'المشتري (مصنع الرياض)',
          notes: 'تم اعتماد جودة الإنتاج والتغليف بنجاح.',
        ),
        const ShipmentTimelineEvent(
          time: '10:30 ص',
          date: '2026-07-05',
          status: 'إنشاء الشحنة',
          user: 'النظام اللوجستي نسيجي',
          notes: 'تم إنشاء سجل الشحنة وحجز الرقم المرجعي اللوجستي.',
        ),
      ],
      media: {
        'beforeShipment': [
          'https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?auto=format&fit=crop&w=300&q=80',
          'https://images.unsplash.com/photo-1530087964557-3aa5c55537e2?auto=format&fit=crop&w=300&q=80',
        ],
        'loading': [],
        'afterShipment': [],
      },
      documents: [
        const ShipmentDocument(
          type: 'فاتورة تجارية',
          name: 'Commercial_Invoice_8820.pdf',
          url: 'https://naseeji.com/docs/invoice_8820.pdf',
          version: 1,
          uploadedAt: '2026-07-05',
        ),
        const ShipmentDocument(
          type: 'بيان التعبئة',
          name: 'Packing_List_8820.pdf',
          url: 'https://naseeji.com/docs/packing_list_8820.pdf',
          version: 1,
          uploadedAt: '2026-07-05',
        ),
      ],
      cost: const ShipmentCost(
        shipping: 250.0,
        insurance: 50.0,
        taxes: 45.0,
        handling: 30.0,
        packaging: 20.0,
        other: 0.0,
      ),
      factoryConfirmation: null,
      issueReported: null,
    ),
    Shipment(
      id: 'SH-882201',
      orderNumber: 'ORD-8941',
      rfqNumber: 'RFQ-8794',
      factoryName: 'شركة الأزياء الموحدة',
      factoryLogoText: 'UF',
      factoryLogoBgColorValue: 0xFF16A34A,
      productName: 'نسيج خيوط الصوف الفاخر',
      quantity: 12500,
      unit: 'متر',
      weight: 3800.0,
      volume: 12.5,
      cartons: 80,
      packages: 5,
      status: ShipmentStatus.inTransit,
      shippingCompany: 'دي إتش إل DHL',
      trackingNumber: 'DHL-8877221199',
      shippingMethod: 'شحن سريع دولي (DHL Express)',
      vehicleNumber: 'د ر س ٩٩٨٨',
      driverName: 'أحمد مراد',
      driverPhone: '+٩٦٦ ٥٤ ٧٦٥ ٤٣٢١',
      estimatedDelivery: '10 يوليو 2026',
      deliveryAddress: 'مستودعات جدة الرئيسية - ميناء جدة الإسلامي',
      priority: 'عادي',
      lastUpdate: 'غادرت الشحنة نقطة الفرز الفرعية بالرياض في طريقها لجدة',
      progress: 0.65,
      timeline: [
        const ShipmentTimelineEvent(
          time: '09:00 ص',
          date: '2026-07-01',
          status: 'اعتماد شروط الشحن',
          user: 'المورد (مورد نسيجي)',
          notes: 'تم توقيع الفاتورة وتأكيد تحميل المستندات الرسمية.',
        ),
        const ShipmentTimelineEvent(
          time: '02:15 م',
          date: '2026-07-02',
          status: 'جدولة واستلام الشحنة',
          user: 'ناقل الشحن (DHL)',
          notes: 'استلم المندوب الشحنة من مستودع المورد بنجاح وجاري فحص التغليف.',
        ),
        const ShipmentTimelineEvent(
          time: '06:00 ص',
          date: '2026-07-03',
          status: 'في الطريق',
          user: 'مركز فرز DHL الرياض',
          notes: 'تم مغادرة مركز الفرز وجاري الترانزيت إلى مدينة جدة.',
        ),
      ],
      media: {
        'beforeShipment': [
          'https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?auto=format&fit=crop&w=300&q=80',
        ],
        'loading': [
          'https://images.unsplash.com/photo-1578575437130-527eed3abbec?auto=format&fit=crop&w=300&q=80',
        ],
        'afterShipment': [],
      },
      documents: [
        const ShipmentDocument(
          type: 'بوليصة الشحن',
          name: 'Bill_of_Lading_8794.pdf',
          url: 'https://naseeji.com/docs/bol_8794.pdf',
          version: 2,
          uploadedAt: '2026-07-02',
        ),
        const ShipmentDocument(
          type: 'فاتورة تجارية',
          name: 'Commercial_Invoice_8794.pdf',
          url: 'https://naseeji.com/docs/invoice_8794.pdf',
          version: 1,
          uploadedAt: '2026-07-01',
        ),
      ],
      cost: const ShipmentCost(
        shipping: 850.0,
        insurance: 150.0,
        taxes: 127.5,
        handling: 80.0,
        packaging: 50.0,
        other: 20.0,
      ),
      factoryConfirmation: null,
      issueReported: null,
    ),
    Shipment(
      id: 'SH-882202',
      orderNumber: 'ORD-8710',
      rfqNumber: 'RFQ-8710',
      factoryName: 'مصنع الدمام للملابس',
      factoryLogoText: 'DC',
      factoryLogoBgColorValue: 0xFF4B5563,
      productName: 'قماش الكتان العضوي الفاخر',
      quantity: 3200,
      unit: 'متر',
      weight: 980.0,
      volume: 3.5,
      cartons: 18,
      packages: 1,
      status: ShipmentStatus.delivered,
      shippingCompany: 'سمسا SMSA Express',
      trackingNumber: 'SMSA-77665544',
      shippingMethod: 'شحن محلي سريع (SMSA Express)',
      vehicleNumber: 'ع د ن ٥٥٤٤',
      driverName: 'ياسر القحطاني',
      driverPhone: '+٩٦٦ ٥٦ ٤٤٣ ٣٢٢١',
      estimatedDelivery: '28 يونيو 2026',
      deliveryAddress: 'الدمام - المنطقة الصناعية الثانية - شارع الميناء',
      priority: 'عادي',
      lastUpdate: 'تم تأكيد الاستلام من قبل المصنع ومطابقة جودة الشحنة بالكامل',
      progress: 1.0,
      timeline: [
        const ShipmentTimelineEvent(
          time: '08:00 ص',
          date: '2026-06-25',
          status: 'تم التحميل',
          user: 'مورد نسيجي',
          notes: 'تم تحميل جميع الحاويات وتسليمها لمندوب سمسا.',
        ),
        const ShipmentTimelineEvent(
          time: '04:30 م',
          date: '2026-06-27',
          status: 'وصلت الوجهة',
          user: 'الناقل (SMSA)',
          notes: 'وصلت المركبة لمركز التفتيش والاستلام بمصنع الدمام.',
        ),
        const ShipmentTimelineEvent(
          time: '11:15 ص',
          date: '2026-06-28',
          status: 'تم التسليم للمشتري',
          user: 'المشتري (مصنع الدمام)',
          notes: 'تم استلام وتوقيع بوليصة تسليم الشحنة من قبل المستودع.',
        ),
      ],
      media: {
        'beforeShipment': [
          'https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?auto=format&fit=crop&w=300&q=80',
        ],
        'loading': [
          'https://images.unsplash.com/photo-1578575437130-527eed3abbec?auto=format&fit=crop&w=300&q=80',
        ],
        'afterShipment': [
          'https://images.unsplash.com/photo-1580674684081-7617fbf3d745?auto=format&fit=crop&w=300&q=80',
        ],
      },
      documents: [
        const ShipmentDocument(
          type: 'فاتورة تجارية',
          name: 'Commercial_Invoice_8710.pdf',
          url: 'https://naseeji.com/docs/invoice_8710.pdf',
          version: 1,
          uploadedAt: '2026-06-24',
        ),
        const ShipmentDocument(
          type: 'مستندات الاستلام',
          name: 'Delivery_Receipt_8710.pdf',
          url: 'https://naseeji.com/docs/receipt_8710.pdf',
          version: 1,
          uploadedAt: '2026-06-28',
        ),
      ],
      cost: const ShipmentCost(
        shipping: 200.0,
        insurance: 30.0,
        taxes: 34.5,
        handling: 20.0,
        packaging: 15.0,
        other: 0.0,
      ),
      factoryConfirmation: const FactoryConfirmation(
        received: true,
        inspectionStatus: 'مقبول بالكامل',
        acceptedQty: 3200,
        rejectedQty: 0,
        notes: 'الخامات مطابقة تماماً للمواصفات وخالية من أي رطوبة أو تمزق.',
        images: [
          'https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?auto=format&fit=crop&w=300&q=80',
        ],
        feedback: 'خدمة شحن وتعبئة ممتازة وسريعة، شكراً للمورد نسيجي.',
      ),
      issueReported: null,
    ),
  ];

  @override
  Future<List<Shipment>> getShipments() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_mockShipments);
  }

  @override
  Future<Shipment?> getShipmentDetails(String id) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final index = _mockShipments.indexWhere((s) => s.id == id);
    if (index != -1) {
      return _mockShipments[index];
    }
    return null;
  }

  @override
  Future<void> updateShipmentStatus(String id, ShipmentStatus status) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _mockShipments.indexWhere((s) => s.id == id);
    if (index != -1) {
      final current = _mockShipments[index];
      
      String statusLabel = '';
      String note = '';
      double progress = current.progress;

      switch (status) {
        case ShipmentStatus.loaded:
          statusLabel = 'تم التحميل';
          note = 'تم الانتهاء من تحميل الكرتونات وتجهيز بيان النقل.';
          progress = 0.25;
          break;
        case ShipmentStatus.pickedUp:
          statusLabel = 'تم الاستلام';
          note = 'استلم مندوب شركة الشحن البضائع وبدأت الحركة لوجستياً.';
          progress = 0.40;
          break;
        case ShipmentStatus.inTransit:
          statusLabel = 'في الطريق';
          note = 'الشحنة غادرت مركز الفرز الرئيسي للناقل.';
          progress = 0.65;
          break;
        case ShipmentStatus.arrived:
          statusLabel = 'وصلت الوجهة';
          note = 'وصلت الناقلة لنقاط الفحص الفني والاستلام في مستودعات المشتري.';
          progress = 0.85;
          break;
        case ShipmentStatus.delivered:
          statusLabel = 'تم التسليم للمشتري';
          note = 'تم استلام وتأكيد الشحنة وتوقيع بوليصة تسليم الشحنة.';
          progress = 0.95;
          break;
        case ShipmentStatus.paymentPending:
          statusLabel = 'انتظار تحرير الدفعة';
          note = 'تم مطابقة الشحنة وجاري تجهيز تسوية الدفعة المالية المربوطة.';
          progress = 0.98;
          break;
        case ShipmentStatus.completed:
          statusLabel = 'مكتمل';
          note = 'تم الإفراج النهائي عن مستحقات الشحنة البنكية بنجاح.';
          progress = 1.0;
          break;
        default:
          statusLabel = 'جاهز';
          note = 'تم تهيئة الشحنة بانتظار الناقل.';
          progress = 0.12;
      }

      final DateTime now = DateTime.now();
      final timelineEvent = ShipmentTimelineEvent(
        time: '${now.hour}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? "م" : "ص"}',
        date: '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}',
        status: statusLabel,
        user: 'النظام اللوجستي نسيجي',
        notes: note,
      );

      final List<ShipmentTimelineEvent> updatedTimeline = List.from(current.timeline)..add(timelineEvent);

      _mockShipments[index] = current.copyWith(
        status: status,
        progress: progress,
        timeline: updatedTimeline,
        lastUpdate: note,
      );
    }
  }

  @override
  Future<void> schedulePickup(String id, {required String driverName, required String driverPhone, required String vehicleNum}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _mockShipments.indexWhere((s) => s.id == id);
    if (index != -1) {
      final current = _mockShipments[index];
      final DateTime now = DateTime.now();

      final timelineEvent = ShipmentTimelineEvent(
        time: '${now.hour}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? "م" : "ص"}',
        date: '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}',
        status: 'جدولة واستلام الشحنة',
        user: 'المورد (مورد نسيجي)',
        notes: 'تم جدولة موعد الاستلام وتعيين السائق: $driverName هاتف: $driverPhone لوحة: $vehicleNum',
      );

      final List<ShipmentTimelineEvent> updatedTimeline = List.from(current.timeline)..add(timelineEvent);

      _mockShipments[index] = current.copyWith(
        driverName: driverName,
        driverPhone: driverPhone,
        vehicleNumber: vehicleNum,
        status: ShipmentStatus.pickedUp,
        progress: 0.40,
        timeline: updatedTimeline,
        lastUpdate: 'تم جدولة الشحنة بنجاح وبانتظار وصول مندوب الناقل.',
      );
    }
  }

  @override
  Future<void> selectCarrier(String id, {required String carrier, required String method}) async {
    await Future.delayed(const Duration(milliseconds: 350));
    final index = _mockShipments.indexWhere((s) => s.id == id);
    if (index != -1) {
      final current = _mockShipments[index];
      
      double shippingCost = current.cost.shipping;
      if (carrier.contains('DHL')) {
        shippingCost = 450.0;
      } else if (carrier.contains('SMSA')) {
        shippingCost = 180.0;
      } else {
        shippingCost = 250.0;
      }

      final DateTime now = DateTime.now();
      final timelineEvent = ShipmentTimelineEvent(
        time: '${now.hour}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? "م" : "ص"}',
        date: '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}',
        status: 'تحديث الناقل',
        user: 'مورد نسيجي',
        notes: 'تم اختيار شركة الشحن: $carrier بطريقة شحن: $method',
      );

      _mockShipments[index] = current.copyWith(
        shippingCompany: carrier,
        shippingMethod: method,
        cost: current.cost.copyWith(shipping: shippingCost),
        timeline: List.from(current.timeline)..add(timelineEvent),
      );
    }
  }

  @override
  Future<void> uploadMedia(String id, String category, String path) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _mockShipments.indexWhere((s) => s.id == id);
    if (index != -1) {
      final current = _mockShipments[index];
      final currentMedia = Map<String, List<String>>.from(current.media);
      final list = List<String>.from(currentMedia[category] ?? [])..add(path);
      currentMedia[category] = list;

      final DateTime now = DateTime.now();
      final timelineEvent = ShipmentTimelineEvent(
        time: '${now.hour}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? "م" : "ص"}',
        date: '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}',
        status: 'إرفاق إثباتات الشحن',
        user: 'مورد نسيجي',
        notes: 'تم رفع صورة إثبات شحن جديدة وتصنيفها كـ $category',
      );

      _mockShipments[index] = current.copyWith(
        media: currentMedia,
        timeline: List.from(current.timeline)..add(timelineEvent),
      );
    }
  }

  @override
  Future<void> uploadDocument(String id, String type, String name, String url) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final index = _mockShipments.indexWhere((s) => s.id == id);
    if (index != -1) {
      final current = _mockShipments[index];
      
      final docIndex = current.documents.indexWhere((doc) => doc.type == type);
      final List<ShipmentDocument> updatedDocs = List.from(current.documents);

      final DateTime now = DateTime.now();
      final String todayStr = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

      if (docIndex != -1) {
        final existing = current.documents[docIndex];
        updatedDocs[docIndex] = existing.copyWith(
          name: name,
          url: url,
          version: existing.version + 1,
          uploadedAt: todayStr,
        );
      } else {
        updatedDocs.add(ShipmentDocument(
          type: type,
          name: name,
          url: url,
          version: 1,
          uploadedAt: todayStr,
        ));
      }

      final timelineEvent = ShipmentTimelineEvent(
        time: '${now.hour}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? "م" : "ص"}',
        date: todayStr,
        status: 'رفع المستندات',
        user: 'مورد نسيجي',
        notes: 'تم رفع نسخة مستند جديدة لـ $type باسم: $name',
      );

      _mockShipments[index] = current.copyWith(
        documents: updatedDocs,
        timeline: List.from(current.timeline)..add(timelineEvent),
      );
    }
  }

  @override
  Future<void> reportIssue(String id, {required String category, required String description, required String priority, List<String> attachments = const []}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _mockShipments.indexWhere((s) => s.id == id);
    if (index != -1) {
      final current = _mockShipments[index];
      final DateTime now = DateTime.now();

      final timelineEvent = ShipmentTimelineEvent(
        time: '${now.hour}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? "م" : "ص"}',
        date: '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}',
        status: 'تسجيل بلاغ لوجستي',
        user: 'مورد نسيجي',
        notes: 'تم فتح بلاغ/إشكالية شحن - نوع: $category، الأولوية: $priority. التفاصيل: $description',
      );

      _mockShipments[index] = current.copyWith(
        issueReported: description,
        priority: priority,
        timeline: List.from(current.timeline)..add(timelineEvent),
        lastUpdate: 'تنبيه: تم تسجيل بلاغ إشكالية شحن - جاري المراجعة اللوجستية.',
      );
    }
  }
}

@riverpod
ShippingRepository shippingRepository(ShippingRepositoryRef ref) {
  return ShippingRepositoryImpl();
}



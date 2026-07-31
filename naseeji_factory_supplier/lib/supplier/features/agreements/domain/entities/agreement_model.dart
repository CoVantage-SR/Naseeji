import 'package:flutter/material.dart';

/// حالات الاتفاق الثمانية
enum AgreementStatus {
  draft,                     // مسودة
  awaitingSupplierSignature, // بانتظار توقيع المورد
  awaitingFactorySignature,  // بانتظار توقيع المصنع
  active,                    // ساري
  inProduction,              // قيد التنفيذ
  completed,                 // مكتمل
  cancelled,                 // ملغي
  expired,                   // منتهي
}

extension AgreementStatusX on AgreementStatus {
  String get titleAr {
    switch (this) {
      case AgreementStatus.draft:
        return 'مسودة';
      case AgreementStatus.awaitingSupplierSignature:
        return 'بانتظار توقيع المورد';
      case AgreementStatus.awaitingFactorySignature:
        return 'بانتظار توقيع المصنع';
      case AgreementStatus.active:
        return 'ساري';
      case AgreementStatus.inProduction:
        return 'قيد التنفيذ';
      case AgreementStatus.completed:
        return 'مكتمل';
      case AgreementStatus.cancelled:
        return 'ملغي';
      case AgreementStatus.expired:
        return 'منتهي';
    }
  }

  String get descriptionEg {
    switch (this) {
      case AgreementStatus.draft:
        return 'مسودة اتفاقية مبدئية جارٍ إعدادها مسبقاً قبل الإرسال للتوقيع.';
      case AgreementStatus.awaitingSupplierSignature:
        return 'الاتفاقية جاهزة ومطلوب توقيع المورد لبدء الإجراءات الرسمية.';
      case AgreementStatus.awaitingFactorySignature:
        return 'تم توقيع المورد بنجاح وفي انتظار توقيع واعتماد المصنع.';
      case AgreementStatus.active:
        return 'الاتفاق ساري وموثق رسمياً بين الطرفين وتم إصدار أمر الإنتاج.';
      case AgreementStatus.inProduction:
        return 'بدأت عملية التصنيع والإنتاج بالكامل بالمصنع طبقاً للشروط.';
      case AgreementStatus.completed:
        return 'تم استلام الشحنة وإكمال الاتفاق وسداد كافة التكاليف بنجاح.';
      case AgreementStatus.cancelled:
        return 'تم إلغاء الاتفاقية بطلب أحد الطرفين مع توثيق السبب.';
      case AgreementStatus.expired:
        return 'انتهت فترة صلاحية العقد قبل التوقيع النهائي.';
    }
  }

  Color get color {
    switch (this) {
      case AgreementStatus.draft:
        return const Color(0xFF6B7280); // Grey
      case AgreementStatus.awaitingSupplierSignature:
        return const Color(0xFFEAB308); // Yellow / Amber
      case AgreementStatus.awaitingFactorySignature:
        return const Color(0xFFF97316); // Orange
      case AgreementStatus.active:
        return const Color(0xFF2563EB); // Blue
      case AgreementStatus.inProduction:
        return const Color(0xFF8B5CF6); // Purple
      case AgreementStatus.completed:
        return const Color(0xFF16A34A); // Green
      case AgreementStatus.cancelled:
        return const Color(0xFFDC2626); // Red
      case AgreementStatus.expired:
        return const Color(0xFF9CA3AF); // Muted Grey
    }
  }

  IconData get icon {
    switch (this) {
      case AgreementStatus.draft:
        return Icons.edit_note_outlined;
      case AgreementStatus.awaitingSupplierSignature:
        return Icons.draw_outlined;
      case AgreementStatus.awaitingFactorySignature:
        return Icons.history_edu_outlined;
      case AgreementStatus.active:
        return Icons.verified_outlined;
      case AgreementStatus.inProduction:
        return Icons.precision_manufacturing_outlined;
      case AgreementStatus.completed:
        return Icons.check_circle_outline;
      case AgreementStatus.cancelled:
        return Icons.cancel_outlined;
      case AgreementStatus.expired:
        return Icons.timer_off_outlined;
    }
  }

  int get stepIndex {
    switch (this) {
      case AgreementStatus.draft:
        return 0;
      case AgreementStatus.awaitingSupplierSignature:
        return 1;
      case AgreementStatus.awaitingFactorySignature:
        return 2;
      case AgreementStatus.active:
        return 3;
      case AgreementStatus.inProduction:
        return 4;
      case AgreementStatus.completed:
        return 5;
      case AgreementStatus.cancelled:
      case AgreementStatus.expired:
        return -1;
    }
  }
}

/// سجل توقيع طرف في الاتفاق
class SignatureInfo {
  final String userName;
  final String userId;
  final String date;
  final String time;
  final bool isSigned;

  const SignatureInfo({
    required this.userName,
    required this.userId,
    required this.date,
    required this.time,
    required this.isSigned,
  });

  SignatureInfo copyWith({
    String? userName,
    String? userId,
    String? date,
    String? time,
    bool? isSigned,
  }) {
    return SignatureInfo(
      userName: userName ?? this.userName,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      time: time ?? this.time,
      isSigned: isSigned ?? this.isSigned,
    );
  }
}

/// بيانات المورد (الطرف الأول)
class SupplierInfo {
  final String logoText;
  final int logoBgColorValue;
  final String companyName;
  final String supplierName;
  final String phone;
  final String email;
  final String address;
  final double rating;
  final bool verified;

  const SupplierInfo({
    required this.logoText,
    required this.logoBgColorValue,
    required this.companyName,
    required this.supplierName,
    required this.phone,
    required this.email,
    required this.address,
    required this.rating,
    required this.verified,
  });
}

/// بيانات المصنع (الطرف الثاني)
class FactoryInfo {
  final String logoText;
  final int logoBgColorValue;
  final String factoryName;
  final String contactPerson;
  final String phone;
  final String email;
  final String address;
  final double rating;

  const FactoryInfo({
    required this.logoText,
    required this.logoBgColorValue,
    required this.factoryName,
    required this.contactPerson,
    required this.phone,
    required this.email,
    required this.address,
    required this.rating,
  });
}

/// القسم الأول: ملخص الصفقة والمنتج
class AgreementProduct {
  final String imageUrl;
  final String name;
  final String sku;
  final String category;
  final String specifications;
  final String countryOfOrigin;
  final int quantity;
  final String unit;
  final double unitPrice;
  final double totalPrice;
  final String currency;
  final String packagingDetails;

  const AgreementProduct({
    required this.imageUrl,
    required this.name,
    required this.sku,
    required this.category,
    required this.specifications,
    required this.countryOfOrigin,
    required this.quantity,
    required this.unit,
    required this.unitPrice,
    required this.totalPrice,
    required this.currency,
    required this.packagingDetails,
  });
}

/// القسم الثاني: الإنتاج
class ProductionInfo {
  final String productionDuration; // مدة الإنتاج (مثال: ٣٠ يوم عمل)
  final String startDate;          // تاريخ البداية
  final String endDate;            // تاريخ الانتهاء
  final String readyDate;          // موعد جاهزية الطلب

  const ProductionInfo({
    required this.productionDuration,
    required this.startDate,
    required this.endDate,
    required this.readyDate,
  });
}

/// القسم الثالث: الدفع
class PaymentInfo {
  final String method;             // طريقة الدفع
  final double advancePercentage;  // نسبة الدفعة المقدمة (مثال: ٣٠٪)
  final double advanceAmount;      // قيمة الدفعة
  final String paymentDueDate;     // موعد السداد
  final double remainingAmount;    // المبلغ المتبقي
  final String currency;

  const PaymentInfo({
    required this.method,
    required this.advancePercentage,
    required this.advanceAmount,
    required this.paymentDueDate,
    required this.remainingAmount,
    required this.currency,
  });
}

/// القسم الرابع: التسليم
class DeliveryInfo {
  final String pickupLocation;     // مكان الاستلام
  final String shipmentReadyDate;  // موعد جاهزية الشحنة
  final String deliveryStatus;     // حالة التسليم
  final String shippingCompanyNote;// ملاحظة شركة الشحن

  const DeliveryInfo({
    required this.pickupLocation,
    required this.shipmentReadyDate,
    required this.deliveryStatus,
    required this.shippingCompanyNote,
  });
}

/// القسم الخامس: الشروط القياسية للمنصة
class AgreementTerms {
  final List<String> standardTerms;

  const AgreementTerms({
    required this.standardTerms,
  });

  static const AgreementTerms defaultTerms = AgreementTerms(
    standardTerms: [
      'جميع المحادثات والاتفاقات تتم بشكل رسمي وتوثيقي داخل منصة نسيجي.',
      'يمنع منعاً باتاً تبادل وسائل التواصل الخارجية أو العمل خارج المنصة ضماناً لحقوق الطرفين.',
      'يتم تحويل المستحقات المالية وحجزها في حساب الضمان البنكي وإصدارها بعد تأكيد الاستلام والتسليم.',
      'في حالة وجود أي نزاع أو عدم مطابقة للمواصفات، يتم فتح طلب مراجعة رسمي وإحالة الملف لإدارة المنصة.',
    ],
  );
}

/// القسم السادس: المرفقات
class AgreementDocument {
  final String id;
  final String name;
  final String type; // عرض السعر، الكتالوج، PDF، شهادات الجودة، صور
  final String url;
  final String size;
  final int version;
  final String uploadedAt;

  const AgreementDocument({
    required this.id,
    required this.name,
    required this.type,
    required this.url,
    required this.size,
    required this.version,
    required this.uploadedAt,
  });

  AgreementDocument copyWith({
    String? id,
    String? name,
    String? type,
    String? url,
    String? size,
    int? version,
    String? uploadedAt,
  }) {
    return AgreementDocument(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      url: url ?? this.url,
      size: size ?? this.size,
      version: version ?? this.version,
      uploadedAt: uploadedAt ?? this.uploadedAt,
    );
  }
}

/// السجل والخط الزمني للاتفاق
class AgreementTimelineStep {
  final String date;
  final String time;
  final String user;
  final List<String> attachments;
  final String status;
  final String notes;

  const AgreementTimelineStep({
    required this.date,
    required this.time,
    required this.user,
    required this.attachments,
    required this.status,
    required this.notes,
  });
}

class AgreementHistoryRecord {
  final String timestamp;
  final String user;
  final String action;
  final String reason;
  final String versionNumber;

  const AgreementHistoryRecord({
    required this.timestamp,
    required this.user,
    required this.action,
    required this.reason,
    required this.versionNumber,
  });
}

/// النموذج الكلي للاتفاق (B2B Agreement)
class B2BAgreement {
  final String id;                  // رقم الاتفاق (مثال: AGR-2026-105)
  final String rfqNumber;           // رقم RFQ (مثال: RFQ-8820)
  final String quotationNumber;     // رقم عرض السعر (مثال: QUO-9912)
  final String orderNumber;         // رقم الطلب (مثال: ORD-9022)
  final String createdDate;         // تاريخ إنشاء الاتفاق
  final String lastUpdated;         // آخر تحديث
  final String version;             // إصدار الاتفاقية (v1.0)
  final AgreementStatus status;     // حالة الاتفاقية
  final SupplierInfo supplierInfo;  // بيانات المورد
  final FactoryInfo factoryInfo;   // بيانات المصنع
  final AgreementProduct product;   // ملخص الصفقة والمنتج (القسم ١)
  final ProductionInfo production;  // بيانات الإنتاج (القسم ٢)
  final PaymentInfo payment;        // بيانات الدفع (القسم ٣)
  final DeliveryInfo delivery;      // بيانات التسليم (القسم ٤)
  final AgreementTerms terms;       // الشروط القياسية (القسم ٥)
  final List<AgreementDocument> documents; // المرفقات (القسم ٦)
  final SignatureInfo? supplierSignature;  // توقيع المورد (القسم ٧)
  final SignatureInfo? factorySignature;   // توقيع المصنع (القسم ٧)
  final List<AgreementTimelineStep> timeline;
  final List<AgreementHistoryRecord> history;
  final String? productionOrderId; // رقم أمر الإنتاج الصادر بعد تفعيل الاتفاق
  final String? cancellationReason;

  const B2BAgreement({
    required this.id,
    required this.rfqNumber,
    required this.quotationNumber,
    required this.orderNumber,
    required this.createdDate,
    required this.lastUpdated,
    required this.version,
    required this.status,
    required this.supplierInfo,
    required this.factoryInfo,
    required this.product,
    required this.production,
    required this.payment,
    required this.delivery,
    required this.terms,
    required this.documents,
    this.supplierSignature,
    this.factorySignature,
    required this.timeline,
    required this.history,
    this.productionOrderId,
    this.cancellationReason,
  });

  bool get isQuotationLocked =>
      status != AgreementStatus.draft &&
      status != AgreementStatus.awaitingSupplierSignature;

  bool get isNegotiationLocked =>
      status == AgreementStatus.active ||
      status == AgreementStatus.inProduction ||
      status == AgreementStatus.completed;

  bool get canSupplierSign =>
      status == AgreementStatus.awaitingSupplierSignature &&
      (supplierSignature == null || !supplierSignature!.isSigned);

  bool get canFactorySign =>
      status == AgreementStatus.awaitingFactorySignature &&
      (factorySignature == null || !factorySignature!.isSigned);

  B2BAgreement copyWith({
    String? id,
    String? rfqNumber,
    String? quotationNumber,
    String? orderNumber,
    String? createdDate,
    String? lastUpdated,
    String? version,
    AgreementStatus? status,
    SupplierInfo? supplierInfo,
    FactoryInfo? factoryInfo,
    AgreementProduct? product,
    ProductionInfo? production,
    PaymentInfo? payment,
    DeliveryInfo? delivery,
    AgreementTerms? terms,
    List<AgreementDocument>? documents,
    SignatureInfo? supplierSignature,
    SignatureInfo? factorySignature,
    List<AgreementTimelineStep>? timeline,
    List<AgreementHistoryRecord>? history,
    String? productionOrderId,
    String? cancellationReason,
  }) {
    return B2BAgreement(
      id: id ?? this.id,
      rfqNumber: rfqNumber ?? this.rfqNumber,
      quotationNumber: quotationNumber ?? this.quotationNumber,
      orderNumber: orderNumber ?? this.orderNumber,
      createdDate: createdDate ?? this.createdDate,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      version: version ?? this.version,
      status: status ?? this.status,
      supplierInfo: supplierInfo ?? this.supplierInfo,
      factoryInfo: factoryInfo ?? this.factoryInfo,
      product: product ?? this.product,
      production: production ?? this.production,
      payment: payment ?? this.payment,
      delivery: delivery ?? this.delivery,
      terms: terms ?? this.terms,
      documents: documents ?? this.documents,
      supplierSignature: supplierSignature ?? this.supplierSignature,
      factorySignature: factorySignature ?? this.factorySignature,
      timeline: timeline ?? this.timeline,
      history: history ?? this.history,
      productionOrderId: productionOrderId ?? this.productionOrderId,
      cancellationReason: cancellationReason ?? this.cancellationReason,
    );
  }
}




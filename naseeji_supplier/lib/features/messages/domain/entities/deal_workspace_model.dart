import 'package:naseeji_supplier/features/messages/domain/entities/deal_status_enum.dart';
import 'package:naseeji_supplier/features/messages/domain/entities/deal_quotation_model.dart';
import 'package:naseeji_supplier/features/messages/domain/entities/deal_agreement_model.dart';
import 'package:naseeji_supplier/features/messages/domain/entities/deal_file_model.dart';
import 'package:naseeji_supplier/features/messages/domain/entities/deal_timeline_model.dart';
import 'package:naseeji_supplier/features/messages/domain/entities/business_message.dart';

class DealWorkspaceModel {
  final String dealId;
  final String orderId;
  final String rfqId;
  final String productName;
  final double dealValue;
  final int totalQuantity;
  final String factoryName;
  final String factoryAvatarUrl;
  final bool isFactoryOnline;
  final bool isFactoryVerified;
  final DealStatus currentStatus;
  final DateTime lastUpdated;

  final List<BusinessMessage> messages;
  final DealQuotationModel latestQuotation;
  final List<DealQuotationModel> quotationHistory; // جميع إصدارات العروض
  final DealAgreementModel? finalAgreement;
  final List<DealFileModel> files;
  final DealTimelineModel timeline;

  const DealWorkspaceModel({
    required this.dealId,
    required this.orderId,
    required this.rfqId,
    this.productName = 'غزل قطن 100% ممتاز تمشيط عالي',
    this.dealValue = 215000.0,
    this.totalQuantity = 5000,
    required this.factoryName,
    required this.factoryAvatarUrl,
    required this.isFactoryOnline,
    required this.isFactoryVerified,
    required this.currentStatus,
    DateTime? lastUpdated,
    required this.messages,
    required this.latestQuotation,
    List<DealQuotationModel>? quotationHistory,
    this.finalAgreement,
    required this.files,
    required this.timeline,
  })  : lastUpdated = lastUpdated ?? DateTime.now(),
        quotationHistory = quotationHistory ?? (latestQuotation != null ? [latestQuotation] : const []);

  DealWorkspaceModel copyWith({
    String? productName,
    double? dealValue,
    int? totalQuantity,
    DealStatus? currentStatus,
    DateTime? lastUpdated,
    List<BusinessMessage>? messages,
    DealQuotationModel? latestQuotation,
    List<DealQuotationModel>? quotationHistory,
    DealAgreementModel? finalAgreement,
    List<DealFileModel>? files,
    DealTimelineModel? timeline,
  }) {
    return DealWorkspaceModel(
      dealId: dealId,
      orderId: orderId,
      rfqId: rfqId,
      productName: productName ?? this.productName,
      dealValue: dealValue ?? this.dealValue,
      totalQuantity: totalQuantity ?? this.totalQuantity,
      factoryName: factoryName,
      factoryAvatarUrl: factoryAvatarUrl,
      isFactoryOnline: isFactoryOnline,
      isFactoryVerified: isFactoryVerified,
      currentStatus: currentStatus ?? this.currentStatus,
      lastUpdated: lastUpdated ?? DateTime.now(),
      messages: messages ?? this.messages,
      latestQuotation: latestQuotation ?? this.latestQuotation,
      quotationHistory: quotationHistory ?? this.quotationHistory,
      finalAgreement: finalAgreement ?? this.finalAgreement,
      files: files ?? this.files,
      timeline: timeline ?? this.timeline,
    );
  }
}

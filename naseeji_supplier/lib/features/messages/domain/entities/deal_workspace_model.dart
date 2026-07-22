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
  final String factoryName;
  final String factoryAvatarUrl;
  final bool isFactoryOnline;
  final bool isFactoryVerified;
  final DealStatus currentStatus;

  final List<BusinessMessage> messages;
  final DealQuotationModel latestQuotation;
  final DealAgreementModel finalAgreement;
  final List<DealFileModel> files;
  final DealTimelineModel timeline;

  const DealWorkspaceModel({
    required this.dealId,
    required this.orderId,
    required this.rfqId,
    required this.factoryName,
    required this.factoryAvatarUrl,
    required this.isFactoryOnline,
    required this.isFactoryVerified,
    required this.currentStatus,
    required this.messages,
    required this.latestQuotation,
    required this.finalAgreement,
    required this.files,
    required this.timeline,
  });

  DealWorkspaceModel copyWith({
    DealStatus? currentStatus,
    List<BusinessMessage>? messages,
    DealQuotationModel? latestQuotation,
    DealAgreementModel? finalAgreement,
    List<DealFileModel>? files,
    DealTimelineModel? timeline,
  }) {
    return DealWorkspaceModel(
      dealId: dealId,
      orderId: orderId,
      rfqId: rfqId,
      factoryName: factoryName,
      factoryAvatarUrl: factoryAvatarUrl,
      isFactoryOnline: isFactoryOnline,
      isFactoryVerified: isFactoryVerified,
      currentStatus: currentStatus ?? this.currentStatus,
      messages: messages ?? this.messages,
      latestQuotation: latestQuotation ?? this.latestQuotation,
      finalAgreement: finalAgreement ?? this.finalAgreement,
      files: files ?? this.files,
      timeline: timeline ?? this.timeline,
    );
  }
}

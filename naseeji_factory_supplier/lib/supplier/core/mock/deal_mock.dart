import '../../features/messages/domain/entities/deal_status_enum.dart';
import '../../features/messages/domain/entities/deal_workspace_model.dart';
import '../../features/messages/domain/entities/deal_file_model.dart';
import 'quotation_mock.dart';
import 'message_mock.dart';
import 'agreement_mock.dart';
import 'timeline_mock.dart';

class DealMock {
  final String dealId;
  final String orderId;
  final String rfqId;
  final String productId;
  final String supplierId;
  final String productName;
  final double dealValue;
  final int totalQuantity;
  final String factoryName;
  final String factoryAvatarUrl;
  final bool isFactoryOnline;
  final bool isFactoryVerified;
  final DealStatus currentStatus;
  final DateTime lastUpdated;

  const DealMock({
    required this.dealId,
    required this.orderId,
    required this.rfqId,
    required this.productId,
    required this.supplierId,
    required this.productName,
    required this.dealValue,
    required this.totalQuantity,
    required this.factoryName,
    required this.factoryAvatarUrl,
    this.isFactoryOnline = true,
    this.isFactoryVerified = true,
    required this.currentStatus,
    required this.lastUpdated,
  });

  DealWorkspaceModel toWorkspaceDomain({
    required List<MessageMock> messages,
    required List<QuotationMock> quotations,
    required AgreementMock? agreement,
    required TimelineMock timeline,
  }) {
    final domainQuos = quotations.map((q) => q.toDomain()).toList();
    final domainMsgs = messages.map((m) => m.toDomain()).toList();

    return DealWorkspaceModel(
      dealId: dealId,
      orderId: orderId,
      rfqId: rfqId,
      productName: productName,
      dealValue: dealValue,
      totalQuantity: totalQuantity,
      factoryName: factoryName,
      factoryAvatarUrl: factoryAvatarUrl,
      isFactoryOnline: isFactoryOnline,
      isFactoryVerified: isFactoryVerified,
      currentStatus: currentStatus,
      lastUpdated: lastUpdated,
      messages: domainMsgs,
      latestQuotation: domainQuos.last,
      quotationHistory: domainQuos,
      finalAgreement: agreement?.toDomain(),
      files: [
        DealFileModel(
          fileId: 'f-1',
          fileName: 'كتالوج_خيوط_الغزل_الممشط_2026.pdf',
          fileUrl: 'https://example.com/docs/catalog.pdf',
          fileSize: '4.2 MB',
          fileType: DealFileType.catalog,
          uploadedAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
        DealFileModel(
          fileId: 'f-2',
          fileName: 'شهادة_الجودة_المصرية_ISO_9001.pdf',
          fileUrl: 'https://example.com/docs/iso_cert.pdf',
          fileSize: '1.8 MB',
          fileType: DealFileType.qualityCert,
          uploadedAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
      ],
      timeline: timeline.toDomain(),
    );
  }

  static final sampleDeals = [
    DealMock(
      dealId: 'DEAL-101',
      orderId: 'ORD-2304',
      rfqId: 'RFQ-1025',
      productId: 'P001',
      supplierId: 'SUP-001',
      productName: 'غزل قطن 100% ممتاز تمشيط عالي 30/1',
      dealValue: 430000.0,
      totalQuantity: 10000,
      factoryName: 'شركة النسيج الحديثة للملابس',
      factoryAvatarUrl: 'https://images.unsplash.com/photo-1560179707-f14e90ef3623?auto=format&fit=crop&w=200&q=80',
      isFactoryOnline: true,
      isFactoryVerified: true,
      currentStatus: DealStatus.negotiating,
      lastUpdated: DateTime.now().subtract(const Duration(minutes: 25)),
    ),
    DealMock(
      dealId: 'DEAL-102',
      orderId: 'ORD-2305',
      rfqId: 'RFQ-1026',
      productId: 'P002',
      supplierId: 'SUP-001',
      productName: 'قماش بوليستر ممزوج 65/35 مصبوغ بالكامل',
      dealValue: 385000.0,
      totalQuantity: 10000,
      factoryName: 'مصانع غزل الشرق للتجهيزات',
      factoryAvatarUrl: 'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?auto=format&fit=crop&w=200&q=80',
      isFactoryOnline: false,
      isFactoryVerified: true,
      currentStatus: DealStatus.agreed,
      lastUpdated: DateTime.now().subtract(const Duration(hours: 2)),
    ),
  ];
}


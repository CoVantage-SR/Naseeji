import 'package:flutter/foundation.dart';

enum VerificationStatus { pending, approved, rejected }

@immutable
class VerificationDocument {
  final String id;
  final String documentType; // e.g. 'commercial_register', 'tax_card', 'national_id', 'factory_license', 'address_proof'
  final String fileUrl;
  final String fileName;
  final DateTime uploadedAt;

  const VerificationDocument({
    required this.id,
    required this.documentType,
    required this.fileUrl,
    required this.fileName,
    required this.uploadedAt,
  });
}

@immutable
class VerificationRequest {
  final String id;
  final String supplierId;
  final String companyName;
  final String commercialRegistrationNumber;
  final String taxNumber;
  final String address;
  final String? logoUrl;
  final List<String> companyPhotos;
  final List<VerificationDocument> documents;
  final VerificationStatus status;
  final String? rejectionReason;
  final DateTime createdAt;
  final DateTime? reviewedAt;

  const VerificationRequest({
    required this.id,
    required this.supplierId,
    required this.companyName,
    required this.commercialRegistrationNumber,
    required this.taxNumber,
    required this.address,
    this.logoUrl,
    this.companyPhotos = const [],
    this.documents = const [],
    this.status = VerificationStatus.pending,
    this.rejectionReason,
    required this.createdAt,
    this.reviewedAt,
  });

  bool get isApproved => status == VerificationStatus.approved;
  bool get isPending => status == VerificationStatus.pending;
  bool get isRejected => status == VerificationStatus.rejected;
}

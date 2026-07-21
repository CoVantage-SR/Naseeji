class SupplierHeaderModel {
  final String supplierId;
  final String supplierName;
  final String companyName;
  final String? companyLogoUrl;
  final String subscriptionBadge;
  final int unreadNotificationCount;
  final double rating;
  final bool isVerified;

  const SupplierHeaderModel({
    required this.supplierId,
    required this.supplierName,
    required this.companyName,
    this.companyLogoUrl,
    required this.subscriptionBadge,
    required this.unreadNotificationCount,
    required this.rating,
    required this.isVerified,
  });
}

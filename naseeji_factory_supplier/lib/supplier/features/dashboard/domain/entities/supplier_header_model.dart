class SupplierHeaderModel {
  final String greeting;
  final String supplierName;
  final String companyName;
  final String ratingStars;
  final String subscriptionBadge;
  final bool isVerified;
  final int unreadNotificationCount;
  final String? logoUrl;

  const SupplierHeaderModel({
    required this.greeting,
    required this.supplierName,
    required this.companyName,
    required this.ratingStars,
    required this.subscriptionBadge,
    required this.isVerified,
    required this.unreadNotificationCount,
    this.logoUrl,
  });
}




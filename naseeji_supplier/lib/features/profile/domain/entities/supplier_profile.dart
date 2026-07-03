class SupplierProfile {
  final String companyName;
  final String managerName;
  final String email;
  final String phone;
  final String city;
  final double rating;
  final double completionRate;
  final String logoUrl;
  final String bannerUrl;
  final int productsCount;
  final int ordersCount;

  const SupplierProfile({
    required this.companyName,
    required this.managerName,
    required this.email,
    required this.phone,
    required this.city,
    required this.rating,
    required this.completionRate,
    required this.logoUrl,
    required this.bannerUrl,
    required this.productsCount,
    required this.ordersCount,
  });
}

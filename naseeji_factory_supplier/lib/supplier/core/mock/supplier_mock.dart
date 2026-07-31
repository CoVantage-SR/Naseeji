class SupplierMock {
  final String id;
  final String name;
  final String companyName;
  final String phone;
  final String email;
  final String address;
  final String logoUrl;
  final bool isVerified;
  final double rating;

  const SupplierMock({
    required this.id,
    required this.name,
    required this.companyName,
    required this.phone,
    required this.email,
    required this.address,
    required this.logoUrl,
    this.isVerified = true,
    this.rating = 4.9,
  });

  static const defaultSupplier = SupplierMock(
    id: 'SUP-001',
    name: 'م/ محمد إبراهيم النسيج',
    companyName: 'مصانع نسيج مصر الوطنية',
    phone: '01000000000',
    email: 'supplier@naseeji.com',
    address: 'المنطقة الصناعية الأولى - المحلة الكبرى - مصر',
    logoUrl: 'https://images.unsplash.com/photo-1560179707-f14e90ef3623?auto=format&fit=crop&w=200&q=80',
    isVerified: true,
    rating: 4.9,
  );
}

extension SupplierMockExt on SupplierMock {
  static const String phoneEmailHidden = 'محمية بمحرك أمان نسيجي';
}

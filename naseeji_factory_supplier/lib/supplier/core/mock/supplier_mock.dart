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
    id: 'sup_1',
    name: 'م. محمود عبد السميع النجار',
    companyName: 'شركة مصر للغزل والنسيج (المحلة)',
    phone: '+20 10 1111 2222',
    email: 'misr.spinning@naseeji.com',
    address: 'المنطقة الصناعية - المحلة الكبرى - مصر',
    logoUrl: 'https://images.unsplash.com/photo-1560179707-f14e90ef3623?w=150',
    isVerified: true,
    rating: 4.9,
  );

  static const List<SupplierMock> allSuppliers = [
    SupplierMock(
      id: 'sup_1',
      name: 'م. محمود عبد السميع النجار',
      companyName: 'شركة مصر للغزل والنسيج (المحلة)',
      phone: '+20 10 1111 2222',
      email: 'misr.spinning@naseeji.com',
      address: 'المنطقة الصناعية - المحلة الكبرى - مصر',
      logoUrl: 'https://images.unsplash.com/photo-1560179707-f14e90ef3623?w=150',
      isVerified: true,
      rating: 4.9,
    ),
    SupplierMock(
      id: 'sup_2',
      name: 'م. صلاح خميس عبد العزيز',
      companyName: 'شركة النساجون المصريون للمنسوجات',
      phone: '+20 10 2222 3333',
      email: 'oriental.weavers@naseeji.com',
      address: 'المنطقة الصناعية B3 - العاشر من رمضان - مصر',
      logoUrl: 'https://images.unsplash.com/photo-1544816155-12df9643f363?w=150',
      isVerified: true,
      rating: 4.8,
    ),
    SupplierMock(
      id: 'sup_3',
      name: 'أ. عبد العزيز البنا',
      companyName: 'مؤسسة المحلة الكبرى للغزول والخيوط',
      phone: '+20 10 3333 4444',
      email: 'mahalla.yarns@naseeji.com',
      address: 'شارع المصانع - المحلة الكبرى - مصر',
      logoUrl: 'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?w=150',
      isVerified: true,
      rating: 4.7,
    ),
    SupplierMock(
      id: 'sup_4',
      name: 'م. جلال عبد الحميد',
      companyName: 'شركة القاهرة للنسيج والصباغة والتجهيز',
      phone: '+20 10 4444 5555',
      email: 'cairo.dyeing@naseeji.com',
      address: 'المنطقة الصناعية - شبين القناطر - القليوبية',
      logoUrl: 'https://images.unsplash.com/photo-1572021335469-31706a17aaef?w=150',
      isVerified: true,
      rating: 4.6,
    ),
    SupplierMock(
      id: 'sup_5',
      name: 'د. شريف الرشيدي',
      companyName: 'شركة الأهرام للمواد الكيميائية والصبغات',
      phone: '+20 10 5555 6666',
      email: 'ahram.chemicals@naseeji.com',
      address: 'المنطقة الصناعية الخامسة - مدينة السادات - مصر',
      logoUrl: 'https://images.unsplash.com/photo-1550684848-fac1c5b4e853?w=150',
      isVerified: true,
      rating: 4.9,
    ),
    SupplierMock(
      id: 'sup_6',
      name: 'م. باهر حلمي',
      companyName: 'شركة الإسكندرية للأقمشة والتصدير',
      phone: '+20 10 6666 7777',
      email: 'alex.textiles@naseeji.com',
      address: 'المنطقة الصناعية الأولى - برج العرب - الإسكندرية',
      logoUrl: 'https://images.unsplash.com/photo-1541099649105-f69ad21f3246?w=150',
      isVerified: true,
      rating: 4.7,
    ),
    SupplierMock(
      id: 'sup_7',
      name: 'أ. مدحت عبد الجواد',
      companyName: 'مؤسسة الشرقية للاكسسوارات والسوست',
      phone: '+20 10 7777 8888',
      email: 'sharkia.accessories@naseeji.com',
      address: 'طريق بلبيس - الزقازيق - الشرقية',
      logoUrl: 'https://images.unsplash.com/photo-1590736969955-71cc94901144?w=150',
      isVerified: true,
      rating: 4.8,
    ),
    SupplierMock(
      id: 'sup_8',
      name: 'م. أسامة فاروق',
      companyName: 'الشركة الدولية لماكينات وقطع غيار النسيج',
      phone: '+20 10 8888 9999',
      email: 'international.machinery@naseeji.com',
      address: 'المنطقة الصناعية الثالثة - 6 أكتوبر - مصر',
      logoUrl: 'https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=150',
      isVerified: true,
      rating: 4.9,
    ),
  ];
}

extension SupplierMockExt on SupplierMock {
  static const String phoneEmailHidden = 'محمية بمحرك أمان نسيجي';
}

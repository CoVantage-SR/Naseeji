import '../../domain/entities/factory_profile_entities.dart';

class FactoryProfileMockDatabase {
  FactoryProfileMockDatabase._();
  static final FactoryProfileMockDatabase instance = FactoryProfileMockDatabase._();

  FactoryProfileEntity profile = const FactoryProfileEntity(
    id: 'FAC-2024-01',
    name: 'مصنع النسيج الحديثة',
    commercialName: 'شركة النسيج الحديثة للصناعة والتصدير',
    factoryType: 'مصنع ملابس جاهزة',
    industry: 'الغزل والنسيج والملابس',
    logoUrl: 'https://images.unsplash.com/photo-1541888946425-d0fbb186a5b3?w=300',
    coverUrl: 'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=800',
    isVerified: true,
    verificationStatus: 'verified',
    verificationDate: '2024-01-15',
    reviewer: 'إدارة التوثيق بالمنصة',
    membershipDate: 'عضو منذ يناير 2024',
    status: 'مفعل',
    subscriptionPlan: 'بريميوم',
    subscriptionExpiry: '2025/06/20',
    commercialRegister: '123456',
    taxNumber: '300-123-456',
    vatNumber: '123-456-789',
    establishmentDate: '2015-05-12',
    factorySize: 'كبير (أكثر من 5000 م²)',
    employeesCount: 150,
    annualCapacity: '2,000,000 قطعة/سنوياً',
    description: 'نحن مصنع متخصص في إنتاج الملابس الجاهزة بأعلى معايير الجودة للتصدير للأسواق العالمية.',
  );

  FactoryLocationEntity location = const FactoryLocationEntity(
    country: 'مصر',
    governorate: 'القاهرة',
    city: 'مدينة نصر',
    industrialZone: 'المنطقة الصناعية الأولى',
    address: 'شارع المصانع الرئيسي، القطعة 45',
    googleMapsUrl: 'https://maps.google.com/?q=30.0444,31.2357',
    gpsCoordinates: '30.0444° N, 31.2357° E',
  );

  FactoryContactEntity contact = const FactoryContactEntity(
    companyEmail: 'info@naseeji-textile.com',
    phoneNumber: '+20 2 2345 6789',
    mobile: '+20 10 1234 5678',
    whatsApp: '+20 10 1234 5678',
    website: 'www.naseeji-textile.com',
    linkedIn: 'linkedin.com/company/naseeji-textile',
    facebook: 'facebook.com/naseejitextile',
    emergencyContact: '+20 10 9999 8888',
  );

  FactoryPurchasingInfoEntity purchasing = const FactoryPurchasingInfoEntity(
    purchasingManager: 'أحمد إبراهيم محمد',
    position: 'مدير مشتريات المصنع',
    email: 'a.ibrahim@naseeji-textile.com',
    phone: '+20 10 1111 2222',
    workingHours: '08:00 ص - 05:00 م',
    preferredContactTime: '10:00 ص - 02:00 م',
  );

  FactoryBillingEntity billing = FactoryBillingEntity(
    companyName: 'شركة النسيج الحديثة للصناعة والتصدير',
    taxAddress: 'المنطقة الصناعية الأولى، مدينة نصر، القاهرة',
    invoiceEmail: 'invoices@naseeji-textile.com',
    paymentTerms: 'دفع جزئي 30% مقدم والباقي عند التسليم مع الفحص',
    preferredCurrency: 'EGP (ج.م)',
    bankAccounts: [
      const FactoryBankAccountEntity(
        id: 'ACC-01',
        bankName: 'البنك الأهلي المصري',
        accountName: 'شركة النسيج الحديثة',
        accountNumber: '100020003000',
        iban: 'EG380002000100000012345678901',
        isDefault: true,
      ),
      const FactoryBankAccountEntity(
        id: 'ACC-02',
        bankName: 'بنك مصر',
        accountName: 'شركة النسيج الحديثة',
        accountNumber: '200030004000',
        iban: 'EG450003000200000098765432109',
        isDefault: false,
      ),
    ],
    instapay: 'naseeji@instapay',
    swift: 'NBEGEGCX100',
    iban: 'EG380002000100000012345678901',
  );

  List<FactoryDocumentEntity> documents = [
    const FactoryDocumentEntity(
      id: 'DOC-01',
      title: 'البطاقة الضريبية',
      documentNumber: '123-456-789',
      documentType: 'البطاقة الضريبية',
      status: 'سارية',
      expiryDate: '2026/12/31',
      fileUrl: 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
      version: 2,
    ),
    const FactoryDocumentEntity(
      id: 'DOC-02',
      title: 'السجل التجاري',
      documentNumber: 'رقم 123456',
      documentType: 'السجل التجاري',
      status: 'سارية',
      expiryDate: '2027/05/15',
      fileUrl: 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
      version: 1,
    ),
    const FactoryDocumentEntity(
      id: 'DOC-03',
      title: 'شهادة ضريبة القيمة المضافة',
      documentNumber: 'VAT-998877',
      documentType: 'شهادة القيمة المضافة',
      status: 'سارية',
      expiryDate: '2026/08/20',
      fileUrl: 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
      version: 1,
    ),
    const FactoryDocumentEntity(
      id: 'DOC-04',
      title: 'شهادة ISO 9001',
      documentNumber: '9001:2015',
      documentType: 'شهادة جودة عالمية',
      status: 'سارية',
      expiryDate: '2028/01/10',
      fileUrl: 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
      version: 3,
    ),
  ];

  List<FactoryGalleryItemEntity> gallery = [
    const FactoryGalleryItemEntity(
      id: 'GAL-01',
      title: 'خط الحياكة والتفصيل الرئيسي',
      imageUrl: 'https://images.unsplash.com/photo-1558769132-cb1aea458c5e?w=500',
      type: 'production_line',
    ),
    const FactoryGalleryItemEntity(
      id: 'GAL-02',
      title: 'قسم قص وجاهزية الأقمشة',
      imageUrl: 'https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=500',
      type: 'production_line',
    ),
    const FactoryGalleryItemEntity(
      id: 'GAL-03',
      title: 'مخزن الأغزول والمنتجات التامة',
      imageUrl: 'https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?w=500',
      type: 'warehouse',
    ),
    const FactoryGalleryItemEntity(
      id: 'GAL-04',
      title: 'الواجهة الرئيسية للمصنع',
      imageUrl: 'https://images.unsplash.com/photo-1541888946425-d0fbb186a5b3?w=500',
      type: 'photo',
    ),
  ];
}

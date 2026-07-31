import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/factory_profile_repository_impl.dart';
import '../../domain/entities/factory_profile_entities.dart';
import '../../domain/repositories/factory_profile_repository.dart';
import '../../../account/presentation/providers/account_provider.dart';

final factoryProfileRepositoryProvider = Provider<FactoryProfileRepository>((ref) {
  return FactoryProfileRepositoryImpl();
});

class FactoryProfileState {
  final FactoryProfileEntity profile;
  final FactoryLocationEntity location;
  final FactoryContactEntity contact;
  final FactoryPurchasingInfoEntity purchasing;
  final FactoryBillingEntity billing;
  final List<FactoryDocumentEntity> documents;
  final List<FactoryGalleryItemEntity> gallery;
  final int selectedTabIndex;
  final bool isLoading;

  const FactoryProfileState({
    required this.profile,
    required this.location,
    required this.contact,
    required this.purchasing,
    required this.billing,
    this.documents = const [],
    this.gallery = const [],
    this.selectedTabIndex = 0,
    this.isLoading = false,
  });

  FactoryProfileState copyWith({
    FactoryProfileEntity? profile,
    FactoryLocationEntity? location,
    FactoryContactEntity? contact,
    FactoryPurchasingInfoEntity? purchasing,
    FactoryBillingEntity? billing,
    List<FactoryDocumentEntity>? documents,
    List<FactoryGalleryItemEntity>? gallery,
    int? selectedTabIndex,
    bool? isLoading,
  }) {
    return FactoryProfileState(
      profile: profile ?? this.profile,
      location: location ?? this.location,
      contact: contact ?? this.contact,
      purchasing: purchasing ?? this.purchasing,
      billing: billing ?? this.billing,
      documents: documents ?? this.documents,
      gallery: gallery ?? this.gallery,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class FactoryProfileNotifier extends StateNotifier<FactoryProfileState> {
  final FactoryProfileRepository _repo;
  final Ref _ref;

  FactoryProfileNotifier(this._repo, this._ref)
      : super(FactoryProfileState(
          profile: const FactoryProfileEntity(
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
          ),
          location: const FactoryLocationEntity(
            country: 'مصر',
            governorate: 'القاهرة',
            city: 'مدينة نصر',
            industrialZone: 'المنطقة الصناعية الأولى',
            address: 'شارع المصانع الرئيسي، القطعة 45',
            googleMapsUrl: 'https://maps.google.com/?q=30.0444,31.2357',
            gpsCoordinates: '30.0444° N, 31.2357° E',
          ),
          contact: const FactoryContactEntity(
            companyEmail: 'info@naseeji-textile.com',
            phoneNumber: '+20 2 2345 6789',
            mobile: '+20 10 1234 5678',
            whatsApp: '+20 10 1234 5678',
            website: 'www.naseeji-textile.com',
            linkedIn: 'linkedin.com/company/naseeji-textile',
            facebook: 'facebook.com/naseejitextile',
            emergencyContact: '+20 10 9999 8888',
          ),
          purchasing: const FactoryPurchasingInfoEntity(
            purchasingManager: 'أحمد إبراهيم محمد',
            position: 'مدير مشتريات المصنع',
            email: 'a.ibrahim@naseeji-textile.com',
            phone: '+20 10 1111 2222',
            workingHours: '08:00 ص - 05:00 م',
            preferredContactTime: '10:00 ص - 02:00 م',
          ),
          billing: const FactoryBillingEntity(
            companyName: 'شركة النسيج الحديثة للصناعة والتصدير',
            taxAddress: 'المنطقة الصناعية الأولى، مدينة نصر، القاهرة',
            invoiceEmail: 'invoices@naseeji-textile.com',
            paymentTerms: 'دفع جزئي 30% مقدم والباقي عند التسليم مع الفحص',
            preferredCurrency: 'EGP (ج.م)',
            bankAccounts: [],
            instapay: 'naseeji@instapay',
            swift: 'NBEGEGCX100',
            iban: 'EG380002000100000012345678901',
          ),
        )) {
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final p = await _repo.getProfile();
    final l = await _repo.getLocation();
    final c = await _repo.getContactInfo();
    final pur = await _repo.getPurchasingInfo();
    final b = await _repo.getBillingInfo();
    final docs = await _repo.getDocuments();
    final gal = await _repo.getGallery();

    state = state.copyWith(
      profile: p,
      location: l,
      contact: c,
      purchasing: pur,
      billing: b,
      documents: docs,
      gallery: gal,
    );
  }

  void selectTab(int index) {
    state = state.copyWith(selectedTabIndex: index);
  }

  Future<void> updateProfile(FactoryProfileEntity profile) async {
    await _repo.updateProfile(profile);
    state = state.copyWith(profile: profile);

    // Sync with global providers
    _ref.read(accountNotifierProvider.notifier);
  }

  Future<void> updateLocation(FactoryLocationEntity location) async {
    await _repo.updateLocation(location);
    state = state.copyWith(location: location);
  }

  Future<void> updateContact(FactoryContactEntity contact) async {
    await _repo.updateContactInfo(contact);
    state = state.copyWith(contact: contact);
  }

  Future<void> updatePurchasing(FactoryPurchasingInfoEntity purchasing) async {
    await _repo.updatePurchasingInfo(purchasing);
    state = state.copyWith(purchasing: purchasing);
  }

  Future<void> updateBilling(FactoryBillingEntity billing) async {
    await _repo.updateBillingInfo(billing);
    state = state.copyWith(billing: billing);
  }

  Future<void> addDocument(FactoryDocumentEntity doc) async {
    await _repo.addDocument(doc);
    final updatedDocs = await _repo.getDocuments();
    state = state.copyWith(documents: updatedDocs);
  }

  Future<void> deleteDocument(String id) async {
    await _repo.deleteDocument(id);
    final updatedDocs = await _repo.getDocuments();
    state = state.copyWith(documents: updatedDocs);
  }

  Future<void> addGalleryItem(FactoryGalleryItemEntity item) async {
    await _repo.addGalleryItem(item);
    final updatedGal = await _repo.getGallery();
    state = state.copyWith(gallery: updatedGal);
  }

  Future<void> deleteGalleryItem(String id) async {
    await _repo.deleteGalleryItem(id);
    final updatedGal = await _repo.getGallery();
    state = state.copyWith(gallery: updatedGal);
  }

  Future<void> updateLogo(String logoUrl) async {
    await _repo.updateLogo(logoUrl);
    final updated = await _repo.getProfile();
    state = state.copyWith(profile: updated);
  }

  Future<void> updateCover(String coverUrl) async {
    await _repo.updateCover(coverUrl);
    final updated = await _repo.getProfile();
    state = state.copyWith(profile: updated);
  }
}

final factoryProfileProvider =
    StateNotifierProvider<FactoryProfileNotifier, FactoryProfileState>((ref) {
  final repo = ref.watch(factoryProfileRepositoryProvider);
  return FactoryProfileNotifier(repo, ref);
});

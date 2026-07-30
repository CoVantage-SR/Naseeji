import '../../domain/entities/factory_profile_entities.dart';
import '../../domain/repositories/factory_profile_repository.dart';
import '../datasources/factory_profile_mock_database.dart';
import '../../../account/data/datasources/account_mock_database.dart';

class FactoryProfileRepositoryImpl implements FactoryProfileRepository {
  final FactoryProfileMockDatabase _db = FactoryProfileMockDatabase.instance;

  @override
  Future<FactoryProfileEntity> getProfile() async {
    return _db.profile;
  }

  @override
  Future<void> updateProfile(FactoryProfileEntity profile) async {
    _db.profile = profile;
    // Sync with AccountMockDatabase
    final currentAcc = AccountMockDatabase.instance.factoryProfile;
    AccountMockDatabase.instance.updateFactoryProfile(
      currentAcc.copyWith(
        name: profile.name,
        factoryType: profile.factoryType,
        commercialRegNo: profile.commercialRegister,
        taxCardNo: profile.taxNumber,
        description: profile.description,
        logoUrl: profile.logoUrl,
      ),
    );
  }

  @override
  Future<FactoryLocationEntity> getLocation() async {
    return _db.location;
  }

  @override
  Future<void> updateLocation(FactoryLocationEntity location) async {
    _db.location = location;
  }

  @override
  Future<FactoryContactEntity> getContactInfo() async {
    return _db.contact;
  }

  @override
  Future<void> updateContactInfo(FactoryContactEntity contact) async {
    _db.contact = contact;
  }

  @override
  Future<FactoryPurchasingInfoEntity> getPurchasingInfo() async {
    return _db.purchasing;
  }

  @override
  Future<void> updatePurchasingInfo(FactoryPurchasingInfoEntity purchasing) async {
    _db.purchasing = purchasing;
  }

  @override
  Future<FactoryBillingEntity> getBillingInfo() async {
    return _db.billing;
  }

  @override
  Future<void> updateBillingInfo(FactoryBillingEntity billing) async {
    _db.billing = billing;
  }

  @override
  Future<void> addBankAccount(FactoryBankAccountEntity account) async {
    final updatedList = List<FactoryBankAccountEntity>.from(_db.billing.bankAccounts)..add(account);
    _db.billing = _db.billing.copyWith(bankAccounts: updatedList);
  }

  @override
  Future<void> deleteBankAccount(String id) async {
    final updatedList = _db.billing.bankAccounts.where((a) => a.id != id).toList();
    _db.billing = _db.billing.copyWith(bankAccounts: updatedList);
  }

  @override
  Future<List<FactoryDocumentEntity>> getDocuments() async {
    return _db.documents;
  }

  @override
  Future<void> addDocument(FactoryDocumentEntity document) async {
    _db.documents.add(document);
  }

  @override
  Future<void> updateDocument(FactoryDocumentEntity document) async {
    final idx = _db.documents.indexWhere((d) => d.id == document.id);
    if (idx != -1) {
      _db.documents[idx] = document;
    }
  }

  @override
  Future<void> deleteDocument(String id) async {
    _db.documents.removeWhere((d) => d.id == id);
  }

  @override
  Future<List<FactoryGalleryItemEntity>> getGallery() async {
    return _db.gallery;
  }

  @override
  Future<void> addGalleryItem(FactoryGalleryItemEntity item) async {
    _db.gallery.add(item);
  }

  @override
  Future<void> deleteGalleryItem(String id) async {
    _db.gallery.removeWhere((g) => g.id == id);
  }

  @override
  Future<void> updateLogo(String logoUrl) async {
    _db.profile = _db.profile.copyWith(logoUrl: logoUrl);
  }

  @override
  Future<void> updateCover(String coverUrl) async {
    _db.profile = _db.profile.copyWith(coverUrl: coverUrl);
  }

  @override
  Future<void> requestVerification() async {
    _db.profile = _db.profile.copyWith(verificationStatus: 'pending');
  }
}

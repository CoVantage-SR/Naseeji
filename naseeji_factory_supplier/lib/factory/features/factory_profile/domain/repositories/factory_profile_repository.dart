import '../entities/factory_profile_entities.dart';

abstract class FactoryProfileRepository {
  Future<FactoryProfileEntity> getProfile();
  Future<void> updateProfile(FactoryProfileEntity profile);

  Future<FactoryLocationEntity> getLocation();
  Future<void> updateLocation(FactoryLocationEntity location);

  Future<FactoryContactEntity> getContactInfo();
  Future<void> updateContactInfo(FactoryContactEntity contact);

  Future<FactoryPurchasingInfoEntity> getPurchasingInfo();
  Future<void> updatePurchasingInfo(FactoryPurchasingInfoEntity purchasing);

  Future<FactoryBillingEntity> getBillingInfo();
  Future<void> updateBillingInfo(FactoryBillingEntity billing);
  Future<void> addBankAccount(FactoryBankAccountEntity account);
  Future<void> deleteBankAccount(String id);

  Future<List<FactoryDocumentEntity>> getDocuments();
  Future<void> addDocument(FactoryDocumentEntity document);
  Future<void> updateDocument(FactoryDocumentEntity document);
  Future<void> deleteDocument(String id);

  Future<List<FactoryGalleryItemEntity>> getGallery();
  Future<void> addGalleryItem(FactoryGalleryItemEntity item);
  Future<void> deleteGalleryItem(String id);

  Future<void> updateLogo(String logoUrl);
  Future<void> updateCover(String coverUrl);
  Future<void> requestVerification();
}



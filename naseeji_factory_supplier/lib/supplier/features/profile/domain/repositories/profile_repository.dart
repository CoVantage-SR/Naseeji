import '../entities/supplier_profile.dart';

abstract class ProfileRepository {
  Future<SupplierProfile> getProfile();
  Future<void> updateProfile(SupplierProfile profile);
  Future<void> addCertificate(CompanyCertificate cert);
}



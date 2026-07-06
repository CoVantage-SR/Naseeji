import '../entities/supplier_profile.dart';

abstract class ProfileRepository {
  Future<SupplierProfile> getProfile();
  Future<void> addCertificate(CompanyCertificate cert);
}

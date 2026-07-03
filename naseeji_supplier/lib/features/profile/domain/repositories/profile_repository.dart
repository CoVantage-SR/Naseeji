import '../entities/supplier_profile.dart';

abstract class ProfileRepository {
  Future<SupplierProfile> getProfile();
}

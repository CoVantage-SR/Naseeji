import 'dart:io';
import '../entities/company_entity.dart';

abstract class CompleteProfileRepository {
  Future<CompanyEntity> completeProfile(CompanyEntity company);
  Future<String> uploadLogo(File imageFile);
  Future<CompanyEntity?> getCachedProfile();
}

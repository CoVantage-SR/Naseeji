import 'dart:io';
import '../../domain/entities/company_entity.dart';
import '../../domain/repositories/complete_profile_repository.dart';
import '../datasource/complete_profile_local_datasource.dart';
import '../datasource/complete_profile_remote_datasource.dart';
import '../dto/complete_profile_request_dto.dart';
import '../mapper/company_mapper.dart';

class CompleteProfileRepositoryImpl implements CompleteProfileRepository {
  final CompleteProfileRemoteDatasource remoteDatasource;
  final CompleteProfileLocalDatasource localDatasource;

  CompleteProfileRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
  });

  @override
  Future<CompanyEntity> completeProfile(CompanyEntity company) async {
    final model = CompanyMapper.mapToModel(company);
    final dto = CompleteProfileRequestDto(
      companyName: model.name,
      role: model.role.name,
      category: model.category,
      address: model.address,
      commercialRegister: model.commercialRegister,
      taxNumber: model.taxNumber,
      website: model.website,
      logoUrl: model.logoUrl,
    );

    final response = await remoteDatasource.submitCompanyProfile(dto);
    if (response.success && response.data != null) {
      await localDatasource.cacheCompanyProfile(response.data!);
      return CompanyMapper.mapToEntity(response.data!);
    } else {
      throw Exception(
        response.message.isNotEmpty
            ? response.message
            : 'فشل في حفظ بيانات الشركة',
      );
    }
  }

  @override
  Future<String> uploadLogo(File imageFile) async {
    return remoteDatasource.uploadCompanyLogo(imageFile);
  }

  @override
  Future<CompanyEntity?> getCachedProfile() async {
    final cachedModel = await localDatasource.getCachedCompanyProfile();
    if (cachedModel == null) return null;
    return CompanyMapper.mapToEntity(cachedModel);
  }
}

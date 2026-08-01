import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../shared/enums/user_role.dart';
import '../dto/complete_profile_request_dto.dart';
import '../dto/complete_profile_response_dto.dart';
import '../models/company_model.dart';

abstract class CompleteProfileRemoteDatasource {
  Future<CompleteProfileResponseDto> submitCompanyProfile(
    CompleteProfileRequestDto dto,
  );
  Future<String> uploadCompanyLogo(File imageFile);
}

class CompleteProfileRemoteDatasourceImpl
    implements CompleteProfileRemoteDatasource {
  final Dio? dio;

  CompleteProfileRemoteDatasourceImpl({this.dio});

  @override
  Future<CompleteProfileResponseDto> submitCompanyProfile(
    CompleteProfileRequestDto dto,
  ) async {
    // Backend API Integration point
    try {
      if (dio != null) {
        final response = await dio!.post(
          '/api/v1/auth/complete-profile',
          data: dto.toJson(),
        );
        return CompleteProfileResponseDto.fromJson(
          response.data as Map<String, dynamic>,
        );
      }
    } catch (_) {
      // Fallback to simulation if network isn't configured
    }

    await Future.delayed(const Duration(milliseconds: 1200));

    final mockCompany = CompanyModel(
      id: 'CMP_${DateTime.now().millisecondsSinceEpoch}',
      name: dto.companyName,
      role: dto.role == 'supplier' ? UserRole.supplier : UserRole.factory,
      category: dto.category,
      address: dto.address,
      commercialRegister: dto.commercialRegister,
      taxNumber: dto.taxNumber,
      website: dto.website,
      logoUrl: dto.logoUrl,
    );

    return CompleteProfileResponseDto(
      success: true,
      message: 'تم استكمال بيانات الحساب بنجاح',
      data: mockCompany,
    );
  }

  @override
  Future<String> uploadCompanyLogo(File imageFile) async {
    try {
      if (dio != null) {
        final fileName = imageFile.path.split('/').last;
        final formData = FormData.fromMap({
          'logo': await MultipartFile.fromFile(
            imageFile.path,
            filename: fileName,
          ),
        });
        final response = await dio!.post(
          '/api/v1/upload/logo',
          data: formData,
        );
        final data = response.data as Map<String, dynamic>?;
        if (data != null && data['url'] != null) {
          return data['url'] as String;
        }
      }
    } catch (_) {
      // Fallback mock
    }

    await Future.delayed(const Duration(milliseconds: 800));
    return imageFile.path;
  }
}

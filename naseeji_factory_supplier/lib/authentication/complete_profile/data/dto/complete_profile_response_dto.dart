import '../models/company_model.dart';

class CompleteProfileResponseDto {
  final bool success;
  final String message;
  final CompanyModel? data;

  const CompleteProfileResponseDto({
    required this.success,
    required this.message,
    this.data,
  });

  factory CompleteProfileResponseDto.fromJson(Map<String, dynamic> json) {
    return CompleteProfileResponseDto(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] != null
          ? CompanyModel.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
        'data': data?.toJson(),
      };
}

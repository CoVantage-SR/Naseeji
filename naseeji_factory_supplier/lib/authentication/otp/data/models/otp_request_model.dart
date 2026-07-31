class OtpRequestModel {
  final String phone;
  final String code;

  const OtpRequestModel({
    required this.phone,
    required this.code,
  });

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'code': code,
    };
  }

  factory OtpRequestModel.fromJson(Map<String, dynamic> json) {
    return OtpRequestModel(
      phone: json['phone'] as String? ?? '',
      code: json['code'] as String? ?? '',
    );
  }
}


import 'package:naseeji_factory/shared/enums/user_role.dart';

class AccountTypeRequestModel {
  final UserRole role;

  const AccountTypeRequestModel({
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      'account_type': role.name,
    };
  }

  factory AccountTypeRequestModel.fromJson(Map<String, dynamic> json) {
    return AccountTypeRequestModel(
      role: json['account_type'] == 'supplier' ? UserRole.supplier : UserRole.factory,
    );
  }
}

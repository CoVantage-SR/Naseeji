import 'package:naseeji_factory/shared/enums/user_role.dart';


class AccountTypeEntity {
  final UserRole role;
  final String title;
  final String description;
  final bool isSelected;

  const AccountTypeEntity({
    required this.role,
    required this.title,
    required this.description,
    this.isSelected = false,
  });
}

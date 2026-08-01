import '../../../../shared/enums/user_role.dart';

class CategoryModel {
  final String id;
  final String nameAr;
  final String nameEn;
  final UserRole role;

  const CategoryModel({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.role,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'nameAr': nameAr,
        'nameEn': nameEn,
        'role': role.name,
      };

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String? ?? '',
      nameAr: json['nameAr'] as String? ?? '',
      nameEn: json['nameEn'] as String? ?? '',
      role: json['role'] == 'supplier' ? UserRole.supplier : UserRole.factory,
    );
  }
}

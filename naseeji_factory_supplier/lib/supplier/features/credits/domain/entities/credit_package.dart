import 'package:flutter/foundation.dart';

@immutable
class CreditPackage {
  final String id;
  final String name;
  final int credits;
  final double price;
  final String currency;
  final String? badge; // e.g. "الأكثر طلباً", "أفضل قيمة"
  final int? discountPercent;

  const CreditPackage({
    required this.id,
    required this.name,
    required this.credits,
    required this.price,
    this.currency = 'ج.م',
    this.badge,
    this.discountPercent,
  });

  static const List<CreditPackage> defaultPackages = [
    CreditPackage(
      id: 'pkg_starter',
      name: 'الباقة الأساسية',
      credits: 50,
      price: 250.0,
      badge: 'مبتدئ',
    ),
    CreditPackage(
      id: 'pkg_pro',
      name: 'باقة الأعمال الممتازة',
      credits: 150,
      price: 650.0,
      badge: 'الأكثر طلباً',
      discountPercent: 15,
    ),
    CreditPackage(
      id: 'pkg_enterprise',
      name: 'باقة المؤسسات الكبرى',
      credits: 500,
      price: 1950.0,
      badge: 'أفضل قيمة',
      discountPercent: 25,
    ),
  ];
}

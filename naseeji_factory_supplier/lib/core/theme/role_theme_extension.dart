import 'package:flutter/material.dart';

@immutable
class RoleThemeExtension extends ThemeExtension<RoleThemeExtension> {
  final Color supplierPrimary;
  final Color factoryPrimary;
  final Color supplierContainer;
  final Color factoryContainer;
  final Color supplierOnColor;
  final Color factoryOnColor;

  const RoleThemeExtension({
    required this.supplierPrimary,
    required this.factoryPrimary,
    required this.supplierContainer,
    required this.factoryContainer,
    required this.supplierOnColor,
    required this.factoryOnColor,
  });

  static const light = RoleThemeExtension(
    supplierPrimary: Color(0xFF2563EB),
    factoryPrimary: Color(0xFF10B981),
    supplierContainer: Color(0xFFEFF6FF),
    factoryContainer: Color(0xFFECFDF5),
    supplierOnColor: Colors.white,
    factoryOnColor: Colors.white,
  );

  static const dark = RoleThemeExtension(
    supplierPrimary: Color(0xFF60A5FA),
    factoryPrimary: Color(0xFF34D399),
    supplierContainer: Color(0xFF1E3A8A),
    factoryContainer: Color(0xFF064E3B),
    supplierOnColor: Colors.white,
    factoryOnColor: Colors.white,
  );

  @override
  RoleThemeExtension copyWith({
    Color? supplierPrimary,
    Color? factoryPrimary,
    Color? supplierContainer,
    Color? factoryContainer,
    Color? supplierOnColor,
    Color? factoryOnColor,
  }) {
    return RoleThemeExtension(
      supplierPrimary: supplierPrimary ?? this.supplierPrimary,
      factoryPrimary: factoryPrimary ?? this.factoryPrimary,
      supplierContainer: supplierContainer ?? this.supplierContainer,
      factoryContainer: factoryContainer ?? this.factoryContainer,
      supplierOnColor: supplierOnColor ?? this.supplierOnColor,
      factoryOnColor: factoryOnColor ?? this.factoryOnColor,
    );
  }

  @override
  RoleThemeExtension lerp(ThemeExtension<RoleThemeExtension>? other, double t) {
    if (other is! RoleThemeExtension) return this;
    return RoleThemeExtension(
      supplierPrimary: Color.lerp(supplierPrimary, other.supplierPrimary, t)!,
      factoryPrimary: Color.lerp(factoryPrimary, other.factoryPrimary, t)!,
      supplierContainer: Color.lerp(supplierContainer, other.supplierContainer, t)!,
      factoryContainer: Color.lerp(factoryContainer, other.factoryContainer, t)!,
      supplierOnColor: Color.lerp(supplierOnColor, other.supplierOnColor, t)!,
      factoryOnColor: Color.lerp(factoryOnColor, other.factoryOnColor, t)!,
    );
  }
}

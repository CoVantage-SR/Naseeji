import 'package:flutter/material.dart';

class AppElevation {
  AppElevation._();

  static List<BoxShadow> lightShadowSmall = const [
    BoxShadow(
      color: Color(0x0A000000),
      blurRadius: 6,
      offset: Offset(0, 2),
    ),
  ];

  static List<BoxShadow> lightShadowMedium = const [
    BoxShadow(
      color: Color(0x0D000000),
      blurRadius: 10,
      offset: Offset(0, 4),
    ),
  ];

  static List<BoxShadow> darkShadowSmall = const [
    BoxShadow(
      color: Color(0x20000000),
      blurRadius: 6,
      offset: Offset(0, 2),
    ),
  ];

  static List<BoxShadow> darkShadowMedium = const [
    BoxShadow(
      color: Color(0x40000000),
      blurRadius: 10,
      offset: Offset(0, 4),
    ),
  ];
}

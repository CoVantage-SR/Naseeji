import 'package:flutter/material.dart';

class AppThemeAnimation {
  AppThemeAnimation._();

  static const Duration durationFast = Duration(milliseconds: 150);
  static const Duration durationNormal = Duration(milliseconds: 250);
  static const Duration durationSlow = Duration(milliseconds: 400);

  static const Curve curveFast = Curves.easeOut;
  static const Curve curveNormal = Curves.easeInOut;
  static const Curve curveSlow = Curves.fastOutSlowIn;
}


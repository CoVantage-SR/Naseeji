import 'package:flutter/material.dart';

class AppSpacing {
  AppSpacing._();

  static const double xs = 4.0;
  static const double s = 8.0;
  static const double m = 12.0;
  static const double l = 16.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;

  static const EdgeInsets pagePadding = EdgeInsets.symmetric(horizontal: l, vertical: m);
  static const EdgeInsets cardPadding = EdgeInsets.all(l);
  static const EdgeInsets cardPaddingDense = EdgeInsets.symmetric(horizontal: m, vertical: s);

  static const SizedBox verticalXs = SizedBox(height: xs);
  static const SizedBox verticalS = SizedBox(height: s);
  static const SizedBox verticalM = SizedBox(height: m);
  static const SizedBox verticalL = SizedBox(height: l);
  static const SizedBox verticalXl = SizedBox(height: xl);
  static const SizedBox verticalXxl = SizedBox(height: xxl);

  static const SizedBox horizontalXs = SizedBox(width: xs);
  static const SizedBox horizontalS = SizedBox(width: s);
  static const SizedBox horizontalM = SizedBox(width: m);
  static const SizedBox horizontalL = SizedBox(width: l);
  static const SizedBox horizontalXl = SizedBox(width: xl);
  static const SizedBox horizontalXxl = SizedBox(width: xxl);
}


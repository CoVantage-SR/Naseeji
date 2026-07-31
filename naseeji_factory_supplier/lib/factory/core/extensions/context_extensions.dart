import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  // Theme helpers
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;

  // Media Query helpers
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  Size get screenSize => mediaQuery.size;
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;

  // Responsive breakpoints
  bool get isMobile => screenWidth < 600;
  bool get isTablet => screenWidth >= 600 && screenWidth < 1200;
  bool get isDesktop => screenWidth >= 1200;
  bool get isTabletOrLarger => screenWidth >= 600;

  // Locale helpers
  bool get isRtl => Directionality.of(this) == TextDirection.rtl;

  // Dynamic Spacing or Sizing helper based on device type
  double responsiveValue({
    required double mobile,
    required double tablet,
    double? desktop,
  }) {
    if (isDesktop && desktop != null) return desktop;
    if (isTablet) return tablet;
    return mobile;
  }
}



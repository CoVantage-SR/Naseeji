import 'package:flutter/material.dart';

/// Predefined enterprise device viewports for responsive and golden visual testing.
class ScreenSizes {
  ScreenSizes._();

  static const Size smallPhone = Size(320, 640);
  static const Size mobile360 = Size(360, 800);
  static const Size pixel = Size(412, 915);
  static const Size tablet = Size(768, 1024);
  static const Size landscape = Size(800, 400);
  static const Size desktop = Size(1280, 800);

  static const List<Size> allDevices = [
    smallPhone,
    mobile360,
    pixel,
    tablet,
    landscape,
    desktop,
  ];
}

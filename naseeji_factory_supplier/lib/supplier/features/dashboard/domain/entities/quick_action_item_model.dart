import 'package:flutter/material.dart';

class QuickActionItemModel {
  final String id;
  final String title;
  final IconData icon;
  final String route;
  final Color? iconColor;
  final Color? backgroundColor;
  final int? badgeCount;

  const QuickActionItemModel({
    required this.id,
    required this.title,
    required this.icon,
    required this.route,
    this.iconColor,
    this.backgroundColor,
    this.badgeCount,
  });
}

import 'package:flutter/material.dart';
import 'package:naseeji_factory/core/widgets/reusable_widgets.dart' as core;

class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String? actionLabel;
  final VoidCallback? onActionPressed;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.actionLabel,
    this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    return core.EmptyState(
      icon: icon,
      title: title,
      description: description,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
    );
  }
}



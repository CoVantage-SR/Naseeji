import 'package:flutter/material.dart';
import '../../../../../core/widgets/reusable_widgets.dart';

class SectionHeaderWidget extends StatelessWidget {
  final String title;
  final String actionLabel;
  final VoidCallback? onActionTap;

  const SectionHeaderWidget({
    super.key,
    required this.title,
    this.actionLabel = 'عرض الكل',
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return SectionHeader(
      title: title,
      actionLabel: actionLabel,
      onActionTap: onActionTap,
    );
  }
}


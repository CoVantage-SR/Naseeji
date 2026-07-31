import 'package:flutter/material.dart';
import '../../../../../../../../core/widgets/reusable_widgets.dart';

class StatusChipWidget extends StatelessWidget {
  final String label;
  final Color color;

  const StatusChipWidget({
    super.key,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return StatusChip(
      label: label,
      color: color,
    );
  }
}

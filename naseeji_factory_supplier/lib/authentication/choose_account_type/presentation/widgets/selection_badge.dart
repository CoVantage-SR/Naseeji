import 'package:flutter/material.dart';

class SelectionBadge extends StatelessWidget {
  final bool isSelected;

  const SelectionBadge({
    super.key,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (isSelected) {
      return Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: colorScheme.primary,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.check_rounded,
          size: 16,
          color: Colors.white,
        ),
      );
    }

    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFFCBD5E1),
          width: 1.5,
        ),
      ),
    );
  }
}

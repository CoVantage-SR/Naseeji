import 'package:flutter/material.dart';
import 'package:naseeji_factory/factory/core/constants/app_colors.dart';
import '../account_reusable_widgets.dart';

class AcceptWidget extends StatelessWidget {
  final VoidCallback onAccept;
  const AcceptWidget({super.key, required this.onAccept});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0D1B2A) : const Color(0xFFF0FDF4),
        border: Border(top: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight)),
      ),
      child: PrimaryButton(
        label: 'أوافق على الشروط والأحكام',
        icon: Icons.check_circle_rounded,
        onPressed: onAccept,
      ),
    );
  }
}

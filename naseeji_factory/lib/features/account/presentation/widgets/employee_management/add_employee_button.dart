import 'package:flutter/material.dart';
import 'package:naseeji_factory/core/constants/app_colors.dart';

class AddEmployeeButton extends StatelessWidget {
  final VoidCallback onTap;
  const AddEmployeeButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: onTap,
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      icon: const Icon(Icons.person_add_rounded),
      label: const Text('إضافة موظف', style: TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}

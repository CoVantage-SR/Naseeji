import 'package:flutter/material.dart';
import 'package:naseeji_factory/core/constants/app_colors.dart';
import 'package:naseeji_factory/core/constants/app_radius.dart';
import 'package:naseeji_factory/core/extensions/context_extensions.dart';

class EmployeeSearchWidget extends StatelessWidget {
  final ValueChanged<String> onChanged;
  const EmployeeSearchWidget({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: 'بحث في الموظفين...',
        hintStyle: const TextStyle(fontSize: 13),
        prefixIcon: const Icon(Icons.search_rounded, color: Colors.grey),
        border: OutlineInputBorder(borderRadius: AppRadius.rMD),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.rMD,
          borderSide: BorderSide(
            color: context.theme.brightness == Brightness.dark
                ? AppColors.borderDark
                : AppColors.borderLight,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.rMD,
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        filled: true,
      ),
    );
  }
}




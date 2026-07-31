import 'package:flutter/material.dart';
import 'package:naseeji_factory/core/constants/app_radius.dart';

class TermsSearchWidget extends StatelessWidget {
  final ValueChanged<String> onChanged;
  const TermsSearchWidget({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: 'البحث في الشروط...',
        prefixIcon: const Icon(Icons.search_rounded, color: Colors.grey),
        border: OutlineInputBorder(borderRadius: AppRadius.rMD),
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        filled: true,
      ),
    );
  }
}



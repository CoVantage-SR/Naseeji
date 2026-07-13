import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/utils/validation.dart';
import '../providers/auth_provider.dart';

class GoogleUserCardWidget extends ConsumerWidget {
  const GoogleUserCardWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    
    // Extracted google details
    final (name, email, photoUrl) = authState.maybeWhen(
      googleCompleteRegistrationRequired: (uid, email, name, photoUrl) => (name, email, photoUrl),
      orElse: () => ('', '', ''),
    );

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.rMD,
        side: const BorderSide(color: AppColors.borderLight, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: photoUrl.isNotEmpty ? NetworkImage(photoUrl) : null,
              child: photoUrl.isEmpty ? const Icon(Icons.person_rounded, size: 30) : null,
            ),
            AppSpacing.wMD,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  AppSpacing.hXXS,
                  Text(
                    email,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.check_circle_rounded, color: AppColors.success),
          ],
        ),
      ),
    );
  }
}

class PhoneNumberWidget extends StatelessWidget {
  final TextEditingController controller;

  const PhoneNumberWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: ValidationUtils.validatePhone,
      textAlign: TextAlign.right,
      keyboardType: TextInputType.phone,
      decoration: const InputDecoration(
        labelText: 'رقم الهاتف المحمول للمصنع',
        prefixIcon: Icon(Icons.phone_iphone_rounded),
        hintText: '01012345678',
      ),
    );
  }
}

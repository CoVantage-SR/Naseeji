import 'package:flutter/material.dart';
import '../../../../core/widgets/general_widgets.dart';

class ContinueButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;
  final String text;

  const ContinueButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
    this.text = 'حفظ والاستمرار',
  });

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      suffixIcon: Icons.arrow_forward_rounded,
    );
  }
}

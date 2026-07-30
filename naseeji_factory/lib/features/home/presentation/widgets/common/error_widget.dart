import 'package:flutter/material.dart' hide ErrorWidget;
import '../../../../../../../core/widgets/reusable_widgets.dart' as core;

class ErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ErrorWidget({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return core.ErrorWidget(
      message: message,
      onRetry: onRetry,
    );
  }
}

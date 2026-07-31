import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final String message;

  const LoadingWidget({
    super.key,
    this.message = 'جاري تحميل قائمة المنتجات المعتمدة...',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: theme.colorScheme.primary),
            const SizedBox(height: 12),
            Text(
              message,
              style: TextStyle(fontSize: 11, color: theme.colorScheme.outline, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';

class CompleteProfileProgressIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const CompleteProfileProgressIndicator({
    super.key,
    this.currentStep = 3,
    this.totalSteps = 4,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps * 2 - 1, (index) {
        if (index.isOdd) {
          final lineStep = (index ~/ 2) + 1;
          final isCompleted = lineStep < currentStep;
          return Container(
            width: 32,
            height: 2,
            color: isCompleted
                ? colorScheme.primary
                : colorScheme.outlineVariant,
          );
        } else {
          final step = (index ~/ 2) + 1;
          final isCompleted = step < currentStep;
          final isActive = step == currentStep;

          return Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: isCompleted
                  ? colorScheme.primary
                  : (isActive ? Colors.white : Colors.transparent),
              shape: BoxShape.circle,
              border: Border.all(
                color: isCompleted || isActive
                    ? colorScheme.primary
                    : colorScheme.outlineVariant,
                width: 2,
              ),
            ),
            child: Center(
              child: isCompleted
                  ? const Icon(
                      Icons.check_rounded,
                      size: 16,
                      color: Colors.white,
                    )
                  : Text(
                      '$step',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isActive
                            ? colorScheme.primary
                            : colorScheme.onSurfaceVariant,
                      ),
                    ),
            ),
          );
        }
      }),
    );
  }
}

import 'package:flutter/material.dart';

class RegistrationProgressIndicator extends StatelessWidget {
  final int currentStep;

  const RegistrationProgressIndicator({
    super.key,
    this.currentStep = 3,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStepNode(context: context, step: 1, state: _StepState.completed),
        _buildLine(context: context, isCompleted: true),
        _buildStepNode(context: context, step: 2, state: _StepState.completed),
        _buildLine(context: context, isCompleted: true),
        _buildStepNode(context: context, step: 3, state: _StepState.active),
        _buildLine(context: context, isCompleted: false),
        _buildStepNode(context: context, step: 4, state: _StepState.upcoming),
      ],
    );
  }

  Widget _buildStepNode({
    required BuildContext context,
    required int step,
    required _StepState state,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    if (state == _StepState.completed) {
      return Container(
        width: 26,
        height: 26,
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
    } else if (state == _StepState.active) {
      return Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: colorScheme.primary,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            '$step',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
        ),
      );
    } else {
      return Container(
        width: 26,
        height: 26,
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

  Widget _buildLine({required BuildContext context, required bool isCompleted}) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 36,
      height: 2,
      color: isCompleted
          ? colorScheme.primary
          : (isDark ? colorScheme.outlineVariant : const Color(0xFFE2E8F0)),
    );
  }
}

enum _StepState { completed, active, upcoming }

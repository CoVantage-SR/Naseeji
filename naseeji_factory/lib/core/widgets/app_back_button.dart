import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppBackButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const AppBackButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_forward_rounded), // Right arrow for back action in RTL
      onPressed: onPressed ?? () {
        if (context.canPop()) {
          context.pop();
        }
      },
    );
  }
}

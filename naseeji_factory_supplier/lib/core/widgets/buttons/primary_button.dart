import 'package:flutter/material.dart';

class CorePrimaryButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? suffixIcon;
  final IconData? prefixIcon;
  final Duration throttleDuration;

  const CorePrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.suffixIcon,
    this.prefixIcon,
    this.throttleDuration = const Duration(seconds: 1),
  });

  @override
  State<CorePrimaryButton> createState() => _CorePrimaryButtonState();
}

class _CorePrimaryButtonState extends State<CorePrimaryButton> {
  int _lastClickTime = 0;

  void _throttledPressed() {
    if (widget.onPressed == null) return;
    final now = DateTime.now().millisecondsSinceEpoch;
    if (now - _lastClickTime > widget.throttleDuration.inMilliseconds) {
      _lastClickTime = now;
      widget.onPressed!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: widget.onPressed == null || widget.isLoading
            ? null
            : [
                BoxShadow(
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
      ),
      child: ElevatedButton(
        onPressed: widget.isLoading ? null : _throttledPressed,
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: widget.isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.prefixIcon != null) ...[
                    Icon(widget.prefixIcon, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    widget.text,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (widget.suffixIcon != null) ...[
                    const SizedBox(width: 8),
                    Icon(widget.suffixIcon, size: 20),
                  ],
                ],
              ),
      ),
    );
  }
}

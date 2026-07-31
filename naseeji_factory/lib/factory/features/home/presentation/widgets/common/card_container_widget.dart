import 'package:flutter/material.dart';
import 'package:naseeji_factory/factory/core/widgets/reusable_widgets.dart';

class CardContainerWidget extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final VoidCallback? onTap;

  const CardContainerWidget({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16.0),
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return PrimaryCard(
      padding: padding,
      color: color,
      onTap: onTap,
      child: child,
    );
  }
}

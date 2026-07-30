import 'package:flutter/material.dart';
import '../../../../../../../core/widgets/reusable_widgets.dart' as core;

class LoadingWidget extends StatelessWidget {
  final String message;

  const LoadingWidget({
    super.key,
    this.message = 'جاري التحميل...',
  });

  @override
  Widget build(BuildContext context) {
    return core.LoadingWidget(message: message);
  }
}

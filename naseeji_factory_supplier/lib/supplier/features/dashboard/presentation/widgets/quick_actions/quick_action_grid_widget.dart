import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../quick_actions/quick_actions_bottom_sheet.dart';

class QuickActionGridWidget extends ConsumerWidget {
  const QuickActionGridWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton.icon(
      onPressed: () => QuickActionsBottomSheet.show(context),
      icon: const Icon(Icons.flash_on_rounded),
      label: const Text('عملية سريعة'),
    );
  }
}




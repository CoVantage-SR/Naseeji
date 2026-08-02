import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'core/bootstrap/app_bootstrap.dart';
void main() async {
  final appWidget = await AppBootstrap.run((overrides) {
    return ProviderScope(
      overrides: overrides,
      child: const NaseejiApp(),
    );
  });
  runApp(appWidget);
}

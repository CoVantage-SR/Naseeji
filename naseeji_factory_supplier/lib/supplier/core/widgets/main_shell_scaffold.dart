import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'app_bottom_navigation_bar.dart';

class MainShellScaffold extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainShellScaffold({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: AppBottomNavigationBar(
        navigationShell: navigationShell,
      ),
    );
  }
}




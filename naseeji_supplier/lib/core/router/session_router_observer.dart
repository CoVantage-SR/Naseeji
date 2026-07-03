import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../session/session_tracker.dart';

class SessionRouterObserver extends NavigatorObserver {
  final Ref ref;

  SessionRouterObserver(this.ref);

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _logNavigation('PUSH', route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _logNavigation('POP', route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null) {
      _logNavigation('REPLACE', newRoute, oldRoute);
    }
  }

  void _logNavigation(String type, Route<dynamic> route, Route<dynamic>? otherRoute) {
    // Only log PageRoutes to filter out dialogs/bottom sheets unless required
    if (route is PageRoute) {
      final name = route.settings.name ?? route.settings.arguments?.toString() ?? 'unknown_route';
      final prevName = otherRoute?.settings.name ?? 'none';
      
      ref.read(sessionTrackerProvider.notifier).logAction('NAVIGATION', metadata: {
        'navigationType': type,
        'destinationRoute': name,
        'sourceRoute': prevName,
      });
    }
  }
}

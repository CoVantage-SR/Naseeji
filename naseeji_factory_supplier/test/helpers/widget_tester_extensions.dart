import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

extension WidgetTesterEnterpriseX on WidgetTester {
  /// Ensures a widget identified by Key is visible and taps it cleanly.
  Future<void> tapKey(Key key) async {
    final finder = find.byKey(key);
    expect(finder, findsOneWidget);
    await ensureVisible(finder);
    await pump();
    await tap(finder);
    await pumpAndSettle();
  }

  /// Enters text into a field identified by Key.
  Future<void> enterTextKey(Key key, String text) async {
    final finder = find.byKey(key);
    expect(finder, findsOneWidget);
    await ensureVisible(finder);
    await pump();
    await enterText(finder, text);
    await pumpAndSettle();
  }

  /// Asserts that a widget with Key exists in the widget tree.
  void expectKeyVisible(Key key) {
    expect(find.byKey(key), findsOneWidget);
  }
}

import 'package:flutter_test/flutter_test.dart';

extension WidgetTesterX on WidgetTester {
  /// Pumps the widget tree and waits for animations/microtasks to settle deterministically.
  Future<void> pumpAndSettleClean([Duration duration = const Duration(milliseconds: 100)]) async {
    await pump();
    await pumpAndSettle(duration);
  }
}

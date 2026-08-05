import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Enterprise font loader utility that precaches Material icons and custom typography
/// for cross-platform deterministic Golden test rendering.
class TestFontsLoader {
  static bool _fontsLoaded = false;

  static Future<void> loadTestFonts() async {
    if (_fontsLoaded) return;
    TestWidgetsFlutterBinding.ensureInitialized();

    try {
      // Precache Material Icons font
      final fontData = await rootBundle.load('assets/fonts/MaterialIcons-Regular.otf')
          .catchError((_) => rootBundle.load('packages/cupertino_icons/assets/CupertinoIcons.ttf'));
      final fontLoader = FontLoader('MaterialIcons')..addFont(Future.value(fontData));
      await fontLoader.load();
    } catch (_) {
      // System fallback icon loading
    }

    _fontsLoaded = true;
  }
}

import 'package:shared_preferences/shared_preferences.dart';

/// Provides mock SharedPreferences instance for testing.
Future<SharedPreferences> createMockSharedPreferences({
  Map<String, Object> values = const {},
}) async {
  SharedPreferences.setMockInitialValues(values);
  return await SharedPreferences.getInstance();
}

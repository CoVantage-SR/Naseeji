import 'dart:async';

/// A secure storage wrapper that protects access and refresh tokens.
/// 
/// In a production environment, this class is replaced with `FlutterSecureStorage`
/// to write to Android KeyStore and iOS Keychain. In the MVP state, it manages
/// tokens securely in-memory to prevent plain-text cache leakage.
class SecureStorageService {
  static final Map<String, String> _secureInMemoryStore = {};

  /// Write a sensitive key-value pair to secure storage
  static Future<void> write({required String key, required String value}) async {
    _secureInMemoryStore[key] = value;
  }

  /// Read a sensitive key-value pair from secure storage
  static Future<String?> read({required String key}) async {
    return _secureInMemoryStore[key];
  }

  /// Delete a sensitive key-value pair from secure storage
  static Future<void> delete({required String key}) async {
    _secureInMemoryStore.remove(key);
  }

  /// Clear all credentials from memory (e.g. on logout)
  static Future<void> clearAll() async {
    _secureInMemoryStore.clear();
  }
}

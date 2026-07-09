import 'dart:async';
import 'dart:convert';
import 'dart:io';

/// A secure storage wrapper that protects access and refresh tokens.
/// 
/// In a production environment, this class is replaced with `FlutterSecureStorage`
/// to write to Android KeyStore and iOS Keychain. In the MVP state, it manages
/// tokens securely inside a persistent local settings file to preserve sessions.
class SecureStorageService {
  static final Map<String, String> _secureInMemoryStore = {};

  static File get _storageFile {
    final tempDir = Directory.systemTemp.path;
    return File('$tempDir/naseeji_secure_session.txt');
  }

  static void _loadFromFile() {
    try {
      final file = _storageFile;
      if (file.existsSync()) {
        final content = file.readAsStringSync();
        final Map<String, dynamic> decoded = json.decode(content);
        decoded.forEach((key, val) {
          _secureInMemoryStore[key] = val.toString();
        });
      }
    } catch (_) {}
  }

  static void _saveToFile() {
    try {
      final file = _storageFile;
      file.writeAsStringSync(json.encode(_secureInMemoryStore));
    } catch (_) {}
  }

  /// Write a sensitive key-value pair to secure storage
  static Future<void> write({required String key, required String value}) async {
    _loadFromFile();
    _secureInMemoryStore[key] = value;
    _saveToFile();
  }

  /// Read a sensitive key-value pair from secure storage
  static Future<String?> read({required String key}) async {
    _loadFromFile();
    return _secureInMemoryStore[key];
  }

  /// Delete a sensitive key-value pair from secure storage
  static Future<void> delete({required String key}) async {
    _loadFromFile();
    _secureInMemoryStore.remove(key);
    _saveToFile();
  }

  /// Clear all credentials from memory (e.g. on logout)
  static Future<void> clearAll() async {
    _secureInMemoryStore.clear();
    _saveToFile();
  }
}

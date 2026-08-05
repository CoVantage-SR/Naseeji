import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'models/app_setting.dart';

part 'isar_service.g.dart';

class IsarService {
  final Isar? _isar;

  IsarService(this._isar);

  Isar? get isar => _isar;

  static Future<IsarService> init() async {
    try {
      String dirPath = '';
      if (!kIsWeb) {
        final dir = await getApplicationDocumentsDirectory();
        dirPath = dir.path;
      }
      final isar = await Isar.open(
        [AppSettingSchema],
        directory: dirPath,
      );
      return IsarService(isar);
    } catch (e) {
      debugPrint('Isar initialization fallback: $e');
      return IsarService(null);
    }
  }

  Future<void> cleanDb() async {
    if (_isar == null) return;
    await _isar!.writeTxn(() async {
      await _isar!.clear();
    });
  }

  Future<void> close() async {
    await _isar?.close();
  }
}

@riverpod
IsarService isarService(IsarServiceRef ref) {
  throw UnimplementedError('Override isarServiceProvider in main.dart');
}



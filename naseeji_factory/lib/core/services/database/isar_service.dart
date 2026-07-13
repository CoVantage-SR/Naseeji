import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'models/app_setting.dart';

part 'isar_service.g.dart';

class IsarService {
  final Isar _isar;

  IsarService(this._isar);

  Isar get isar => _isar;

  static Future<IsarService> init() async {
    final dir = await getApplicationDocumentsDirectory();
    final isar = await Isar.open(
      [AppSettingSchema],
      directory: dir.path,
    );
    return IsarService(isar);
  }

  Future<void> cleanDb() async {
    await _isar.writeTxn(() async {
      await _isar.clear();
    });
  }

  Future<void> close() async {
    await _isar.close();
  }
}

@riverpod
IsarService isarService(IsarServiceRef ref) {
  // This will be overridden in main.dart with an initialized instance.
  throw UnimplementedError('Override isarServiceProvider in main.dart');
}

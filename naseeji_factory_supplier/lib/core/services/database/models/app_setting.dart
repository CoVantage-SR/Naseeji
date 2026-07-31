import 'package:isar/isar.dart';

part 'app_setting.g.dart';

@collection
class AppSetting {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String key;

  String? value;
}


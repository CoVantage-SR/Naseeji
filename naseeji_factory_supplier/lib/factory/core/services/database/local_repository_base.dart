import 'package:isar/isar.dart';

abstract class LocalRepositoryBase<T> {
  final Isar isar;

  LocalRepositoryBase(this.isar);

  IsarCollection<T> get collection;

  Future<T?> getById(Id id) async {
    return await collection.get(id);
  }

  Future<List<T>> getAll() async {
    return await collection.where().findAll();
  }

  Future<void> put(T entity) async {
    await isar.writeTxn(() async {
      await collection.put(entity);
    });
  }

  Future<void> putAll(List<T> entities) async {
    await isar.writeTxn(() async {
      await collection.putAll(entities);
    });
  }

  Future<bool> delete(Id id) async {
    return await isar.writeTxn(() async {
      return await collection.delete(id);
    });
  }

  Future<int> deleteAll(List<Id> ids) async {
    return await isar.writeTxn(() async {
      return await collection.deleteAll(ids);
    });
  }

  Future<void> clear() async {
    await isar.writeTxn(() async {
      await collection.clear();
    });
  }
}

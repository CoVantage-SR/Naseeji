import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/customer_model.dart';
import '../../data/repositories/customers_repository_impl.dart';

part 'customers_controller.g.dart';

@riverpod
class CustomersController extends _$CustomersController {
  @override
  FutureOr<List<CustomerModel>> build() async {
    final repo = ref.watch(customersRepositoryProvider);
    return repo.getCustomers();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return ref.read(customersRepositoryProvider).getCustomers();
    });
  }

  Future<void> addNote(String customerId, CustomerNote note) async {
    state = await AsyncValue.guard(() async {
      await ref.read(customersRepositoryProvider).addNote(customerId, note);
      return ref.read(customersRepositoryProvider).getCustomers();
    });
  }

  Future<void> updateNote(String customerId, CustomerNote note) async {
    state = await AsyncValue.guard(() async {
      await ref.read(customersRepositoryProvider).updateNote(customerId, note);
      return ref.read(customersRepositoryProvider).getCustomers();
    });
  }

  Future<void> deleteNote(String customerId, String noteId) async {
    state = await AsyncValue.guard(() async {
      await ref.read(customersRepositoryProvider).deleteNote(customerId, noteId);
      return ref.read(customersRepositoryProvider).getCustomers();
    });
  }

  Future<void> pinNote(String customerId, String noteId, bool pinned) async {
    state = await AsyncValue.guard(() async {
      await ref.read(customersRepositoryProvider).pinNote(customerId, noteId, pinned);
      return ref.read(customersRepositoryProvider).getCustomers();
    });
  }

  Future<void> addTag(String customerId, CustomerTag tag) async {
    state = await AsyncValue.guard(() async {
      await ref.read(customersRepositoryProvider).addTag(customerId, tag);
      return ref.read(customersRepositoryProvider).getCustomers();
    });
  }

  Future<void> removeTag(String customerId, String tagId) async {
    state = await AsyncValue.guard(() async {
      await ref.read(customersRepositoryProvider).removeTag(customerId, tagId);
      return ref.read(customersRepositoryProvider).getCustomers();
    });
  }

  Future<void> updateRating(String customerId, CustomerRating rating) async {
    state = await AsyncValue.guard(() async {
      await ref.read(customersRepositoryProvider).updateRating(customerId, rating);
      return ref.read(customersRepositoryProvider).getCustomers();
    });
  }

  Future<void> blockCustomer(String customerId, String reason) async {
    state = await AsyncValue.guard(() async {
      await ref.read(customersRepositoryProvider).blockCustomer(customerId, reason);
      return ref.read(customersRepositoryProvider).getCustomers();
    });
  }

  Future<void> unblockCustomer(String customerId) async {
    state = await AsyncValue.guard(() async {
      await ref.read(customersRepositoryProvider).unblockCustomer(customerId);
      return ref.read(customersRepositoryProvider).getCustomers();
    });
  }

  Future<void> archiveCustomer(String customerId) async {
    state = await AsyncValue.guard(() async {
      await ref.read(customersRepositoryProvider).archiveCustomer(customerId);
      return ref.read(customersRepositoryProvider).getCustomers();
    });
  }
}

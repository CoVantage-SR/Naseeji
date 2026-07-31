import '../entities/customer_model.dart';

abstract class CustomersRepository {
  Future<List<CustomerModel>> getCustomers();
  Future<CustomerModel?> getCustomer(String id);
  Future<void> saveCustomer(CustomerModel customer);

  // Notes CRUD
  Future<void> addNote(String customerId, CustomerNote note);
  Future<void> updateNote(String customerId, CustomerNote note);
  Future<void> deleteNote(String customerId, String noteId);
  Future<void> pinNote(String customerId, String noteId, bool pinned);

  // Tags
  Future<void> addTag(String customerId, CustomerTag tag);
  Future<void> removeTag(String customerId, String tagId);

  // Private Rating
  Future<void> updateRating(String customerId, CustomerRating rating);

  // Status Management
  Future<void> blockCustomer(String customerId, String reason);
  Future<void> unblockCustomer(String customerId);
  Future<void> archiveCustomer(String customerId);
}




import '../models/customer_contact.dart';

abstract class ContactsRepository {
  Future<List<CustomerContact>> getAll();

  Future<void> upsert(CustomerContact contact);
}

import 'package:injectable/injectable.dart';

import '../models/customer_contact.dart';
import 'contacts_repository.dart';

@injectable
class GetContactsUseCase {
  final ContactsRepository repository;

  const GetContactsUseCase(this.repository);

  Future<List<CustomerContact>> call() {
    return repository.getAll();
  }
}

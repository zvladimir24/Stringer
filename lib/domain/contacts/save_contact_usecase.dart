import 'package:injectable/injectable.dart';

import '../models/customer_contact.dart';
import 'contacts_repository.dart';

@injectable
class SaveContactUseCase {
  final ContactsRepository repository;

  const SaveContactUseCase(this.repository);

  Future<void> call(CustomerContact contact) {
    return repository.upsert(contact);
  }
}

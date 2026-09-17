import 'package:injectable/injectable.dart';
import 'package:stringer/domain/contacts/contacts_repository.dart';
import 'package:stringer/domain/models/customer_contact.dart';

import '../datasources/contacts_local_data_source.dart';
import '../dto/customer_contact_dto.dart';

@LazySingleton(as: ContactsRepository)
class ContactsRepositoryImpl implements ContactsRepository {
  final ContactsLocalDataSource dataSource;

  const ContactsRepositoryImpl(this.dataSource);

  @override
  Future<List<CustomerContact>> getAll() async {
    final dtos = await dataSource.readAll();
    return dtos.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<void> upsert(CustomerContact contact) async {
    final existing = await dataSource.readAll();
    final withoutExisting = existing.where((c) => c.pib != contact.pib).toList();

    await dataSource.writeAll([...withoutExisting, contact.toDto()]);
  }
}

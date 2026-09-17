import 'dart:convert';
import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';

import '../dto/customer_contact_dto.dart';

@injectable
class ContactsLocalDataSource {
  static const _fileName = 'contacts.json';

  Future<List<CustomerContactDto>> readAll() async {
    final file = await _contactsFile();
    if (!await file.exists()) {
      return const [];
    }

    final content = await file.readAsString();
    if (content.trim().isEmpty) {
      return const [];
    }

    final decoded = jsonDecode(content) as List<dynamic>;
    return decoded
        .map((entry) => CustomerContactDto.fromJson(entry as Map<String, dynamic>))
        .toList();
  }

  Future<void> writeAll(List<CustomerContactDto> contacts) async {
    final file = await _contactsFile();
    final encoded = jsonEncode(contacts.map((c) => c.toJson()).toList());
    await file.writeAsString(encoded);
  }

  Future<File> _contactsFile() async {
    final directory = await getApplicationSupportDirectory();
    return File('${directory.path}/$_fileName');
  }
}

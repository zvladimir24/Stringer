import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:stringer/domain/models/smtp_settings.dart';
import 'package:stringer/domain/settings/settings_repository.dart';

import '../dto/smtp_settings_dto.dart';

@LazySingleton(as: SettingsRepository)
class SettingsRepositoryImpl implements SettingsRepository {
  static const _smtpSettingsKey = 'smtp_settings';

  final FlutterSecureStorage secureStorage;

  const SettingsRepositoryImpl(this.secureStorage);

  @override
  Future<SmtpSettings?> getSmtpSettings() async {
    final raw = await secureStorage.read(key: _smtpSettingsKey);
    if (raw == null) return null;

    final json = jsonDecode(raw) as Map<String, dynamic>;
    return SmtpSettingsDto.fromJson(json).toDomain();
  }

  @override
  Future<void> saveSmtpSettings(SmtpSettings settings) async {
    final encoded = jsonEncode(settings.toDto().toJson());
    await secureStorage.write(key: _smtpSettingsKey, value: encoded);
  }
}

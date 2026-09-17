import '../models/smtp_settings.dart';

abstract class SettingsRepository {
  Future<SmtpSettings?> getSmtpSettings();

  Future<void> saveSmtpSettings(SmtpSettings settings);
}

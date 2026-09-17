import 'package:injectable/injectable.dart';

import '../models/smtp_settings.dart';
import 'settings_repository.dart';

@injectable
class GetSmtpSettingsUseCase {
  final SettingsRepository repository;

  const GetSmtpSettingsUseCase(this.repository);

  Future<SmtpSettings?> call() {
    return repository.getSmtpSettings();
  }
}

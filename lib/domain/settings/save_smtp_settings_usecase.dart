import 'package:injectable/injectable.dart';

import '../models/smtp_settings.dart';
import 'settings_repository.dart';

@injectable
class SaveSmtpSettingsUseCase {
  final SettingsRepository repository;

  const SaveSmtpSettingsUseCase(this.repository);

  Future<void> call(SmtpSettings settings) {
    return repository.saveSmtpSettings(settings);
  }
}

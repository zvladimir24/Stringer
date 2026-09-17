import 'package:injectable/injectable.dart';

import '../../core/error/app_exception.dart';
import '../../core/error/failure.dart';
import '../models/customer_contact.dart';
import '../models/debtor.dart';
import '../settings/get_smtp_settings_usecase.dart';
import 'email_repository.dart';

@injectable
class SendPaymentReminderUseCase {
  final EmailRepository emailRepository;
  final GetSmtpSettingsUseCase getSmtpSettingsUseCase;

  const SendPaymentReminderUseCase(
    this.emailRepository,
    this.getSmtpSettingsUseCase,
  );

  Future<void> call({
    required Debtor debtor,
    required CustomerContact contact,
  }) async {
    final settings = await getSmtpSettingsUseCase();
    if (settings == null) {
      throw const AppException(Failure(FailureType.smtpNotConfigured));
    }

    await emailRepository.sendPaymentReminder(
      settings: settings,
      contact: contact,
      debtor: debtor,
    );
  }
}

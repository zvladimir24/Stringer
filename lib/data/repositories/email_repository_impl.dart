import 'package:injectable/injectable.dart';
import 'package:stringer/domain/email/email_repository.dart';
import 'package:stringer/domain/models/customer_contact.dart';
import 'package:stringer/domain/models/debtor.dart';
import 'package:stringer/domain/models/smtp_settings.dart';

import '../datasources/mailer_email_data_source.dart';

@LazySingleton(as: EmailRepository)
class EmailRepositoryImpl implements EmailRepository {
  final MailerEmailDataSource dataSource;

  const EmailRepositoryImpl(this.dataSource);

  @override
  Future<void> sendPaymentReminder({
    required SmtpSettings settings,
    required CustomerContact contact,
    required Debtor debtor,
  }) {
    return dataSource.sendPaymentReminder(
      settings: settings,
      contact: contact,
      debtor: debtor,
    );
  }
}

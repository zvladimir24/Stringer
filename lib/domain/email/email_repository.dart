import '../models/customer_contact.dart';
import '../models/debtor.dart';
import '../models/smtp_settings.dart';

abstract class EmailRepository {
  Future<void> sendPaymentReminder({
    required SmtpSettings settings,
    required CustomerContact contact,
    required Debtor debtor,
  });
}

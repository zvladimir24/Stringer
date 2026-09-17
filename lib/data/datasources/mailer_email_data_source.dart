import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:stringer/core/error/app_exception.dart';
import 'package:stringer/core/error/failure.dart';
import 'package:stringer/domain/models/customer_contact.dart';
import 'package:stringer/domain/models/debtor.dart';
import 'package:stringer/domain/models/smtp_settings.dart';

import '../templates/payment_reminder_email_template.dart';

@injectable
class MailerEmailDataSource {
  Future<void> sendPaymentReminder({
    required SmtpSettings settings,
    required CustomerContact contact,
    required Debtor debtor,
  }) async {
    final content = PaymentReminderEmailTemplate.build(
      debtor: debtor,
      footerText: settings.footerText,
    );

    final server = SmtpServer(
      settings.host,
      port: settings.port,
      username: settings.username,
      password: settings.password,
      ssl: settings.useSsl,
    );

    final message = Message()
      ..from = Address(settings.senderEmail, settings.senderName)
      ..recipients.add(contact.email)
      ..subject = content.subject
      ..html = content.htmlBody;

    try {
      await send(message, server);
    } catch (e) {
      debugPrint('Failed to send payment reminder to ${contact.email}: $e');
      throw AppException(Failure(FailureType.sendFailed, details: e.toString()));
    }
  }
}

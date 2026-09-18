import 'package:intl/intl.dart';
import 'package:stringer/domain/models/debtor.dart';

class PaymentReminderEmailContent {
  final String subject;
  final String htmlBody;

  const PaymentReminderEmailContent({
    required this.subject,
    required this.htmlBody,
  });
}

/// Builds the fixed Serbian reminder message used today (see the sample
/// email this replaces), injecting the customer's total overdue amount and
/// an aging breakdown table, plus the configurable settings footer.
class PaymentReminderEmailTemplate {
  PaymentReminderEmailTemplate._();

  static PaymentReminderEmailContent build({
    required Debtor debtor,
    required String footerText,
    required String emailSubject,
    String komercijalista = '',
  }) {
    final amountFormat = NumberFormat.decimalPatternDigits(
      locale: 'sr_RS',
      decimalDigits: 2,
    );
    final totalOverdueText =
        '${amountFormat.format(debtor.totalOverdue)} ${debtor.currency}';

    final subject = '$emailSubject - ${debtor.companyName}';

    final htmlBody =
        '''
<div style="font-family: Arial, sans-serif; font-size: 14px; color: #1B1F24;">
  <p>Poštovani,</p>
  <p>Vaš dug u iznosu od <strong>$totalOverdueText</strong> prema našoj kompaniji je dospeo i još uvek nije izmiren.</p>
  <p>Ljubazno molimo da izmirite dugovanje.</p>
  <p>U prilogu se nalazi pregled obaveza po danima dospeća.</p>
  ${_buildKomercijalistaBlock(komercijalista)}
  ${_buildBreakdownTable(debtor, amountFormat)}
  <p>Ukoliko ste izmirili dospelo dugovanje molim vas zanemarite ovaj mail ili ako ima bilo kakvih neslaganja i nejasnoća možete nas kontaktirati na dole navedene brojeve telefona.</p>
  ${_buildFooter(footerText)}
</div>
''';

    return PaymentReminderEmailContent(subject: subject, htmlBody: htmlBody);
  }

  static String _buildKomercijalistaBlock(String komercijalista) {
    if (komercijalista.trim().isEmpty) return '';

    return '''
      <table style="border-collapse:collapse;margin:16px 0;">
        <tbody>
          <tr>
            <td style="padding:6px 12px;border:1px solid #DDE2E8;background:#F5F7FA;font-weight:bold;">Komercijalista</td>
          </tr>
          <tr>
            <td style="padding:6px 12px;border:1px solid #DDE2E8;">${komercijalista.trim()}</td>
          </tr>
        </tbody>
      </table>
    ''';
  }

  static String _buildBreakdownTable(Debtor debtor, NumberFormat format) {
    String row(String label, double value) {
      return '''
        <tr>
          <td style="padding:6px 12px;border:1px solid #DDE2E8;">$label</td>
          <td style="padding:6px 12px;border:1px solid #DDE2E8;text-align:right;">${format.format(value)}</td>
        </tr>
      ''';
    }

    return '''
      <table style="border-collapse:collapse;margin:16px 0;">
        <thead>
          <tr style="background:#F5F7FA;">
            <th style="padding:6px 12px;border:1px solid #DDE2E8;text-align:left;">Stavka</th>
            <th style="padding:6px 12px;border:1px solid #DDE2E8;text-align:right;">Iznos</th>
          </tr>
        </thead>
        <tbody>
          ${row('Ukupan dug', debtor.totalDebt)}
          ${row('Dug u roku', debtor.currentDebt)}
          ${row('Ukupno dospelo', debtor.totalOverdue)}
          ${row('Dug do 7 dana', debtor.overdueUpTo7Days)}
          ${row('Dug do 15 dana', debtor.overdueUpTo15Days)}
          ${row('Dug do 30 dana', debtor.overdueUpTo30Days)}
          ${row('Dug do 60 dana', debtor.overdueUpTo60Days)}
          ${row('Dug preko 60 dana', debtor.overdueOver60Days)}
        </tbody>
      </table>
    ''';
  }

  static String _buildFooter(String footerText) {
    if (footerText.trim().isEmpty) return '';
    final escaped = footerText.replaceAll('\n', '<br>');
    return '<p style="margin-top:24px;color:#5B6472;">$escaped</p>';
  }
}

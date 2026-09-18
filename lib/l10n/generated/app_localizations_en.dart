// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Debt Collector';

  @override
  String get homeScreenTitle => 'Late Payments';

  @override
  String get settingsIconTooltip => 'Settings';

  @override
  String get selectExcelFileButton => 'Select Excel file';

  @override
  String get changeExcelFileButton => 'Change file';

  @override
  String get clearFileButton => 'Remove file';

  @override
  String get retryButton => 'Try again';

  @override
  String selectedFileLabel(String fileName) {
    return 'Selected file: $fileName';
  }

  @override
  String get noFileSelectedTitle => 'No file selected';

  @override
  String get noFileSelectedMessage =>
      'Select an Excel (.xlsx) file to load debt data.';

  @override
  String get loadingMessage => 'Loading data...';

  @override
  String get emptyStateTitle => 'No data';

  @override
  String get emptyStateMessage =>
      'The selected file does not contain any debt records.';

  @override
  String get errorInvalidFileFormatTitle => 'Invalid file format';

  @override
  String get errorInvalidFileFormatMessage =>
      'The selected file is not a valid Excel (.xlsx) file. Please select a file with the .xlsx extension.';

  @override
  String get errorReadingFileTitle => 'Error reading file';

  @override
  String get errorReadingFileMessage =>
      'An error occurred while reading the file. Check that the file is not corrupted and try again.';

  @override
  String get errorMissingColumnsTitle => 'Missing columns';

  @override
  String get errorMissingColumnsMessage =>
      'The file is missing expected columns (code, company name, tax ID, total debt, current debt and the overdue-aging columns).';

  @override
  String get tableColumnCode => 'Code';

  @override
  String get tableColumnCompany => 'Company';

  @override
  String get tableColumnPib => 'Tax ID';

  @override
  String get tableColumnTotalDebt => 'Total debt';

  @override
  String get tableColumnCurrentDebt => 'Not yet due';

  @override
  String get tableColumnTotalOverdue => 'Total overdue';

  @override
  String get tableColumnOverdue7 => 'Up to 7 days';

  @override
  String get tableColumnOverdue15 => 'Up to 15 days';

  @override
  String get tableColumnOverdue30 => 'Up to 30 days';

  @override
  String get tableColumnOverdue60 => 'Up to 60 days';

  @override
  String get tableColumnOverdueOver60 => 'Over 60 days';

  @override
  String get tableColumnEmail => 'Email';

  @override
  String get tableColumnKomercijalista => 'Sales rep';

  @override
  String get tableColumnLastEmailSent => 'Last email sent';

  @override
  String get tableColumnNaslov => 'Email subject';

  @override
  String get lastEmailSentNeverLabel => 'Never';

  @override
  String get tableColumnStatus => 'Status';

  @override
  String get addEmailButton => 'Add email';

  @override
  String get editEmailTooltip => 'Edit email';

  @override
  String get addKomercijalistaButton => 'Add sales rep';

  @override
  String get editKomercijalistaTooltip => 'Edit sales rep';

  @override
  String get komercijalistaDialogTitle => 'Sales rep';

  @override
  String get addNaslovButton => 'Add subject';

  @override
  String get editNaslovTooltip => 'Edit subject';

  @override
  String get naslovDialogTitle => 'Email subject';

  @override
  String get naslovDialogLabel => 'Email subject';

  @override
  String get naslovDialogHint => 'e.g. Overdue payment reminder';

  @override
  String totalRecordsLabel(int count) {
    return 'Total records: $count';
  }

  @override
  String selectedRecipientsLabel(int count) {
    return 'Selected: $count';
  }

  @override
  String get sendRemindersButton => 'Send reminders';

  @override
  String get sendingInProgressMessage => 'Sending...';

  @override
  String get sendResultSuccessTooltip => 'Sent successfully';

  @override
  String get sendResultSmtpNotConfiguredTooltip =>
      'SMTP is not configured. Open Settings.';

  @override
  String get sendResultFailedTooltip => 'Sending failed';

  @override
  String get sendResultMissingNaslovTooltip => 'You must add an email subject.';

  @override
  String get contactDialogTitle => 'Contact details';

  @override
  String get contactDialogEmailLabel => 'Email address';

  @override
  String get contactDialogEmailHint => 'e.g. office@company.com';

  @override
  String get contactDialogKomercijalistaLabel => 'Sales rep';

  @override
  String get contactDialogKomercijalistaHint => 'e.g. John Smith';

  @override
  String get contactDialogInvalidEmail => 'Enter a valid email address.';

  @override
  String get contactDialogSaveButton => 'Save';

  @override
  String get contactDialogCancelButton => 'Cancel';

  @override
  String get settingsScreenTitle => 'Settings';

  @override
  String get settingsSmtpSectionTitle => 'SMTP server';

  @override
  String get settingsHostLabel => 'SMTP host';

  @override
  String get settingsPortLabel => 'Port';

  @override
  String get settingsUsernameLabel => 'Username';

  @override
  String get settingsPasswordLabel => 'Password';

  @override
  String get settingsSenderNameLabel => 'Sender name';

  @override
  String get settingsSenderEmailLabel => 'Sender email';

  @override
  String get settingsUseSslLabel => 'Use SSL';

  @override
  String get settingsFooterLabel => 'Signature / contact phone numbers';

  @override
  String get settingsFooterHint => 'e.g. Company name, Phone: 011/xxx-xxx';

  @override
  String get settingsSaveButton => 'Save settings';

  @override
  String get settingsSavedMessage => 'Settings saved.';

  @override
  String get settingsValidationRequired => 'This field is required.';

  @override
  String get settingsValidationInvalidPort => 'Enter a valid port number.';
}

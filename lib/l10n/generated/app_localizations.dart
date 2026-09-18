import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_sr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('sr'),
  ];

  /// The title of the application.
  ///
  /// In sr, this message translates to:
  /// **'Uterivač duga'**
  String get appTitle;

  /// Title of the home screen.
  ///
  /// In sr, this message translates to:
  /// **'Zakasnele uplate'**
  String get homeScreenTitle;

  /// Tooltip for the settings icon button in the home app bar.
  ///
  /// In sr, this message translates to:
  /// **'Podešavanja'**
  String get settingsIconTooltip;

  /// Button label for picking an xlsx file.
  ///
  /// In sr, this message translates to:
  /// **'Izaberi Excel fajl'**
  String get selectExcelFileButton;

  /// Button label for picking a different xlsx file.
  ///
  /// In sr, this message translates to:
  /// **'Promeni fajl'**
  String get changeExcelFileButton;

  /// Button label for clearing the currently loaded file.
  ///
  /// In sr, this message translates to:
  /// **'Ukloni fajl'**
  String get clearFileButton;

  /// Button label for retrying a failed action.
  ///
  /// In sr, this message translates to:
  /// **'Pokušaj ponovo'**
  String get retryButton;

  /// Shows the name of the currently selected file.
  ///
  /// In sr, this message translates to:
  /// **'Izabrani fajl: {fileName}'**
  String selectedFileLabel(String fileName);

  /// Title shown when no xlsx file has been imported yet.
  ///
  /// In sr, this message translates to:
  /// **'Nijedan fajl nije izabran'**
  String get noFileSelectedTitle;

  /// Message shown when no xlsx file has been imported yet.
  ///
  /// In sr, this message translates to:
  /// **'Izaberite Excel (.xlsx) fajl da biste učitali podatke o zakasnelim uplatama.'**
  String get noFileSelectedMessage;

  /// Message shown while the xlsx file is being parsed.
  ///
  /// In sr, this message translates to:
  /// **'Učitavanje podataka...'**
  String get loadingMessage;

  /// Title shown when the imported file contains no records.
  ///
  /// In sr, this message translates to:
  /// **'Nema podataka'**
  String get emptyStateTitle;

  /// Message shown when the imported file contains no records.
  ///
  /// In sr, this message translates to:
  /// **'Izabrani fajl ne sadrži nijedan zapis o dugovanjima.'**
  String get emptyStateMessage;

  /// Title shown when the selected file is not a valid xlsx file.
  ///
  /// In sr, this message translates to:
  /// **'Neispravan format fajla'**
  String get errorInvalidFileFormatTitle;

  /// Message shown when the selected file is not a valid xlsx file.
  ///
  /// In sr, this message translates to:
  /// **'Izabrani fajl nije validan Excel (.xlsx) fajl. Izaberite fajl sa ekstenzijom .xlsx.'**
  String get errorInvalidFileFormatMessage;

  /// Title shown when the xlsx file could not be read or parsed.
  ///
  /// In sr, this message translates to:
  /// **'Greška prilikom čitanja fajla'**
  String get errorReadingFileTitle;

  /// Message shown when the xlsx file could not be read or parsed.
  ///
  /// In sr, this message translates to:
  /// **'Došlo je do greške prilikom čitanja fajla. Proverite da li je fajl oštećen i pokušajte ponovo.'**
  String get errorReadingFileMessage;

  /// Title shown when the xlsx file is missing expected columns.
  ///
  /// In sr, this message translates to:
  /// **'Nedostaju kolone'**
  String get errorMissingColumnsTitle;

  /// Message shown when the xlsx file is missing expected columns.
  ///
  /// In sr, this message translates to:
  /// **'Fajl ne sadrži očekivane kolone (Šifra, Naziv poslovnog partnera, PIB, Ukupan dug, Dug u roku i kolone dospeća).'**
  String get errorMissingColumnsMessage;

  /// Table column header for the internal customer code.
  ///
  /// In sr, this message translates to:
  /// **'Šifra'**
  String get tableColumnCode;

  /// Table column header for company name.
  ///
  /// In sr, this message translates to:
  /// **'Kompanija'**
  String get tableColumnCompany;

  /// Table column header for the tax identification number.
  ///
  /// In sr, this message translates to:
  /// **'PIB'**
  String get tableColumnPib;

  /// Table column header for the total debt amount.
  ///
  /// In sr, this message translates to:
  /// **'Ukupan dug'**
  String get tableColumnTotalDebt;

  /// Table column header for the not-yet-due debt amount.
  ///
  /// In sr, this message translates to:
  /// **'Dug u roku'**
  String get tableColumnCurrentDebt;

  /// Table column header for the total overdue amount.
  ///
  /// In sr, this message translates to:
  /// **'Ukupno dospelo'**
  String get tableColumnTotalOverdue;

  /// Table column header for the 0-7 days overdue bucket.
  ///
  /// In sr, this message translates to:
  /// **'Do 7 dana'**
  String get tableColumnOverdue7;

  /// Table column header for the 8-15 days overdue bucket.
  ///
  /// In sr, this message translates to:
  /// **'Do 15 dana'**
  String get tableColumnOverdue15;

  /// Table column header for the 16-30 days overdue bucket.
  ///
  /// In sr, this message translates to:
  /// **'Do 30 dana'**
  String get tableColumnOverdue30;

  /// Table column header for the 31-60 days overdue bucket.
  ///
  /// In sr, this message translates to:
  /// **'Do 60 dana'**
  String get tableColumnOverdue60;

  /// Table column header for the over-60-days overdue bucket.
  ///
  /// In sr, this message translates to:
  /// **'Preko 60 dana'**
  String get tableColumnOverdueOver60;

  /// Table column header for email address.
  ///
  /// In sr, this message translates to:
  /// **'Email'**
  String get tableColumnEmail;

  /// Table column header for the salesperson/account rep assigned to the company.
  ///
  /// In sr, this message translates to:
  /// **'Komercijalista'**
  String get tableColumnKomercijalista;

  /// Table column header for the timestamp of the last reminder email sent to the company.
  ///
  /// In sr, this message translates to:
  /// **'Poslednji mejl'**
  String get tableColumnLastEmailSent;

  /// Table column header for the per-company reminder email subject.
  ///
  /// In sr, this message translates to:
  /// **'Naslov emaila'**
  String get tableColumnNaslov;

  /// Shown in the last-email-sent column when no reminder has ever been sent to the company.
  ///
  /// In sr, this message translates to:
  /// **'Nikad'**
  String get lastEmailSentNeverLabel;

  /// Table column header for the last send result.
  ///
  /// In sr, this message translates to:
  /// **'Status'**
  String get tableColumnStatus;

  /// Button shown on a row with no saved contact email.
  ///
  /// In sr, this message translates to:
  /// **'Dodaj email'**
  String get addEmailButton;

  /// Tooltip for the edit-contact icon on a row with a saved email.
  ///
  /// In sr, this message translates to:
  /// **'Izmeni email'**
  String get editEmailTooltip;

  /// Button shown on a row with no saved komercijalista (sales rep) name.
  ///
  /// In sr, this message translates to:
  /// **'Dodaj komercijalistu'**
  String get addKomercijalistaButton;

  /// Tooltip for the edit icon on a row with a saved komercijalista (sales rep) name.
  ///
  /// In sr, this message translates to:
  /// **'Izmeni komercijalistu'**
  String get editKomercijalistaTooltip;

  /// Title of the dialog for adding/editing a customer's assigned sales rep.
  ///
  /// In sr, this message translates to:
  /// **'Komercijalista'**
  String get komercijalistaDialogTitle;

  /// Button shown on a row with no saved email subject (naslov).
  ///
  /// In sr, this message translates to:
  /// **'Dodaj naslov'**
  String get addNaslovButton;

  /// Tooltip for the edit icon on a row with a saved email subject (naslov).
  ///
  /// In sr, this message translates to:
  /// **'Izmeni naslov'**
  String get editNaslovTooltip;

  /// Title of the dialog for adding/editing a customer's reminder email subject.
  ///
  /// In sr, this message translates to:
  /// **'Naslov emaila'**
  String get naslovDialogTitle;

  /// Label for the text field in the naslov (email subject) dialog.
  ///
  /// In sr, this message translates to:
  /// **'Naslov emaila'**
  String get naslovDialogLabel;

  /// Hint text for the text field in the naslov (email subject) dialog.
  ///
  /// In sr, this message translates to:
  /// **'npr. Opomena za neizmireno dugovanje'**
  String get naslovDialogHint;

  /// Shows the total number of imported records.
  ///
  /// In sr, this message translates to:
  /// **'Ukupno zapisa: {count}'**
  String totalRecordsLabel(int count);

  /// Shows how many recipients are currently selected to be emailed.
  ///
  /// In sr, this message translates to:
  /// **'Izabrano: {count}'**
  String selectedRecipientsLabel(int count);

  /// Button that sends the reminder email to every selected recipient.
  ///
  /// In sr, this message translates to:
  /// **'Pošalji podsetnike'**
  String get sendRemindersButton;

  /// Shown while reminder emails are being sent.
  ///
  /// In sr, this message translates to:
  /// **'Slanje u toku...'**
  String get sendingInProgressMessage;

  /// Tooltip on the success icon after sending a reminder.
  ///
  /// In sr, this message translates to:
  /// **'Uspešno poslato'**
  String get sendResultSuccessTooltip;

  /// Tooltip when sending failed because SMTP settings are missing.
  ///
  /// In sr, this message translates to:
  /// **'SMTP nije podešen. Otvorite Podešavanja.'**
  String get sendResultSmtpNotConfiguredTooltip;

  /// Tooltip when sending a reminder failed for any other reason.
  ///
  /// In sr, this message translates to:
  /// **'Slanje nije uspelo'**
  String get sendResultFailedTooltip;

  /// Tooltip when sending failed because the company has no email subject (naslov) set.
  ///
  /// In sr, this message translates to:
  /// **'Morate dodati naslov mejla.'**
  String get sendResultMissingNaslovTooltip;

  /// Title of the dialog for adding/editing a customer contact.
  ///
  /// In sr, this message translates to:
  /// **'Kontakt podaci'**
  String get contactDialogTitle;

  /// Label for the email field in the contact dialog.
  ///
  /// In sr, this message translates to:
  /// **'Email adresa'**
  String get contactDialogEmailLabel;

  /// Hint text for the email field in the contact dialog.
  ///
  /// In sr, this message translates to:
  /// **'npr. office@kompanija.rs'**
  String get contactDialogEmailHint;

  /// Label for the salesperson/account rep field in the contact dialog.
  ///
  /// In sr, this message translates to:
  /// **'Komercijalista'**
  String get contactDialogKomercijalistaLabel;

  /// Hint text for the salesperson/account rep field in the contact dialog.
  ///
  /// In sr, this message translates to:
  /// **'npr. Marko Marković'**
  String get contactDialogKomercijalistaHint;

  /// Validation error for an invalid email address.
  ///
  /// In sr, this message translates to:
  /// **'Unesite ispravnu email adresu.'**
  String get contactDialogInvalidEmail;

  /// Save button in the contact dialog.
  ///
  /// In sr, this message translates to:
  /// **'Sačuvaj'**
  String get contactDialogSaveButton;

  /// Cancel button in the contact dialog.
  ///
  /// In sr, this message translates to:
  /// **'Otkaži'**
  String get contactDialogCancelButton;

  /// Title of the SMTP settings screen.
  ///
  /// In sr, this message translates to:
  /// **'Podešavanja'**
  String get settingsScreenTitle;

  /// Section title for the SMTP connection fields.
  ///
  /// In sr, this message translates to:
  /// **'SMTP server'**
  String get settingsSmtpSectionTitle;

  /// Label for the SMTP host field.
  ///
  /// In sr, this message translates to:
  /// **'SMTP server (host)'**
  String get settingsHostLabel;

  /// Label for the SMTP port field.
  ///
  /// In sr, this message translates to:
  /// **'Port'**
  String get settingsPortLabel;

  /// Label for the SMTP username field.
  ///
  /// In sr, this message translates to:
  /// **'Korisničko ime'**
  String get settingsUsernameLabel;

  /// Label for the SMTP password field.
  ///
  /// In sr, this message translates to:
  /// **'Lozinka'**
  String get settingsPasswordLabel;

  /// Label for the sender display name field.
  ///
  /// In sr, this message translates to:
  /// **'Ime pošiljaoca'**
  String get settingsSenderNameLabel;

  /// Label for the sender email address field.
  ///
  /// In sr, this message translates to:
  /// **'Email pošiljaoca'**
  String get settingsSenderEmailLabel;

  /// Label for the use-SSL toggle.
  ///
  /// In sr, this message translates to:
  /// **'Koristi SSL'**
  String get settingsUseSslLabel;

  /// Label for the footer/signature text field appended to every email.
  ///
  /// In sr, this message translates to:
  /// **'Potpis / kontakt telefoni'**
  String get settingsFooterLabel;

  /// Hint text for the footer/signature field.
  ///
  /// In sr, this message translates to:
  /// **'npr. Naziv kompanije, Telefon: 011/xxx-xxx'**
  String get settingsFooterHint;

  /// Save button on the settings screen.
  ///
  /// In sr, this message translates to:
  /// **'Sačuvaj podešavanja'**
  String get settingsSaveButton;

  /// Confirmation shown after settings are saved.
  ///
  /// In sr, this message translates to:
  /// **'Podešavanja su sačuvana.'**
  String get settingsSavedMessage;

  /// Validation error for a required settings field.
  ///
  /// In sr, this message translates to:
  /// **'Ovo polje je obavezno.'**
  String get settingsValidationRequired;

  /// Validation error for an invalid port number.
  ///
  /// In sr, this message translates to:
  /// **'Unesite ispravan broj porta.'**
  String get settingsValidationInvalidPort;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'sr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'sr':
      return AppLocalizationsSr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

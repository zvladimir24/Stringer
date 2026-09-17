// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Serbian (`sr`).
class AppLocalizationsSr extends AppLocalizations {
  AppLocalizationsSr([String locale = 'sr']) : super(locale);

  @override
  String get appTitle => 'Uterivač duga';

  @override
  String get homeScreenTitle => 'Zakasnele uplate';

  @override
  String get settingsIconTooltip => 'Podešavanja';

  @override
  String get selectExcelFileButton => 'Izaberi Excel fajl';

  @override
  String get changeExcelFileButton => 'Promeni fajl';

  @override
  String get clearFileButton => 'Ukloni fajl';

  @override
  String get retryButton => 'Pokušaj ponovo';

  @override
  String selectedFileLabel(String fileName) {
    return 'Izabrani fajl: $fileName';
  }

  @override
  String get noFileSelectedTitle => 'Nijedan fajl nije izabran';

  @override
  String get noFileSelectedMessage =>
      'Izaberite Excel (.xlsx) fajl da biste učitali podatke o zakasnelim uplatama.';

  @override
  String get loadingMessage => 'Učitavanje podataka...';

  @override
  String get emptyStateTitle => 'Nema podataka';

  @override
  String get emptyStateMessage =>
      'Izabrani fajl ne sadrži nijedan zapis o dugovanjima.';

  @override
  String get errorInvalidFileFormatTitle => 'Neispravan format fajla';

  @override
  String get errorInvalidFileFormatMessage =>
      'Izabrani fajl nije validan Excel (.xlsx) fajl. Izaberite fajl sa ekstenzijom .xlsx.';

  @override
  String get errorReadingFileTitle => 'Greška prilikom čitanja fajla';

  @override
  String get errorReadingFileMessage =>
      'Došlo je do greške prilikom čitanja fajla. Proverite da li je fajl oštećen i pokušajte ponovo.';

  @override
  String get errorMissingColumnsTitle => 'Nedostaju kolone';

  @override
  String get errorMissingColumnsMessage =>
      'Fajl ne sadrži očekivane kolone (Šifra, Naziv poslovnog partnera, PIB, Ukupan dug, Dug u roku i kolone dospeća).';

  @override
  String get tableColumnCode => 'Šifra';

  @override
  String get tableColumnCompany => 'Kompanija';

  @override
  String get tableColumnPib => 'PIB';

  @override
  String get tableColumnTotalDebt => 'Ukupan dug';

  @override
  String get tableColumnCurrentDebt => 'Dug u roku';

  @override
  String get tableColumnTotalOverdue => 'Ukupno dospelo';

  @override
  String get tableColumnOverdue7 => 'Do 7 dana';

  @override
  String get tableColumnOverdue15 => 'Do 15 dana';

  @override
  String get tableColumnOverdue30 => 'Do 30 dana';

  @override
  String get tableColumnOverdue60 => 'Do 60 dana';

  @override
  String get tableColumnOverdueOver60 => 'Preko 60 dana';

  @override
  String get tableColumnEmail => 'Email';

  @override
  String get tableColumnKomercijalista => 'Komercijalista';

  @override
  String get tableColumnLastEmailSent => 'Poslednji mejl';

  @override
  String get lastEmailSentNeverLabel => 'Nikad';

  @override
  String get tableColumnStatus => 'Status';

  @override
  String get addEmailButton => 'Dodaj email';

  @override
  String get editEmailTooltip => 'Izmeni email';

  @override
  String totalRecordsLabel(int count) {
    return 'Ukupno zapisa: $count';
  }

  @override
  String selectedRecipientsLabel(int count) {
    return 'Izabrano: $count';
  }

  @override
  String get sendRemindersButton => 'Pošalji podsetnike';

  @override
  String get sendingInProgressMessage => 'Slanje u toku...';

  @override
  String get sendResultSuccessTooltip => 'Uspešno poslato';

  @override
  String get sendResultSmtpNotConfiguredTooltip =>
      'SMTP nije podešen. Otvorite Podešavanja.';

  @override
  String get sendResultFailedTooltip => 'Slanje nije uspelo';

  @override
  String get contactDialogTitle => 'Kontakt podaci';

  @override
  String get contactDialogEmailLabel => 'Email adresa';

  @override
  String get contactDialogEmailHint => 'npr. office@kompanija.rs';

  @override
  String get contactDialogKomercijalistaLabel => 'Komercijalista';

  @override
  String get contactDialogKomercijalistaHint => 'npr. Marko Marković';

  @override
  String get contactDialogInvalidEmail => 'Unesite ispravnu email adresu.';

  @override
  String get contactDialogSaveButton => 'Sačuvaj';

  @override
  String get contactDialogCancelButton => 'Otkaži';

  @override
  String get settingsScreenTitle => 'Podešavanja';

  @override
  String get settingsSmtpSectionTitle => 'SMTP server';

  @override
  String get settingsHostLabel => 'SMTP server (host)';

  @override
  String get settingsPortLabel => 'Port';

  @override
  String get settingsUsernameLabel => 'Korisničko ime';

  @override
  String get settingsPasswordLabel => 'Lozinka';

  @override
  String get settingsSenderNameLabel => 'Ime pošiljaoca';

  @override
  String get settingsSenderEmailLabel => 'Email pošiljaoca';

  @override
  String get settingsUseSslLabel => 'Koristi SSL';

  @override
  String get settingsFooterLabel => 'Potpis / kontakt telefoni';

  @override
  String get settingsFooterHint => 'npr. Naziv kompanije, Telefon: 011/xxx-xxx';

  @override
  String get settingsSaveButton => 'Sačuvaj podešavanja';

  @override
  String get settingsSavedMessage => 'Podešavanja su sačuvana.';

  @override
  String get settingsValidationRequired => 'Ovo polje je obavezno.';

  @override
  String get settingsValidationInvalidPort => 'Unesite ispravan broj porta.';
}

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:stringer/app/di/register_module.dart' as _i369;
import 'package:stringer/data/datasources/contacts_local_data_source.dart'
    as _i864;
import 'package:stringer/data/datasources/debtors_excel_data_source.dart'
    as _i858;
import 'package:stringer/data/datasources/mailer_email_data_source.dart'
    as _i800;
import 'package:stringer/data/repositories/contacts_repository_impl.dart'
    as _i878;
import 'package:stringer/data/repositories/email_repository_impl.dart' as _i200;
import 'package:stringer/data/repositories/home_screen_repository_impl.dart'
    as _i152;
import 'package:stringer/data/repositories/settings_repository_impl.dart'
    as _i801;
import 'package:stringer/domain/contacts/contacts_repository.dart' as _i879;
import 'package:stringer/domain/contacts/get_contacts_usecase.dart' as _i759;
import 'package:stringer/domain/contacts/save_contact_usecase.dart' as _i848;
import 'package:stringer/domain/email/email_repository.dart' as _i424;
import 'package:stringer/domain/email/send_payment_reminder_usecase.dart'
    as _i903;
import 'package:stringer/domain/home_screen/home_screen_repository.dart'
    as _i911;
import 'package:stringer/domain/home_screen/import_debtors_usecase.dart'
    as _i971;
import 'package:stringer/domain/settings/get_smtp_settings_usecase.dart'
    as _i872;
import 'package:stringer/domain/settings/save_smtp_settings_usecase.dart'
    as _i148;
import 'package:stringer/domain/settings/settings_repository.dart' as _i321;
import 'package:stringer/presentation/screens/home_screen/bloc/home_screen_bloc.dart'
    as _i292;
import 'package:stringer/presentation/screens/settings_screen/bloc/settings_bloc.dart'
    as _i778;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.factory<_i864.ContactsLocalDataSource>(
      () => _i864.ContactsLocalDataSource(),
    );
    gh.factory<_i858.DebtorsExcelDataSource>(
      () => _i858.DebtorsExcelDataSource(),
    );
    gh.factory<_i800.MailerEmailDataSource>(
      () => _i800.MailerEmailDataSource(),
    );
    gh.lazySingleton<_i558.FlutterSecureStorage>(
      () => registerModule.secureStorage,
    );
    gh.lazySingleton<_i424.EmailRepository>(
      () => _i200.EmailRepositoryImpl(gh<_i800.MailerEmailDataSource>()),
    );
    gh.lazySingleton<_i911.HomeScreenRepository>(
      () => _i152.HomeScreenRepositoryImpl(gh<_i858.DebtorsExcelDataSource>()),
    );
    gh.lazySingleton<_i879.ContactsRepository>(
      () => _i878.ContactsRepositoryImpl(gh<_i864.ContactsLocalDataSource>()),
    );
    gh.lazySingleton<_i321.SettingsRepository>(
      () => _i801.SettingsRepositoryImpl(gh<_i558.FlutterSecureStorage>()),
    );
    gh.factory<_i971.ImportDebtorsUseCase>(
      () => _i971.ImportDebtorsUseCase(gh<_i911.HomeScreenRepository>()),
    );
    gh.factory<_i759.GetContactsUseCase>(
      () => _i759.GetContactsUseCase(gh<_i879.ContactsRepository>()),
    );
    gh.factory<_i848.SaveContactUseCase>(
      () => _i848.SaveContactUseCase(gh<_i879.ContactsRepository>()),
    );
    gh.factory<_i872.GetSmtpSettingsUseCase>(
      () => _i872.GetSmtpSettingsUseCase(gh<_i321.SettingsRepository>()),
    );
    gh.factory<_i148.SaveSmtpSettingsUseCase>(
      () => _i148.SaveSmtpSettingsUseCase(gh<_i321.SettingsRepository>()),
    );
    gh.factory<_i778.SettingsBloc>(
      () => _i778.SettingsBloc(
        gh<_i872.GetSmtpSettingsUseCase>(),
        gh<_i148.SaveSmtpSettingsUseCase>(),
      ),
    );
    gh.factory<_i903.SendPaymentReminderUseCase>(
      () => _i903.SendPaymentReminderUseCase(
        gh<_i424.EmailRepository>(),
        gh<_i872.GetSmtpSettingsUseCase>(),
      ),
    );
    gh.factory<_i292.HomeScreenBloc>(
      () => _i292.HomeScreenBloc(
        gh<_i971.ImportDebtorsUseCase>(),
        gh<_i759.GetContactsUseCase>(),
        gh<_i848.SaveContactUseCase>(),
        gh<_i903.SendPaymentReminderUseCase>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i369.RegisterModule {}

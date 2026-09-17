import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:stringer/domain/settings/get_smtp_settings_usecase.dart';
import 'package:stringer/domain/settings/save_smtp_settings_usecase.dart';

import 'settings_event.dart';
import 'settings_state.dart';

@injectable
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final GetSmtpSettingsUseCase _getSmtpSettingsUseCase;
  final SaveSmtpSettingsUseCase _saveSmtpSettingsUseCase;

  SettingsBloc(this._getSmtpSettingsUseCase, this._saveSmtpSettingsUseCase)
    : super(const SettingsLoading()) {
    on<SettingsStarted>(_onStarted);
    on<SettingsSaveRequested>(_onSaveRequested);
  }

  Future<void> _onStarted(
    SettingsStarted event,
    Emitter<SettingsState> emit,
  ) async {
    final settings = await _getSmtpSettingsUseCase();
    emit(SettingsReady(settings: settings));
  }

  Future<void> _onSaveRequested(
    SettingsSaveRequested event,
    Emitter<SettingsState> emit,
  ) async {
    final currentState = state;
    if (currentState is! SettingsReady) return;

    emit(currentState.copyWith(isSaving: true, justSaved: false));
    await _saveSmtpSettingsUseCase(event.settings);
    emit(
      SettingsReady(settings: event.settings, isSaving: false, justSaved: true),
    );
  }
}

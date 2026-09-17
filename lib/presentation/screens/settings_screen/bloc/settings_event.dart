import 'package:equatable/equatable.dart';
import 'package:stringer/domain/models/smtp_settings.dart';

sealed class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

class SettingsStarted extends SettingsEvent {
  const SettingsStarted();
}

class SettingsSaveRequested extends SettingsEvent {
  final SmtpSettings settings;

  const SettingsSaveRequested(this.settings);

  @override
  List<Object?> get props => [settings];
}

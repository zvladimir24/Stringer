import 'package:equatable/equatable.dart';
import 'package:stringer/domain/models/smtp_settings.dart';

sealed class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object?> get props => [];
}

class SettingsLoading extends SettingsState {
  const SettingsLoading();
}

class SettingsReady extends SettingsState {
  final SmtpSettings? settings;
  final bool isSaving;
  final bool justSaved;

  const SettingsReady({
    required this.settings,
    this.isSaving = false,
    this.justSaved = false,
  });

  SettingsReady copyWith({
    SmtpSettings? settings,
    bool? isSaving,
    bool? justSaved,
  }) {
    return SettingsReady(
      settings: settings ?? this.settings,
      isSaving: isSaving ?? this.isSaving,
      justSaved: justSaved ?? this.justSaved,
    );
  }

  @override
  List<Object?> get props => [settings, isSaving, justSaved];
}

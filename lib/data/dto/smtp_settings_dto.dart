import 'package:stringer/domain/models/smtp_settings.dart';

class SmtpSettingsDto {
  final String host;
  final int port;
  final String username;
  final String password;
  final String senderName;
  final String senderEmail;
  final bool useSsl;
  final String footerText;
  final String direktorEmail;
  final String menadzerEmail;

  const SmtpSettingsDto({
    required this.host,
    required this.port,
    required this.username,
    required this.password,
    required this.senderName,
    required this.senderEmail,
    required this.useSsl,
    required this.footerText,
    required this.direktorEmail,
    required this.menadzerEmail,
  });

  factory SmtpSettingsDto.fromJson(Map<String, dynamic> json) {
    return SmtpSettingsDto(
      host: json['host'] as String,
      port: json['port'] as int,
      username: json['username'] as String,
      password: json['password'] as String,
      senderName: json['senderName'] as String,
      senderEmail: json['senderEmail'] as String,
      useSsl: json['useSsl'] as bool,
      footerText: json['footerText'] as String,
      direktorEmail:
          json['direktorEmail'] as String? ??
          SmtpSettings.defaultDirektorEmail,
      menadzerEmail:
          json['menadzerEmail'] as String? ??
          SmtpSettings.defaultMenadzerEmail,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'host': host,
      'port': port,
      'username': username,
      'password': password,
      'senderName': senderName,
      'senderEmail': senderEmail,
      'useSsl': useSsl,
      'footerText': footerText,
      'direktorEmail': direktorEmail,
      'menadzerEmail': menadzerEmail,
    };
  }
}

extension SmtpSettingsDtoMapper on SmtpSettingsDto {
  SmtpSettings toDomain() {
    return SmtpSettings(
      host: host,
      port: port,
      username: username,
      password: password,
      senderName: senderName,
      senderEmail: senderEmail,
      useSsl: useSsl,
      footerText: footerText,
      direktorEmail: direktorEmail,
      menadzerEmail: menadzerEmail,
    );
  }
}

extension SmtpSettingsDomainMapper on SmtpSettings {
  SmtpSettingsDto toDto() {
    return SmtpSettingsDto(
      host: host,
      port: port,
      username: username,
      password: password,
      senderName: senderName,
      senderEmail: senderEmail,
      useSsl: useSsl,
      footerText: footerText,
      direktorEmail: direktorEmail,
      menadzerEmail: menadzerEmail,
    );
  }
}

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

  const SmtpSettingsDto({
    required this.host,
    required this.port,
    required this.username,
    required this.password,
    required this.senderName,
    required this.senderEmail,
    required this.useSsl,
    required this.footerText,
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
    );
  }
}

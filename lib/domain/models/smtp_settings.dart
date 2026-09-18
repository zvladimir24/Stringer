class SmtpSettings {
  static const defaultEmailSubject = 'Opomena za neizmireno dugovanje';

  final String host;
  final int port;
  final String username;
  final String password;
  final String senderName;
  final String senderEmail;
  final bool useSsl;
  final String footerText;
  final String emailSubject;

  const SmtpSettings({
    required this.host,
    required this.port,
    required this.username,
    required this.password,
    required this.senderName,
    required this.senderEmail,
    required this.useSsl,
    required this.footerText,
    this.emailSubject = defaultEmailSubject,
  });

  SmtpSettings copyWith({
    String? host,
    int? port,
    String? username,
    String? password,
    String? senderName,
    String? senderEmail,
    bool? useSsl,
    String? footerText,
    String? emailSubject,
  }) {
    return SmtpSettings(
      host: host ?? this.host,
      port: port ?? this.port,
      username: username ?? this.username,
      password: password ?? this.password,
      senderName: senderName ?? this.senderName,
      senderEmail: senderEmail ?? this.senderEmail,
      useSsl: useSsl ?? this.useSsl,
      footerText: footerText ?? this.footerText,
      emailSubject: emailSubject ?? this.emailSubject,
    );
  }
}

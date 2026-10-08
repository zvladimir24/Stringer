class SmtpSettings {
  static const defaultDirektorEmail = 'tamara.erakovic@metalopromet.co.rs';
  static const defaultMenadzerEmail = 'zoran.dimic@metalopromet.co.rs';

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

  const SmtpSettings({
    required this.host,
    required this.port,
    required this.username,
    required this.password,
    required this.senderName,
    required this.senderEmail,
    required this.useSsl,
    required this.footerText,
    this.direktorEmail = defaultDirektorEmail,
    this.menadzerEmail = defaultMenadzerEmail,
  });

  /// Non-empty fixed CC email addresses (direktor, menadžer) that should
  /// receive every reminder email alongside the company and komercijalista.
  List<String> get ccEmails => [
    direktorEmail,
    menadzerEmail,
  ].where((email) => email.trim().isNotEmpty).toList();
}

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
}

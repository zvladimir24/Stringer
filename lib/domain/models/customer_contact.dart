class CustomerContact {
  final String pib;
  final String email;
  final String komercijalista;
  final String naslov;
  final String komercijalistaEmail;
  final DateTime? lastEmailSentAt;

  const CustomerContact({
    required this.pib,
    required this.email,
    this.komercijalista = '',
    this.naslov = '',
    this.komercijalistaEmail = '',
    this.lastEmailSentAt,
  });

  /// Non-empty CC email addresses (komercijalista) that should also receive
  /// the reminder alongside the company's email.
  List<String> get ccEmails =>
      [komercijalistaEmail].where((email) => email.trim().isNotEmpty).toList();

  CustomerContact copyWith({
    String? email,
    String? komercijalista,
    String? naslov,
    String? komercijalistaEmail,
    DateTime? lastEmailSentAt,
  }) {
    return CustomerContact(
      pib: pib,
      email: email ?? this.email,
      komercijalista: komercijalista ?? this.komercijalista,
      naslov: naslov ?? this.naslov,
      komercijalistaEmail: komercijalistaEmail ?? this.komercijalistaEmail,
      lastEmailSentAt: lastEmailSentAt ?? this.lastEmailSentAt,
    );
  }
}

class CustomerContact {
  final String pib;
  final String email;
  final String komercijalista;
  final String naslov;
  final String komercijalistaEmail;
  final String direktorEmail;
  final String menadzerEmail;
  final DateTime? lastEmailSentAt;

  const CustomerContact({
    required this.pib,
    required this.email,
    this.komercijalista = '',
    this.naslov = '',
    this.komercijalistaEmail = '',
    this.direktorEmail = '',
    this.menadzerEmail = '',
    this.lastEmailSentAt,
  });

  /// All non-empty CC email addresses (komercijalista, direktor, menadžer)
  /// that should also receive the reminder alongside the company's email.
  List<String> get ccEmails => [
    komercijalistaEmail,
    direktorEmail,
    menadzerEmail,
  ].where((email) => email.trim().isNotEmpty).toList();

  CustomerContact copyWith({
    String? email,
    String? komercijalista,
    String? naslov,
    String? komercijalistaEmail,
    String? direktorEmail,
    String? menadzerEmail,
    DateTime? lastEmailSentAt,
  }) {
    return CustomerContact(
      pib: pib,
      email: email ?? this.email,
      komercijalista: komercijalista ?? this.komercijalista,
      naslov: naslov ?? this.naslov,
      komercijalistaEmail: komercijalistaEmail ?? this.komercijalistaEmail,
      direktorEmail: direktorEmail ?? this.direktorEmail,
      menadzerEmail: menadzerEmail ?? this.menadzerEmail,
      lastEmailSentAt: lastEmailSentAt ?? this.lastEmailSentAt,
    );
  }
}

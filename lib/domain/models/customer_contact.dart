class CustomerContact {
  final String pib;
  final String email;
  final String komercijalista;
  final String naslov;
  final DateTime? lastEmailSentAt;

  const CustomerContact({
    required this.pib,
    required this.email,
    this.komercijalista = '',
    this.naslov = '',
    this.lastEmailSentAt,
  });

  CustomerContact copyWith({
    String? email,
    String? komercijalista,
    String? naslov,
    DateTime? lastEmailSentAt,
  }) {
    return CustomerContact(
      pib: pib,
      email: email ?? this.email,
      komercijalista: komercijalista ?? this.komercijalista,
      naslov: naslov ?? this.naslov,
      lastEmailSentAt: lastEmailSentAt ?? this.lastEmailSentAt,
    );
  }
}

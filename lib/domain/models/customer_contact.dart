class CustomerContact {
  final String pib;
  final String email;
  final String komercijalista;
  final DateTime? lastEmailSentAt;

  const CustomerContact({
    required this.pib,
    required this.email,
    this.komercijalista = '',
    this.lastEmailSentAt,
  });

  CustomerContact copyWith({String? email, String? komercijalista, DateTime? lastEmailSentAt}) {
    return CustomerContact(
      pib: pib,
      email: email ?? this.email,
      komercijalista: komercijalista ?? this.komercijalista,
      lastEmailSentAt: lastEmailSentAt ?? this.lastEmailSentAt,
    );
  }
}

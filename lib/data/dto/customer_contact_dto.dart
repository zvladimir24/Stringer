import 'package:stringer/domain/models/customer_contact.dart';

class CustomerContactDto {
  final String pib;
  final String email;
  final String komercijalista;
  final String naslov;
  final String? lastEmailSentAt;

  const CustomerContactDto({
    required this.pib,
    required this.email,
    this.komercijalista = '',
    this.naslov = '',
    this.lastEmailSentAt,
  });

  factory CustomerContactDto.fromJson(Map<String, dynamic> json) {
    return CustomerContactDto(
      pib: json['pib'] as String,
      email: json['email'] as String,
      komercijalista: json['komercijalista'] as String? ?? '',
      naslov: json['naslov'] as String? ?? '',
      lastEmailSentAt: json['lastEmailSentAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pib': pib,
      'email': email,
      'komercijalista': komercijalista,
      'naslov': naslov,
      'lastEmailSentAt': lastEmailSentAt,
    };
  }
}

extension CustomerContactDtoMapper on CustomerContactDto {
  CustomerContact toDomain() {
    return CustomerContact(
      pib: pib,
      email: email,
      komercijalista: komercijalista,
      naslov: naslov,
      lastEmailSentAt: lastEmailSentAt == null
          ? null
          : DateTime.parse(lastEmailSentAt!),
    );
  }
}

extension CustomerContactDomainMapper on CustomerContact {
  CustomerContactDto toDto() {
    return CustomerContactDto(
      pib: pib,
      email: email,
      komercijalista: komercijalista,
      naslov: naslov,
      lastEmailSentAt: lastEmailSentAt?.toIso8601String(),
    );
  }
}

import 'package:stringer/domain/models/customer_contact.dart';

class CustomerContactDto {
  final String pib;
  final String email;

  const CustomerContactDto({required this.pib, required this.email});

  factory CustomerContactDto.fromJson(Map<String, dynamic> json) {
    return CustomerContactDto(
      pib: json['pib'] as String,
      email: json['email'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'pib': pib, 'email': email};
  }
}

extension CustomerContactDtoMapper on CustomerContactDto {
  CustomerContact toDomain() {
    return CustomerContact(pib: pib, email: email);
  }
}

extension CustomerContactDomainMapper on CustomerContact {
  CustomerContactDto toDto() {
    return CustomerContactDto(pib: pib, email: email);
  }
}

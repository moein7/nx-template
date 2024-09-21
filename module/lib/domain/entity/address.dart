import 'package:address_module/domain/entity/country.dart';
import 'package:amazon_cognito_identity_dart_2/cognito.dart';

class AddressEntity {
  final String? id;
  final String? address;
  final String? email;
  final String? city;
  final String? name;
  final String? postcode;
  final String? phoneNumber;
  final String? companyName;
  final String? specifyingInfo;
  final CountryEntity? country;

  AddressEntity({
    this.id,
    this.address,
    this.email,
    this.city,
    this.name,
    this.postcode,
    this.phoneNumber,
    this.companyName,
    this.specifyingInfo,
    this.country,
  });

  AddressEntity copyWith({
    String? id,
    String? address,
    String? email,
    String? city,
    String? name,
    String? postcode,
    String? phoneNumber,
    String? companyName,
    String? specifyingInfo,
    CountryEntity? country,
  }) {
    return AddressEntity(
      id: id ?? this.id,
      address: address ?? this.address,
      email: email ?? this.email,
      city: city ?? this.city,
      name: name ?? this.name,
      postcode: postcode ?? this.postcode,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      companyName: companyName ?? this.companyName,
      specifyingInfo: specifyingInfo ?? this.specifyingInfo,
      country: country ?? this.country,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AddressEntity &&
        other.id == id &&
        other.address == address &&
        other.email == email &&
        other.city == city &&
        other.name == name &&
        other.postcode == postcode &&
        other.phoneNumber == phoneNumber &&
        other.companyName == companyName &&
        other.specifyingInfo == specifyingInfo &&
        other.country == country;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        address.hashCode ^
        email.hashCode ^
        city.hashCode ^
        name.hashCode ^
        postcode.hashCode ^
        phoneNumber.hashCode ^
        companyName.hashCode ^
        specifyingInfo.hashCode ^
        country.hashCode;
  }

  @override
  String toString() {
    return 'AddressEntity(id: $id, address: $address, email: $email, city: $city, name: $name, postcode: $postcode, phoneNumber: $phoneNumber, companyName: $companyName, specifyingInfo: $specifyingInfo, country: $country)';
  }

  Map<String, dynamic> toSenderMap() {
    return {
      'id': id,
      'senderAddress': address,
      'senderEmail': email,
      'senderCity': city,
      'senderName': name,
      'senderPostcode': postcode,
      'senderPhoneNumber': phoneNumber,
      'senderCompanyName': companyName,
      'senderSpecifyingInfo': specifyingInfo,
      'senderCountry': country?.toMap(),
    };
  }

  Map<String, dynamic> toRecipientMap() {
    return {
      'id': id,
      'recipientAddress': address,
      'recipientEmail': email,
      'recipientCity': city,
      'recipientName': name,
      'recipientPostcode': postcode,
      'recipientPhoneNumber': phoneNumber,
      'recipientCompanyName': companyName,
      'recipientSpecifyingInfo': specifyingInfo,
      'recipientCountry': country?.toMap(),
    };
  }

  Map<String, dynamic> toCognitoUserSenderAddressMap() {
    return {
      'id': id,
      'email': email,
      'custom:senderAddress': address,
      'custom:senderCity': city,
      'custom:senderName': name,
      'custom:senderPostcode': postcode,
      'custom:senderPhoneNumber': phoneNumber,
      'custom:senderCompanyName': companyName,
      'custom:senderSpecifyingInfo': specifyingInfo,
      'custom:senderCountry': country?.toMap(),
    };
  }

  factory AddressEntity.fromCognitoUserSenderAddressMap(
      List<CognitoUserAttribute> attributesList) {
    final normilizedAttributesList = attributesList.fold<Map<String, dynamic>>(
        {}, (prev, element) => {...prev, element.name!: element.value});

    return AddressEntity(
      id: normilizedAttributesList['id'].toString(),
      email: normilizedAttributesList['email'],
      address: normilizedAttributesList['custom:senderAddress'],
      city: normilizedAttributesList['custom:senderCity'],
      name: normilizedAttributesList['custom:senderName'],
      postcode: normilizedAttributesList['custom:senderPostcode'] ??
          normilizedAttributesList['custom:senderAddress'],
      phoneNumber: normilizedAttributesList['custom:senderPhoneNumber'],
      companyName: normilizedAttributesList['custom:senderCompanyName'],
      specifyingInfo: normilizedAttributesList['custom:senderSpecifyingInfo'],
      country: normilizedAttributesList['custom:senderCountry'] is CountryEntity
          ? normilizedAttributesList['custom:senderCountry']
          : normilizedAttributesList['custom:senderCountry'] is Map &&
                  normilizedAttributesList['custom:senderCountry']["code"] !=
                      null &&
                  normilizedAttributesList['custom:senderCountry']["name"] !=
                      null
              ? CountryEntity.fromMap(
                  normilizedAttributesList['custom:senderCountry'])
              : CountryEntity(
                  code: normilizedAttributesList['custom:senderCountry']
                      .toString(),
                  name: normilizedAttributesList['custom:senderCountry']
                      .toString(),
                ),
    );
  }

  factory AddressEntity.fromSenderMap(Map<String, dynamic> map) {
    return AddressEntity(
      id: map['id'].toString(),
      address: map['senderAddress'],
      email: map['senderEmail'],
      city: map['senderCity'],
      name: map['senderName'],
      postcode: map['senderPostcode'] ?? map['senderAddress'],
      phoneNumber: map['senderPhoneNumber'],
      companyName: map['senderCompanyName'],
      specifyingInfo: map['senderSpecifyingInfo'],
      country: map['senderCountry'] is CountryEntity
          ? map['senderCountry']
          : map['senderCountry'] is Map &&
                  map['senderCountry']["code"] != null &&
                  map['senderCountry']["name"] != null
              ? CountryEntity.fromMap(map['senderCountry'])
              : CountryEntity(
                  code: map['senderCountry'].toString(),
                  name: map['senderCountry'].toString(),
                ),
    );
  }
  factory AddressEntity.fromRecipentMap(Map<String, dynamic> map) {
    return AddressEntity(
      id: map['id'].toString(),
      address: map['recipientAddress'],
      email: map['recipientEmail'],
      city: map['recipientCity'],
      name: map['recipientName'],
      postcode: map['recipientPostcode'] ?? map['recipientAddress'],
      phoneNumber: map['recipientPhoneNumber'],
      companyName: map['recipientCompanyName'],
      specifyingInfo: map['recipientSpecifyingInfo'],
      country: map['recipientCountry'] is CountryEntity
          ? map['recipientCountry']
          : map['recipientCountry'] is Map &&
                  map['recipientCountry']["code"] != null &&
                  map['recipientCountry']["name"] != null
              ? CountryEntity.fromMap(map['recipientCountry'])
              : CountryEntity(
                  code: map['recipientCountry'].toString(),
                  name: map['recipientCountry'].toString(),
                ),
    );
  }
}

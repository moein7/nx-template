import 'package:equatable/equatable.dart';

class SuggestionEntity extends Equatable {
  final String id;
  final String formattedAddress;
  final bool hasDetails;
  final String? postcode;
  final String? name;
  final String? city;
  final String? state;
  final String? country;
  final String? countryCode;
  final String? buildingNumber;
  final String? subBuildingName;
  final String? district;
  final String? streetNumber;
  final String? route;

  const SuggestionEntity({
    required this.id,
    required this.formattedAddress,
    required this.hasDetails,
    this.postcode,
    this.name,
    this.city,
    this.state,
    this.country,
    this.countryCode,
    this.buildingNumber,
    this.subBuildingName,
    this.district,
    this.route,
    this.streetNumber,
  });

  @override
  String toString() {
    return formattedAddress;
  }

  @override
  List<Object> get props => [
        id,
        formattedAddress,
        hasDetails,
      ];

  factory SuggestionEntity.fromGetAddressIoMap(
      Map<String, dynamic> map, String postcode) {
    postcode = postcode.replaceAll(' ', '');
    map['id'] = postcode + map['formatted_address'].toString();
    map['postcode'] = postcode;

    return SuggestionEntity(
      id: map['id'],
      formattedAddress: map['formatted_address'].join(' '),
      postcode: map['postcode'],
      name: map['formatted_address'].join(' '),
      city: map['town_or_city'],
      country: map['country'],
      buildingNumber: map['building_number'],
      state: map['country'],
      subBuildingName: map['sub_building_number'],
      district: map['district'],
      hasDetails: true,
    );
  }
  factory SuggestionEntity.fromGooglePlacesSearch(Map<String, dynamic> map) {
    return SuggestionEntity(
      id: map['place_id'],
      formattedAddress: map['description'],
      hasDetails: false,
    );
  }
  factory SuggestionEntity.fromGooglePlacesDetails(Map<String, dynamic> map) {
    for (final comp in map['address_components']) {
      if (comp['types'].contains('postal_code')) {
        map['postcode'] = comp['long_name'];
      }

      if (comp['types'].contains('locality')) {
        map['town_or_city'] = comp['long_name'];
      }

      if (comp['types'].contains('postal_town')) {
        map['postal_town'] = comp['long_name'];
      }
      if (comp['types'].contains('administrative_area_level_1')) {
        map['administrative_area_level_1'] = comp['long_name'];
      }
      if (comp['types'].contains('administrative_area_level_2')) {
        map['state'] = comp['long_name'];
      }

      if (comp['types'].contains('country')) {
        map['country'] = comp['long_name'];
      }
      if (comp['types'].contains('route')) {
        map['route'] = comp['long_name'];
      }
      if (comp['types'].contains('street_number')) {
        map['street_number'] = comp['long_name'];
      }

      if (comp['types'].contains('neighborhood')) {
        map['neighborhood'] = comp['long_name'];
      }
    }

    final formattedAddressBuffer = StringBuffer();

    if (map['postal_town'] != null && map['town_or_city'] != null) {
      formattedAddressBuffer.write(map['postal_town'] + ', ');
    }

    if (map['street_number'] != null) {
      formattedAddressBuffer.write(map['street_number'] + ' ');
    }

    if (map['route'] != null) {
      formattedAddressBuffer.write(map['route'] + ', ');
    }

    if (map['neighborhood'] != null) {
      formattedAddressBuffer.write(map['neighborhood'] + ', ');
    }

    final fa = formattedAddressBuffer.toString();
    final formattedAddress =
        fa.endsWith(', ') ? fa.substring(0, fa.length - 2) : fa;

    return SuggestionEntity(
      id: map['place_id'],
      formattedAddress: formattedAddress,
      postcode: map['postcode'],
      name: map['name'],
      city: map['town_or_city'] ??
          map['postal_town'] ??
          map['administrative_area_level_1'],
      country: map['country'],
      state: map['state'],
      streetNumber: map['street_number'],
      route: map['route'],
      hasDetails: true,
    );
  }
}

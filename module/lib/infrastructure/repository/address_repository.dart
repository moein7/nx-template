import 'package:address_module/domain/entity/address.dart';
import 'package:address_module/domain/entity/country.dart';
import 'package:address_module/domain/entity/suggestion.dart';
import 'package:address_module/infrastructure/provider/address.dart';
import 'package:address_module/infrastructure/provider/cognitoUser.dart';
import 'package:address_module/infrastructure/provider/country.dart';
import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:mule_common/excpetions/serialization_exception.dart';

class AddressRepository {
  final AddressProvider _addressProvider;
  final CountryProvider _countryProvider;
  final CognitoProvider _cognitoProvider;

  AddressRepository({
    required AddressProvider addressProvider,
    required CountryProvider countryProvider,
    required CognitoProvider cognitoProvider,
  })  : _addressProvider = addressProvider,
        _cognitoProvider = cognitoProvider,
        _countryProvider = countryProvider;

  Future<AddressEntity?> getUserDefaultAddress(bool isLoggedIn) async {
    if (isLoggedIn) {
      return _addressProvider.getUserDefaultAddress();
    }
    return null;
  }

  Future<AddressEntity?> getAddressFromPostcode() {
    return _addressProvider.getAddressFromPostcode();
  }

  Future<List<CountryEntity>> getCountries() {
    return _countryProvider.getCountries();
  }

  Future<List<SuggestionEntity>> searchForAddress(
      String? pattern, CountryEntity country) {
    return _addressProvider.searchForAddress(pattern, country);
  }

  Future<bool> addUserAddress(AddressEntity address) {
    return _addressProvider.addUserAddress(address);
  }

  Future<SuggestionEntity> getSuggestionDetails(SuggestionEntity value) {
    return _addressProvider.getSuggestionDetails(value);
  }

  Future<void> updateUserAddress(AddressEntity addressEntity) {
    Map<String, dynamic> data;

    try {
      data = addressEntity.toCognitoUserSenderAddressMap();
    } catch (e) {
      throw SerializationException(
        data: addressEntity,
        error: e,
      );
    }

    return _cognitoProvider.updateUserAddress(data);
  }

  Future<AddressEntity?> getUserAddress() async {

    final List<CognitoUserAttribute> cognitoUserAttribute =
        await _cognitoProvider.getUserAddress();
    try {
      return AddressEntity.fromCognitoUserSenderAddressMap(
        cognitoUserAttribute,
      );
    } catch (e) {
      throw SerializationException(
        data: cognitoUserAttribute,
        error: e,
      );
    }
  }
}

import 'package:address_module/domain/entity/address.dart';
import 'package:address_module/domain/entity/country.dart';
import 'package:address_module/domain/entity/suggestion.dart';

abstract class AddressProvider {
  Future<bool> addUserAddress(AddressEntity address);
  Future<AddressEntity?> getUserDefaultAddress();
  Future<AddressEntity?> getAddressFromPostcode();
  Future<List<SuggestionEntity>> searchForAddress(
      String? input, CountryEntity country);
  Future<SuggestionEntity> getSuggestionDetails(SuggestionEntity suggestion);
}

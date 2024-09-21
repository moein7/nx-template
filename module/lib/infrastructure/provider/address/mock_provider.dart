import 'dart:convert';
import 'package:address_module/domain/entity/suggestion.dart';
import 'package:address_module/domain/entity/country.dart';
import 'package:address_module/domain/entity/address.dart';
import 'package:address_module/infrastructure/provider/address.dart';
import 'package:flutter/services.dart';

const mockFilePath = 'packages/address_module/assets/mocks/senderAddress.json';

class AddressMockProvider extends AddressProvider {
  @override
  Future<bool> addUserAddress(AddressEntity address) {
    // TODO: implement addUserAddress
    throw UnimplementedError();
  }

  @override
  Future<AddressEntity?> getAddressFromPostcode() {
    // TODO: implement getAddressFromPostcode
    throw UnimplementedError();
  }

  @override
  Future<List<CountryEntity>> getCountries() {
    // TODO: implement getCountries
    throw UnimplementedError();
  }

  @override
  Future<SuggestionEntity> getSuggestionDetails(SuggestionEntity suggestion) {
    // TODO: implement getSuggestionDetails
    throw UnimplementedError();
  }

  @override
  Future<AddressEntity> getUserDefaultAddress() async {
    String data = await rootBundle.loadString(mockFilePath);
    await Future.delayed(const Duration(seconds: 1));

    final AddressEntity senderAddress =
        AddressEntity.fromSenderMap(jsonDecode(data)['senderMockAddress']);
    return senderAddress;
  }

  @override
  Future<List<SuggestionEntity>> searchForAddress(
      String? input, CountryEntity country) {
    // TODO: implement searchForAddress
    throw UnimplementedError();
  }
}

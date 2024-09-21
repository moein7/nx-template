import 'package:address_module/address_module.dart';
import 'package:address_module/domain/entity/address.dart';
import 'package:address_module/domain/entity/suggestion.dart';
import 'package:address_module/exceptions/address_exception.dart';
import 'package:mule_common/mule_common.dart';
import '../infrastructure/repository/address_repository.dart';

class AddressService {
  final AddressRepository addressRepository;
  final AddressDependency dependency;

  AddressService({
    required this.addressRepository,
    required this.dependency,
  });

  Future<AddressEntity?> getAddressFromPostcode() {
    return addressRepository.getAddressFromPostcode();
  }

  Future<List<CountryEntity>> getCountries() {
    return addressRepository.getCountries();
  }

  Future<AddressEntity?> getUserDefaultAddress() {
    return addressRepository.getUserDefaultAddress(
      isLoggedIn(),
    );
  }

  Future<List<SuggestionEntity>> searchForAddress(
      String? pattern, CountryEntity country) {
    return addressRepository.searchForAddress(pattern, country);
  }

  Future<bool> addUserAddress(AddressEntity addressEntity) {
    return addressRepository.addUserAddress(addressEntity);
  }

  bool isLoggedIn() {
    return dependency.isLoggedIn!();
  }

  void onLogin() => dependency.onLogin!();

  Future<SuggestionEntity> getSuggestionDetails(SuggestionEntity value) {
    return addressRepository.getSuggestionDetails(value);
  }

  Future<void> updateUserAddress(AddressEntity address) async {
    try {
      return await addressRepository.updateUserAddress(address);
    } on ServerException catch (e) {
      throw UpdateAddressException(
        code: e.code,
        message: e.message,
      );
    }
  }

  Future<AddressEntity?> getUserAddress() async {
    try {
      return await addressRepository.getUserAddress();
    } on ServerException catch (e) {
      throw GetAddressException(
        code: e.code,
        message: e.message,
      );
    }
  }
}

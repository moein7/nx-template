import 'package:address_module/address_module.dart';

abstract class CountryProvider {
  Future<List<CountryEntity>> getCountries();
}

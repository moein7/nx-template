import 'package:address_module/domain/entity/country.dart';
import 'package:address_module/infrastructure/provider/country.dart';

class CountryMockProvider extends CountryProvider {
  @override
  Future<List<CountryEntity>> getCountries() {
    // TODO: implement getCountries
    throw UnimplementedError();
  }
}

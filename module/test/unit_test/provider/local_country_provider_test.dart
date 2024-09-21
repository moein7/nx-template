import 'package:address_module/infrastructure/provider/country.dart';
import 'package:address_module/infrastructure/provider/country/local_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late CountryProvider provider;
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    provider = CountryLocalProvider();
  });
  group('LocalCountryProvider', () {
    group('getCountries', () {
      test('Should return list of countries', () async {
        final countries = await provider.getCountries();

        expect(
          countries.isNotEmpty,
          true,
        );
      });
    });
  });
}

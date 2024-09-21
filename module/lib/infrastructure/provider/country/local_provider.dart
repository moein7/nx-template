import 'dart:convert';

import 'package:address_module/domain/entity/country.dart';
import 'package:address_module/infrastructure/provider/country.dart';
import 'package:flutter/services.dart';

const countryPath = 'packages/address_module/assets/countries.json';

class CountryLocalProvider extends CountryProvider {
  @override
  Future<List<CountryEntity>> getCountries() async {
    String data = await rootBundle.loadString(countryPath);

    if (jsonDecode(data) is Iterable) {
      final countries = List<CountryEntity>.from(
        (jsonDecode(data) as Iterable).map((e) => CountryEntity.fromMap(e)),
      );

      // Here we call toSet and then toList to remove duplicates.
      return countries.toSet().toList();
    }

    return [];
  }
}

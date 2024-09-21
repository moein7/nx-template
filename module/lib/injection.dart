import 'package:address_module/dependency.dart';
import 'package:address_module/infrastructure/provider/address.dart';
import 'package:address_module/infrastructure/provider/address/cognito_provider.dart';
import 'package:address_module/infrastructure/provider/cognitoUser.dart';
import 'package:address_module/infrastructure/provider/address/http_provider.dart';
import 'package:address_module/infrastructure/provider/country/local_provider.dart';
import 'package:address_module/infrastructure/provider/address/mock_provider.dart';
import 'package:address_module/infrastructure/provider/country.dart';
import 'package:address_module/infrastructure/provider/country/mock_provider.dart';
import 'package:get_it/get_it.dart';

import 'api.dart';
import 'application/address_service.dart';
import 'config.dart';
import 'infrastructure/repository/address_repository.dart';

final serviceLocator = GetIt.instance;

Future<void> registerDependencies({
  required AddressConfig config,
  required AddressDependency dependency,
}) async {
  if (config.environment.contains('dev')) {
    //It should be Mock Provider but I didn't Implement them right now
    _registerProviders(config: config, dependency: dependency);
  } else {
    _registerProviders(config: config, dependency: dependency);
  }

  serviceLocator.registerLazySingleton<AddressRepository>(
    () => AddressRepository(
      addressProvider: serviceLocator(),
      countryProvider: serviceLocator(),
      cognitoProvider: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton<AddressService>(
    () => AddressService(
      addressRepository: serviceLocator(),
      dependency: dependency,
    ),
  );

  serviceLocator.registerLazySingleton<AddressApi>(
    () => AddressApi(
      addressService: serviceLocator(),
    ),
  );
}

void _registerProviders({
  required AddressConfig config,
  required AddressDependency dependency,
}) {
  serviceLocator.registerLazySingleton<AddressProvider>(
    () => HttpAddressProvider(
      baseUrl: config.baseUrlApi,
      dio: dependency.getDio(),
      getAddressIoApiKey: config.getAddressIoApiKey,
      getAddressIoApiEndpoint: config.getAddressIoApiEndpoint,
    ),
  );

  serviceLocator.registerLazySingleton<CognitoProvider>(
    () => CognitoAttributesProvider(
      dependency: dependency,
    ),
  );

  serviceLocator.registerLazySingleton<CountryProvider>(
    () => CountryLocalProvider(),
  );
}

void _registerMockProviders({
  required AddressConfig config,
  required AddressDependency dependency,
}) {
  serviceLocator.registerLazySingleton<AddressProvider>(
    () => AddressMockProvider(),
  );
  serviceLocator.registerLazySingleton<CountryProvider>(
    () => CountryMockProvider(),
  );
}

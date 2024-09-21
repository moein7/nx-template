library address_module;

import 'package:address_module/dependency.dart';
import 'package:routemaster/routemaster.dart';

import 'api.dart';
import 'config.dart';
import 'injection.dart';
import 'presentation/router_map.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

export 'config.dart';
export 'dependency.dart';
export 'presentation/address_form/page.dart'
    show AddressFormPageState, CountryOrPostcodeChanged;
export 'domain/entity/country.dart';

class AddressModule {
  final AddressConfig config;
  final AddressDependency dependency;

  AddressModule({
    required this.config,
    required this.dependency,
  });

  /// Initialize dependencies of this module
  /// this should be called in the main method of the app
  /// before actually running the app
  Future ensureInitialized() async {
    await registerDependencies(
      config: config,
      dependency: dependency,
    );
  }

  AddressApi get api => GetIt.I.get<AddressApi>();

  Map<String, RouteSettings Function(RouteData)> get routes => RouterMap.routes;
}

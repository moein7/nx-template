import 'dart:async';
import 'dart:developer';

import 'package:auth_module/auth_module.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mule_theme/mule_theme.dart';

import 'package:address_module/address_module.dart';
import 'package:address_module/application/address_service.dart';
import 'package:address_module/domain/entity/address.dart';

import 'error_handler.dart';

const api = 'https://staging.api.mule.app';

const env = 'staging';

final testAddress = AddressEntity(
  id: 'id',
  address: 'address sample value',
  email: 'email.sample.value@gmail.com',
  city: 'city sample value',
  name: 'name smaple value',
  postcode: 'postcode sample value',
  phoneNumber: 'phone number sample value',
  country: const CountryEntity(
    code: 'IR',
    name: 'Iran',
  ),
);

final authModule = Auth(
  config: AuthConfig(
    baseUrl: 'www.web.mule.app',
    baseUrlApi: 'https://staging.api.mule.app',
    environment: env,
    cognitoClientId: '3hu9sabde6eds8rek3i0sa0j0e',
    cognitoUserPoolId: 'eu-west-2_e1e0So0vj',
  ),
);

final address = AddressModule(
  config: AddressConfig(
    baseUrlApi: api,
    environment: env,
    getAddressIoApiKey: 'HbHo9f1Wi0KiIdpwH0FncQ25321',
    getAddressIoApiEndpoint: 'https://api.getAddress.io',
  ),
  dependency: AddressDependency(
    onLogin: () {
      log('redirecting to login page...');
    },
    getDio: () {
      final dio = Dio();
      dio.interceptors.add(authModule.api.getDioAuthInterceptor());
      return dio;
    },
    isLoggedIn: () {
      final val = authModule.api.isLoggedIn();
      log("is logged in: $val");
      return val;
    },
    getCognitoUser: authModule.api.getCognitoUser,
  ),
);

Future<void> main() async {
  await authModule.ensureInitialized();
  if (!authModule.api.isLoggedIn()) {
    await authModule.api.signInWithEmail('sajad@mule.app', 'Sajad@123');
  }

  await address.ensureInitialized();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final ErrorHandler errorHandler = ErrorHandler(navigatorKey);

  WidgetsFlutterBinding.ensureInitialized();
  runZonedGuarded(() {
    FlutterError.onError = (error) {
      errorHandler.handleError(error, null);
    };

    runApp(
      MyApp(navigatorKey: navigatorKey),
    );
  }, errorHandler.handleError);
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
    required this.navigatorKey,
  }) : super(key: key);

  final GlobalKey<NavigatorState> navigatorKey;

  @override
  Widget build(BuildContext context) {
    return MuleAppTheme(
      theme: MuleLightTheme,
      typographyLanguage: MuleTypographyLanguage.en,
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'Address Demo Example',
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final addressPageKey = GlobalKey<AddressFormPageState>();
  final TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MuleAppTheme.of(context).colors.background,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        address.api.getDefaultAddressForm(),
                        address.api.getSelectCountryField(
                            textController: controller,
                            prefixIcon: const Icon(Icons.search),
                            inputDecoration: const InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                            ),
                            onSelected: (_) {
                              controller.clear();
                              setState(() {});
                            },
                            excludedCodes: ['GB']),
                        Row(
                          children: [
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () {
                                final map = addressPageKey.currentState!
                                    .validateAndSave();

                                log(map.toString());
                              },
                              child: const Text('Submit'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                final map = addressPageKey.currentState!.save();

                                log(map.toString());
                              },
                              child: const Text('Save'),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () async {
                                // final address = await GetIt.I
                                //     .get<AddressService>()
                                //     .getUserDefaultAddress();

                                final _address = address.api.getUserAddress();
                                log(_address.toString());
                                setState(() {});
                              },
                              child: const Text('Retrive user address'),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () {
                                GetIt.I.get<AddressService>().addUserAddress(
                                      testAddress,
                                    );
                              },
                              child: const Text('Create a sample address'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
                address.api.getAddressForm(
                  key: addressPageKey,
                  // initialRecipient: testAddress,
                  // initialSender: testAddress,
                  onRecipientChanged: (country, postcode) {
                    log('recipient changed: $country, $postcode');
                  },
                  onSenderChanged: (country, postcode) {
                    log('sender changed: $country, $postcode');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

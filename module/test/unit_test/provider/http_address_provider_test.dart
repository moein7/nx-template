import 'package:address_module/address_module.dart';
import 'package:address_module/domain/entity/suggestion.dart';
import 'package:address_module/infrastructure/provider/address/http_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import 'mock_data.dart';

const api = 'https://staging.api.mule.app';
const getAddressIoApiEndpoint = 'https://api.getAddress.io';
const getAddressIoApiKey = 'HbHo9f1Wi0KiIdpwH0FncQ25321';
void main() {
  late Dio dio;
  late HttpAddressProvider provider;
  late DioAdapter dioAdapter;
  setUp(() {
    dio = Dio();
    dioAdapter = DioAdapter(dio: dio);
    provider = HttpAddressProvider(
      dio: dio,
      baseUrl: api,
      getAddressIoApiKey: getAddressIoApiKey,
      getAddressIoApiEndpoint: getAddressIoApiEndpoint,
    );
  });
  group('HttpAddressProvider', () {
    group('getUserDefaultAddress', () {
      test('Should return the user address', () async {
        const route = '$api/v2/users/senderAddress';

        dioAdapter.onGet(
          route,
          (server) => server.reply(200, mockUserAddress.toSenderMap()),
        );

        final userAddress = await provider.getUserDefaultAddress();

        expect(userAddress, mockUserAddress);
      });
      test('Should return null if user had no address', () async {
        const route = '$api/v2/users/senderAddress';

        dioAdapter.onGet(
          route,
          (server) => server.reply(200, null),
        );

        final userAddress = await provider.getUserDefaultAddress();

        expect(userAddress, null);
      });
    });
    group('addUserAddress', () {
      test('Should add the user address and return true', () async {
        final userAddress = mockUserAddress;

        const route = '$api/v2/users/senderAddress';

        final data = Map<String, dynamic>.from(mockUserAddress.toSenderMap());

        data.remove('id');

        dioAdapter.onPost(
          route,
          (server) => server.reply(201, true),
          data: data,
        );

        final res = await provider.addUserAddress(userAddress);

        expect(res, true);
      });
      // TODO(sajad): uncomment this after adding equatble for exceptions
      // test('Should throw exception if status code was not 201', () async {
      //   final userAddress = mockUserAddress;

      //   const route = '$api/v2/users/senderAddress';

      //   final data = Map<String, dynamic>.from(mockUserAddress.toSenderMap());

      //   data.remove('id');

      //   dioAdapter.onPost(
      //     route,
      //     (server) => server.throws(
      //       206,
      //       DioError(
      //         requestOptions: RequestOptions(path: route),
      //       ),
      //     ),
      //     data: data,
      //   );

      //   expect(
      //     () => provider.addUserAddress(userAddress),
      //     throwsA(
      //       ServerException(message: 'Unknown', code: 'Unknown', status: 506),
      //     ),
      //   );
      // });
    });

    group('searchForAddress ', () {
      Future<void> sendRequestForDomestic(String pattern) async {
        const country = CountryEntity(code: 'GB', name: 'United Kingdom');
        final route = '$getAddressIoApiEndpoint/find/$pattern?expand=true';

        dioAdapter.onGet(
          route,
          (server) {
            return server.reply(200, mockDomesticSuggestion);
          },
          queryParameters: {
            'api-key': getAddressIoApiKey,
          },
        );

        final result = await provider.searchForAddress(
          pattern,
          country,
        );
        final matcher = pattern.length < 5 || pattern.length > 7
            ? []
            : (mockDomesticSuggestion['addresses'] as Iterable)
                .map(
                  (e) => SuggestionEntity.fromGetAddressIoMap(e, pattern),
                )
                .toList();

        expect(result, matcher);
      }

      Future<void> sendRequestForInternational(String pattern) async {
        const country = CountryEntity(code: 'US', name: 'United States');
        const route = '$api/v3/address/search';

        dioAdapter.onGet(
          route,
          (server) {
            return server.reply(200, mockInternationalSuggestion);
          },
          queryParameters: {
            'countryCode': 'us',
            'input': pattern,
          },
        );

        final result = await provider.searchForAddress(
          pattern,
          country,
        );

        expect(
          result,
          (mockInternationalSuggestion['addresses'] as Iterable)
              .map(
                (e) => SuggestionEntity.fromGooglePlacesSearch(e),
              )
              .toList(),
        );
      }

      test(
          'Should return empty list if pattern is empty or length is greather than 7 or lesser than 5',
          () {
        sendRequestForDomestic('');
        sendRequestForDomestic('1234');
        sendRequestForDomestic('12345678');
        sendRequestForInternational('');
      });
      test('Should use getAddress.io for UK country', () async {
        sendRequestForDomestic('nn11er');
      });
      test('Should use google places for internationals ', () async {
        sendRequestForInternational('780');
      });
    });
  });
}

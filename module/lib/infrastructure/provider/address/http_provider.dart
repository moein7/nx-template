import 'dart:developer';

import 'package:address_module/infrastructure/provider/cognitoUser.dart';
import 'package:dio/dio.dart';
import 'package:mule_common/mule_common.dart';
import 'package:uuid/uuid.dart';

import 'package:address_module/domain/entity/address.dart';
import 'package:address_module/domain/entity/country.dart';
import 'package:address_module/domain/entity/suggestion.dart';
import 'package:address_module/infrastructure/provider/address.dart';

class HttpAddressProvider extends AddressProvider {
  final Dio dio;
  final String baseUrl;

  final String getAddressIoApiKey;
  final String getAddressIoApiEndpoint;

  HttpAddressProvider({
    required this.dio,
    required this.baseUrl,
    required this.getAddressIoApiKey,
    required this.getAddressIoApiEndpoint,
  });

  final Uuid uuid = const Uuid();
  late final String sessionToken = uuid.v4();

  @override
  Future<AddressEntity?> getAddressFromPostcode() async {
    return null;
  }

  @override
  Future<AddressEntity?> getUserDefaultAddress() async {
    try {
      final res = await dio.get('$baseUrl/v2/users/senderAddress');

      if (res.statusCode == 200) {
        return AddressEntity.fromSenderMap(res.data);
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 404) {
        return null;
      }

      // TODO(sajad): Remove this after fixing authentication
      if (e.response?.statusCode == 403) {
        rethrow;
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  @override
  Future<List<SuggestionEntity>> searchForAddress(
      String? input, CountryEntity country) async {
    final pattern = input?.trim();

    if (pattern == null || pattern.isEmpty) {
      return Future.delayed(const Duration(seconds: 1), () => []);
    }

    final List<SuggestionEntity> results = List.empty(growable: true);

    final options = dio.options.copyWith();
    final interceptors = List<Interceptor>.from(dio.interceptors);

    dio.options = BaseOptions();
    dio.interceptors.clear();

    if (country.isDomestic()) {
      try {
        final clearPattern = pattern.replaceAll(' ', '');
        if (clearPattern.length < 5 || clearPattern.length > 7) {
          return [];
        }
        final res = await dio.get(
          '$getAddressIoApiEndpoint/find/$clearPattern?expand=true',
          queryParameters: {
            'api-key': getAddressIoApiKey,
          },
        );

        final Iterable<SuggestionEntity> sugs =
            res.data['addresses'].map<SuggestionEntity>((map) {
          return SuggestionEntity.fromGetAddressIoMap(map, pattern);
        });
        results.addAll(sugs);
      } on DioError catch (e) {
        if (e.response?.statusCode == 400) {}
      }
    } else {
      try {
        final res = await dio.get(
          '$baseUrl/v3/address/search',
          queryParameters: {
            'input': pattern,
            'countryCode': country.code,
          },
        );
        if (res.data['status'] == 'OK') {
          final Iterable<SuggestionEntity> sugs =
              res.data['predictions'].map<SuggestionEntity>((map) {
            return SuggestionEntity.fromGooglePlacesSearch(map);
          });

          results.addAll(sugs);
        }
      } catch (e) {
        log(e.toString());
      }
    }

    dio.options = options;
    dio.interceptors.addAll(interceptors);

    return results;
  }

  @override
  Future<bool> addUserAddress(AddressEntity address) async {
    final data = address.toSenderMap();

    data.remove('id');
    try {
      final res = await dio.post(
        '$baseUrl/v2/users/senderAddress',
        data: data,
      );

      if (res.statusCode == 201) {
        return true;
      }
    } on DioError catch (e) {
      final res = e.response;

      throw ServerException(
        status: res?.statusCode ?? 500,
        message: res?.data?['message'] as String? ?? 'Unknown',
        code: res?.data?['message'] as String? ?? 'Unknown',
        data: res?.data?['details'] ?? 'Unknown',
      );
    }

    return false;
  }

  @override
  Future<SuggestionEntity> getSuggestionDetails(
      SuggestionEntity suggestion) async {
    SuggestionEntity? result;

    final options = dio.options.copyWith();
    final interceptors = List<Interceptor>.from(dio.interceptors);

    dio.options = BaseOptions();
    dio.interceptors.clear();

    try {
      final res = await dio.get(
        '$baseUrl/v3/address/place',
        queryParameters: {
          'id': suggestion.id,
        },
      );
      if (res.data['status'] == 'OK') {
        result = SuggestionEntity.fromGooglePlacesDetails(res.data['result']);
      }

      result!;
    } catch (e) {
      log(e.toString());
    }

    dio.options = options;
    dio.interceptors.addAll(interceptors);

    return result!;
  }
}

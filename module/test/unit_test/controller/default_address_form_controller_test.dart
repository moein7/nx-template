import 'package:address_module/application/address_service.dart';
import 'package:address_module/presentation/default_address_form/controller.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mule_common/mule_common.dart';

import './mock_data.dart';
import 'address_form_controller_test.mocks.dart';

@GenerateMocks([AddressService])
void main() {
  late DefaultAddressFormController defaultAddressController;
  late MockAddressService mockAddressService;

  setUp(() {
    mockAddressService = MockAddressService();
    defaultAddressController =
        DefaultAddressFormController(service: mockAddressService);
  });

  group('defaultAddressController', () {
    test('Should be in initializing state', () {
      expect(defaultAddressController.viewStatus, ViewStatus.initializing);
    });
    test('Should set loading correctly when user is not logged in', () async {
      when(mockAddressService.isLoggedIn()).thenReturn(false);
      when(mockAddressService.getUserDefaultAddress()).thenAnswer(
        (_) => Future.error(
          DioError(
            requestOptions: RequestOptions(path: 'x'),
            response: Response(
              requestOptions: RequestOptions(path: 'x'),
              statusCode: 403,
            ),
          ),
        ),
      );

      final future = defaultAddressController.loadData();

      expect(defaultAddressController.viewStatus, ViewStatus.loading);

      await future;

      expect(defaultAddressController.viewStatus, ViewStatus.error);
    });
    test('Should set loading correctly when user is logged in', () async {
      when(mockAddressService.isLoggedIn()).thenReturn(true);
      when(mockAddressService.getUserDefaultAddress()).thenAnswer(
        (realInvocation) => Future.delayed(
          const Duration(milliseconds: 500),
          () => mockUserAddress,
        ),
      );

      final future = defaultAddressController.loadData();

      expect(defaultAddressController.viewStatus, ViewStatus.loading);

      await future;

      expect(defaultAddressController.viewStatus, ViewStatus.loaded);
    });
  });
}

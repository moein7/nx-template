import 'package:address_module/application/address_service.dart';
import 'package:address_module/presentation/address_form/controller.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mule_common/mule_common.dart';

import './mock_data.dart';
import 'address_form_controller_test.mocks.dart';

@GenerateMocks([AddressService])
void main() {
  late AddressFormController addressController;
  late MockAddressService mockAddressService;

  setUp(() {
    mockAddressService = MockAddressService();
    addressController = AddressFormController(service: mockAddressService);
  });

  group('AddressController', () {
    test('Should be in initializing state', () {
      expect(addressController.viewStatus, ViewStatus.initializing);
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

      final future = addressController.loadData();

      expect(addressController.viewStatus, ViewStatus.loaded);

      await future;

      expect(addressController.viewStatus, ViewStatus.loaded);
    });
    test('Should set loading correctly when user is logged in', () async {
      when(mockAddressService.isLoggedIn()).thenReturn(true);
      when(mockAddressService.getUserDefaultAddress()).thenAnswer(
        (realInvocation) => Future.delayed(
          const Duration(milliseconds: 500),
          () => mockUserAddress,
        ),
      );

      final future = addressController.loadData();

      expect(addressController.viewStatus, ViewStatus.loading);

      await future;

      expect(addressController.viewStatus, ViewStatus.loaded);
    });
    test('Should show log in to google when user is not logged in', () async {
      when(mockAddressService.isLoggedIn()).thenReturn(false);

      expect(addressController.showGoToLogin, true);
    });
  });
}

import 'package:address_module/infrastructure/provider/address/mock_provider.dart';
import 'package:flutter_test/flutter_test.dart';

import './mock_data.dart';

void main() {
  late AddressMockProvider provider;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    provider = AddressMockProvider();
  });

  group('MockAddressProvider', () {
    group('getUserDefaultAddress', () {
      test('Should return the user address', () async {
        final userAddress = await provider.getUserDefaultAddress();
        expect(userAddress, mockSenderAddress);
      });
    });
  });
}

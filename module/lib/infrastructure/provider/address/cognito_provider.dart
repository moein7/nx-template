import 'package:address_module/address_module.dart';
import 'package:address_module/infrastructure/provider/cognitoUser.dart';
import 'package:mule_common/excpetions/server_exception.dart';
import 'package:amazon_cognito_identity_dart_2/cognito.dart';

class CognitoAttributesProvider extends CognitoProvider {
  CognitoAttributesProvider({
    required AddressDependency dependency,
  }) : _dependency = dependency;

  final AddressDependency _dependency;

  @override
  Future<List<CognitoUserAttribute>> getUserAddress() async {
    try {
      final user = await _dependency.getCognitoUser();
      if (user == null) {
        throw ServerException(
          message: 'can\'t find user',
          code: 'USER_NOT_FOUND',
        );
      }
      List<CognitoUserAttribute>? attributes = await user.getUserAttributes();
      return attributes!.toList();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(
        message: 'unhandle cognito error for getting attributes',
        code: 'GET_ATTRIBUTE_ERROR',
      );
    }
  }

  @override
  Future<void> updateUserAddress(Map<String, dynamic> address) async {
    try {
      final user = await _dependency.getCognitoUser();
      if (user == null) {
        throw ServerException(
          message: 'can\'t find user',
          code: 'USER_NOT_FOUND',
        );
      }

      final List<CognitoUserAttribute> attributes = [];
      attributes.addAll([
        CognitoUserAttribute(
          name: 'custom:senderSpecifyingInfo',
          value: address['custom:senderSpecifyingInfo'],
        ),
        CognitoUserAttribute(
          name: 'custom:senderCity',
          value: address['custom:senderCity'],
        ),
        CognitoUserAttribute(
          name: 'custom:senderAddress',
          value: address['custom:senderAddress'],
        ),
        CognitoUserAttribute(
          name: 'custom:senderPostcode',
          value: address['custom:senderPostcode'],
        ),
      ]);
      await user.updateAttributes(attributes);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(
        message: 'unhandled cognito error for updating attributes',
        code: 'UPDATE_ATTRIBUTE_ERROR',
      );
    }
  }
}

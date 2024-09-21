import 'package:amazon_cognito_identity_dart_2/cognito.dart';

abstract class CognitoProvider {
  Future<List<CognitoUserAttribute>> getUserAddress();
  Future<void> updateUserAddress(Map<String, dynamic> address);
}

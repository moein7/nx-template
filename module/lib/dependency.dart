import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class AddressDependency {
  final Dio Function() getDio;
  final bool Function()? isLoggedIn;
  final Future<CognitoUser?> Function() getCognitoUser;
  final VoidCallback? onLogin;

  AddressDependency({
    required this.getDio,
    required this.getCognitoUser,
    this.isLoggedIn,
    this.onLogin,
  });
}

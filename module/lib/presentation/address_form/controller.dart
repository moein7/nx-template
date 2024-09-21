import 'package:address_module/domain/entity/address.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mule_common/mule_common.dart';

import 'package:address_module/application/address_service.dart';
import 'package:uuid/uuid.dart';

class AddressFormController extends ChangeNotifier
    with FormMixin, StateMixin<AddressEntity> {
  final AddressService service;

  final Uuid uuid = const Uuid();

  AddressFormController({
    required this.service,
  });

  Future<void> loadData() async {
    if (!showGoToLogin) {
      changeState(null, viewStatus: ViewStatus.loading);
      AddressEntity? address;
      // TODO(sajad): Remove this after fixing authentication
      try {
        address = await service.getUserDefaultAddress();
      } catch (e) {
        if (e is DioError && e.response!.statusCode == 403) {
          showGoToLogin = true;
        }
      }

      changeState(address, viewStatus: ViewStatus.loaded);
    } else {
      changeState(null, viewStatus: ViewStatus.loaded);
    }
  }

  Map<String, dynamic>? validateAndSave() {
    if (validateForm()) {
      return saveForm();
    }
    return null;
  }

  @override
  Map<String, dynamic> saveForm() {
    final map = super.saveForm();
    final senderAddress = AddressEntity.fromSenderMap(map);
    final recipientAddress = AddressEntity.fromRecipentMap(map);
    return {
      'sender': senderAddress,
      'recipient': recipientAddress,
    };
  }

  late bool showGoToLogin = !service.isLoggedIn();

  void onTapLogin() => service.onLogin();
}

import 'package:address_module/application/address_service.dart';
import 'package:address_module/domain/entity/address.dart';
import 'package:address_module/exceptions/address_exception.dart';
import 'package:flutter/material.dart';
import 'package:mule_common/mule_common.dart';
import 'package:mule_widgets/mule_widgets.dart';

class DefaultAddressFormController extends ChangeNotifier
    with FormMixin, StateMixin<AddressEntity> {
  final AddressService service;

  DefaultAddressFormController({
    required this.service,
  });

  Future<void> loadData() async {
    changeState(null, viewStatus: ViewStatus.loading);

    try {
      final address = await service.getUserAddress();
      changeState(address, viewStatus: ViewStatus.loaded);
    } catch (e) {
      changeState(null, viewStatus: ViewStatus.error);
      rethrow;
    }
  }

  void submit(BuildContext context) async {
    if (validateForm()) {
      final address = super.saveForm();

      final AddressEntity addressForm = AddressEntity(
        specifyingInfo: address['senderSpecifyingInfo'],
        postcode: address['senderPostcode'],
        city: address['senderCity'],
        address: address['senderAddress'],
      );

      try {
        await service.updateUserAddress(addressForm);
        MuleSnackbar.show(
          context: context,
          message: 'Your address successfully updated',
          labelType: LabelType.success,
        );
      } catch (e) {
        rethrow;
      }
    }
  }
}

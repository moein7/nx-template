import 'package:address_module/address_module.dart';
import 'package:address_module/domain/entity/address.dart';
import 'package:address_module/presentation/default_address_form/page.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'application/address_service.dart';
import 'presentation/address_form/page.dart';
import 'presentation/widgets/select_country_field.dart';

class AddressApi {
  final AddressService addressService;

  AddressApi({required this.addressService});

  Widget getAddressForm({
    required GlobalKey<AddressFormPageState>? key,
    final AddressEntity? initialSender,
    final AddressEntity? initialRecipient,
    final CountryOrPostcodeChanged? onSenderChanged,
    final CountryOrPostcodeChanged? onRecipientChanged,
  }) {
    return AddressFormPage(
      key: key,
      initialSender: initialSender,
      initialRecipient: initialRecipient,
      onRecipientChanged: onRecipientChanged,
      onSenderChanged: onSenderChanged,
    );
  }

  Widget getDefaultAddressForm() {
    return const DefaultAddressFormPage();
  }

  Future<AddressEntity?> getUserAddress() async {
    final service = GetIt.I.get<AddressService>();
    return await service.getUserAddress();
  }

  Widget getSelectCountryField({
    Key? key,
    CountryEntity? initialValue,
    FormFieldValidator<CountryEntity>? validator,
    bool enabled = true,
    @Deprecated('Use `labelText` instead') String? lableText,
    String? labelText,
    String? helperText,
    FormFieldSetter<CountryEntity>? onSaved,
    void Function(CountryEntity value)? onSelected,
    TextEditingController? textController,
    InputDecoration? inputDecoration,
    Widget? prefix,
    Widget? prefixIcon,
    BoxConstraints? prefixIconConstraints,
    List<String>? excludedAlphaCodes,
    List<String>? excludedCodes,
  }) {
    return SelectCountryField(
      key: key,
      initialValue: initialValue,
      textController: textController,
      enabled: enabled,
      helperText: helperText,
      lableText: labelText ?? lableText,
      onSaved: onSaved,
      onSelected: onSelected,
      validator: validator,
      inputDecoration: inputDecoration,
      prefix: prefix,
      prefixIcon: prefixIcon,
      prefixIconConstraints: prefixIconConstraints,
      excludedAlphaCodes: excludedAlphaCodes,
      excludedCodes: excludedCodes,
    );
  }
}

import 'package:address_module/address_module.dart';
import 'package:address_module/domain/entity/suggestion.dart';
import 'package:address_module/presentation/widgets/select_country_field.dart';
import 'package:flutter/material.dart';
import 'package:mule_common/mule_common.dart';
import 'package:mule_widgets/mule_widgets.dart';

import 'address_auto_complete.dart';

class AddressForm extends StatefulWidget {
  const AddressForm({
    Key? key,
    this.initialPostcode,
    required this.initialCountry,
    this.initialAddress,
    this.initialCity,
    this.initialName,
    this.initialPhoneNumber,
    this.initialSpecifyingInfo,
    this.initialEmailAddress,
    this.initialCompanyName,
    required this.onSaved,
    this.countryFieldHelperText,
    this.countryEnabled = true,
    this.onChanged,
  }) : super(key: key);

  final String? initialPostcode;
  final CountryEntity initialCountry;
  final String? initialAddress;
  final String? initialCity;
  final String? initialName;
  final String? initialPhoneNumber;
  final String? initialSpecifyingInfo;
  final String? initialEmailAddress;
  final String? initialCompanyName;

  final bool countryEnabled;
  final String? countryFieldHelperText;

  final void Function(String name, dynamic value) onSaved;

  final CountryOrPostcodeChanged? onChanged;

  @override
  State<AddressForm> createState() => _AddressFormState();
}

class _AddressFormState extends State<AddressForm> {
  bool expand = false;
  bool addAddressManualy = false;

  CountryEntity? country;
  String? postcode;

  late final TextEditingController addressController = TextEditingController(
    text: widget.initialAddress,
  );

  late final TextEditingController cityController = TextEditingController(
    text: widget.initialCity,
  );

  late final TextEditingController postcodeController = TextEditingController(
    text: widget.initialPostcode,
  );

  late final TextEditingController specifyingInfoController =
      TextEditingController(
    text: widget.initialSpecifyingInfo,
  );

  @override
  void initState() {
    country = widget.initialCountry;
    if (widget.initialCity != null ||
        widget.initialAddress != null ||
        widget.initialCompanyName != null ||
        widget.initialPhoneNumber != null ||
        widget.initialEmailAddress != null ||
        widget.initialName != null ||
        widget.initialSpecifyingInfo != null) {
      expand = true;
    }

    super.initState();
  }

  @override
  void dispose() {
    addressController.dispose();
    cityController.dispose();
    specifyingInfoController.dispose();
    postcodeController.dispose();
    super.dispose();
  }

  Future<void> onChangedPostcodeManually(String postcode) async {
    widget.onChanged?.call(country, postcode);
  }

  Future<void> onChangedPostcode(SuggestionEntity? suggestionEntity) async {
    postcode = suggestionEntity?.postcode;
    widget.onChanged?.call(country, postcode);

    if (suggestionEntity != null && suggestionEntity.hasDetails) {
      expand = true;
      postcodeController.text = suggestionEntity.postcode ?? '';
      addressController.text = suggestionEntity.formattedAddress;
      cityController.text =
          suggestionEntity.city ?? suggestionEntity.district ?? '';
      specifyingInfoController.text = suggestionEntity.buildingNumber ??
          suggestionEntity.subBuildingName ??
          '';

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final autocomplete = FocusTraversalOrder(
      order: const NumericFocusOrder(0),
      child: AddressAutoComplete(
        onSuggestionSelected: onChangedPostcode,
        country: country,
        validator: (v) {
          if (country == null) {
            return 'Please first fill in the country';
          }

          if (expand == false && addAddressManualy == false) {
            return 'Please select ${country!.isDomestic() ? 'a postcode' : 'an address'} or fill information manually';
          }

          return null;
        },
      ),
    );

    final countryInput = FocusTraversalOrder(
      order: const NumericFocusOrder(1),
      child: SelectCountryField(
        lableText: 'Country',
        onChanged: (country) {
          widget.onChanged?.call(country, postcode);
        },
        onSaved: (v) {
          widget.onSaved('country', v);
        },
        onSelected: (c) {
          country = c;
          setState(() {});
        },
        validator: (v) {
          if (v == null) {
            return 'Country is required';
          }

          return null;
        },
        helperMaxLines: widget.countryFieldHelperText == null ? null : 2,
        initialValue: widget.initialCountry,
        enabled: widget.countryEnabled,
        helperText: widget.countryFieldHelperText,
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ResponsiveContainer(
          desktop: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(child: autocomplete),
              const SizedBox(width: 32),
              Flexible(child: countryInput),
            ],
          ),
          mobile: Column(
            children: [
              autocomplete,
              const SizedBox(height: 32),
              countryInput,
            ],
          ),
        ),
        const SizedBox(height: 32),
        if (expand || addAddressManualy)
          buildManualAddressForm()
        else
          MuleTextButton(
            onPress: () {
              addAddressManualy = true;
              setState(() {});
            },
            text: 'Add address manually',
            icon: const Icon(
              Icons.add,
              color: Colors.white,
              size: 18,
            ),
          ),
      ],
    );
  }

  Widget buildManualAddressForm() {
    var addressInput = FocusTraversalOrder(
      order: const NumericFocusOrder(2),
      child: MuleInput(
        controller: addressController,
        labelText: 'Address',
        onSaved: (v) => widget.onSaved('address', v),
        maxLength: 105,
        validator: MuleFormValidators().required().maxLength(105).build(),
      ),
    );
    var cityInput = FocusTraversalOrder(
      order: const NumericFocusOrder(3),
      child: MuleInput(
        controller: cityController,
        labelText: 'City',
        maxLength: 50,
        validator: MuleFormValidators().required().maxLength(50).build(),
        onSaved: (v) => widget.onSaved('city', v),
      ),
    );
    final postcodeInput = FocusTraversalOrder(
      order: const NumericFocusOrder(4),
      child: MuleInput(
        controller: postcodeController,
        labelText:
            country?.isDomestic() ?? false ? 'Postcode' : 'Postcode / zip code',
        validator: MuleFormValidators().required().build(),
        maxLength: 30,
        onSaved: (v) => widget.onSaved('postcode', v),
      ),
    );

    var specifyingInfoInput = FocusTraversalOrder(
      order: const NumericFocusOrder(5),
      child: MuleInput(
        controller: specifyingInfoController,
        maxLength: 30,
        labelText: 'Flat, suite, floor (optional)',
        onSaved: (v) => widget.onSaved('specifyingInfo', v),
        validator: MuleFormValidators().maxLength(30).build(),
      ),
    );

    var nameInput = FocusTraversalOrder(
      order: const NumericFocusOrder(6),
      child: MuleInput(
        labelText: 'Name',
        initialValue: widget.initialName,
        maxLength: 70,
        validator: MuleFormValidators().required().maxLength(70).build(),
        onSaved: (v) => widget.onSaved('name', v),
      ),
    );
    var emailAddressInput = FocusTraversalOrder(
      order: const NumericFocusOrder(7),
      child: MuleInput(
        labelText: 'Email address',
        maxLength: 100,
        initialValue: widget.initialEmailAddress,
        onSaved: (v) => widget.onSaved('email', v),
        validator: MuleFormValidators().email().required().build(),
      ),
    );
    var companyNameInput = FocusTraversalOrder(
      order: const NumericFocusOrder(8),
      child: MuleInput(
        labelText: 'Company name(optional)',
        maxLength: 100,
        initialValue: widget.initialCompanyName,
        onSaved: (v) => widget.onSaved('companyName', v),
        validator: MuleFormValidators().maxLength(100).build(),
      ),
    );
    var phoneNumberInput = FocusTraversalOrder(
      order: const NumericFocusOrder(9),
      child: MuleInput(
        labelText: 'Phone number',
        maxLength: 15,
        initialValue: widget.initialPhoneNumber,
        onSaved: (v) => widget.onSaved('phoneNumber', v),
        validator: MuleFormValidators().required().maxLength(15).build(),
      ),
    );
    return ResponsiveContainer(
      mobile: Column(
        children: [
          addressInput,
          const SizedBox(height: 24),
          nameInput,
          const SizedBox(height: 24),
          postcodeInput,
          const SizedBox(height: 24),
          specifyingInfoInput,
          const SizedBox(height: 24),
          companyNameInput,
          const SizedBox(height: 24),
          cityInput,
          const SizedBox(height: 24),
          phoneNumberInput,
          const SizedBox(height: 24),
          emailAddressInput,
        ],
      ),
      desktop: Column(
        children: [
          Row(
            children: [
              Flexible(
                child: addressInput,
              ),
              const SizedBox(width: 32),
              Flexible(
                child: cityInput,
              ),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Flexible(
                child: postcodeInput,
              ),
              const SizedBox(width: 32),
              Flexible(
                child: specifyingInfoInput,
              ),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Flexible(
                child: nameInput,
              ),
              const SizedBox(width: 32),
              Flexible(
                child: emailAddressInput,
              ),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Flexible(
                child: companyNameInput,
              ),
              const SizedBox(width: 32),
              Flexible(
                child: phoneNumberInput,
              ),
            ],
          )
        ],
      ),
    );
  }
}

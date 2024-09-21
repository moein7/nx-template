import 'package:address_module/address_module.dart';
import 'package:flutter/material.dart';
import 'package:mule_common/mule_common.dart';
import 'package:mule_theme/mule_theme.dart';
import 'package:mule_widgets/mule_widgets.dart';

class DefaultAddressForm extends StatefulWidget {
  const DefaultAddressForm({
    Key? key,
    this.postcode,
    this.address,
    this.city,
    this.specifyingInfo,
    required this.onSaved,
    this.countryFieldHelperText,
    required this.onTapSubmit,
  }) : super(key: key);

  final String? postcode;
  final String? address;
  final String? city;
  final String? specifyingInfo;
  final String? countryFieldHelperText;

  final void Function(String name, dynamic value) onSaved;
  final void Function(BuildContext context) onTapSubmit;

  @override
  State<DefaultAddressForm> createState() => _DefaultAddressFormState();
}

class _DefaultAddressFormState extends State<DefaultAddressForm> {
  bool expand = false;
  bool addAddressManualy = false;

  CountryEntity? country;
  String? postcode;

  late final TextEditingController addressController = TextEditingController(
    text: widget.address,
  );

  late final TextEditingController cityController = TextEditingController(
    text: widget.city,
  );

  late final TextEditingController postcodeController = TextEditingController(
    text: widget.postcode,
  );

  late final TextEditingController specifyingInfoController =
      TextEditingController(
    text: widget.specifyingInfo,
  );

  @override
  void initState() {
    if (widget.city != null ||
        widget.address != null ||
        widget.postcode != null ||
        widget.specifyingInfo != null) {
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ResponsiveContainer(
          desktop: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(child: buildManualAddressForm()),
            ],
          ),
          mobile: Column(
            children: [buildManualAddressForm()],
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
        labelText: 'Street',
        onSaved: (v) => widget.onSaved('address', v),
        maxLength: 105,
        validator: MuleFormValidators().required().maxLength(105).build(),
      ),
    );
    var cityInput = FocusTraversalOrder(
      order: const NumericFocusOrder(3),
      child: MuleInput(
        controller: cityController,
        labelText: 'City / Town',
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
        labelText: 'Flat, Floor, etc (optional)',
        onSaved: (v) => widget.onSaved('specifyingInfo', v),
        validator: MuleFormValidators().maxLength(30).build(),
      ),
    );

    return ResponsiveContainer(
      mobile: Column(
        children: [
          addressInput,
          const SizedBox(height: 24),
          specifyingInfoInput,
          const SizedBox(height: 24),
          postcodeInput,
          const SizedBox(height: 24),
          cityInput,
          const SizedBox(height: 24),
          TextField(
            style: MuleAppTheme.of(context)
                .typography
                .bodyMedium
                .copyWith(color: MuleAppTheme.of(context).colors.textSecondary),
            decoration: InputDecoration(
              border: InputBorder.none,
              helperMaxLines: 2,
              helperStyle: MuleAppTheme.of(context)
                  .typography
                  .bodySmall
                  .copyWith(color: MuleAppTheme.of(context).colors.placeholder),
              helperText: widget.countryFieldHelperText,
            ),
          ),
          const SizedBox(height: 54),
          MulePrimaryButton(
            onPress: () => widget.onTapSubmit(context),
            text: 'Save Changes',
          ),
        ],
      ),
      desktop: Column(
        children: [
          Row(
            children: [
              Flexible(
                child: addressInput,
              ),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Flexible(
                child: specifyingInfoInput,
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
                child: cityInput,
              ),
            ],
          ),
          Row(
            children: [
              Flexible(
                child: TextField(
                  style: MuleAppTheme.of(context)
                      .typography
                      .bodyMedium
                      .copyWith(
                          color: MuleAppTheme.of(context).colors.textSecondary),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    helperMaxLines: 2,
                    helperStyle: MuleAppTheme.of(context)
                        .typography
                        .bodySmall
                        .copyWith(
                            color: MuleAppTheme.of(context).colors.placeholder),
                    helperText: widget.countryFieldHelperText,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 64),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              MulePrimaryButton(
                onPress: () => widget.onTapSubmit(context),
                text: 'Save Changes',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

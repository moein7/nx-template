import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:mule_theme/mule_theme.dart';
import 'package:mule_widgets/mule_widgets.dart';

import 'package:address_module/application/address_service.dart';
import 'package:address_module/domain/entity/address.dart';
import 'package:address_module/domain/entity/country.dart';
import 'package:address_module/domain/entity/suggestion.dart';

class AddressAutoComplete extends StatelessWidget {
  const AddressAutoComplete({
    Key? key,
    this.onSaved,
    this.initialValue,
    required this.country,
    this.fieldInitialValue,
    required this.onSuggestionSelected,
    required this.validator,
    this.textFieldValidator,
    this.controller,
  }) : super(key: key);

  final TextEditingController? controller;
  final FormFieldSetter<String>? onSaved;
  final String? initialValue;
  final CountryEntity? country;
  final AddressEntity? fieldInitialValue;
  final ValueChanged<SuggestionEntity?> onSuggestionSelected;
  final FormFieldValidator<SuggestionEntity> validator;
  final FormFieldValidator<String>? textFieldValidator;

  Future<void> onTap(
      BuildContext context, FormFieldState<SuggestionEntity> field) async {
    if (country == null) {
      MuleSnackbar.show(
        context: context,
        message: 'Please select a country',
        labelType: LabelType.error,
      );
      return;
    }

    final value = await showSearchBottomSheet<SuggestionEntity>(
      context: context,
      noResultMessage: 'No results',
      itemBuilder: (context, value) {
        return ListTile(
          leading: const Icon(Icons.search),
          title: Text(
            value.formattedAddress,
            style: MuleAppTheme.of(context).typography.labelSmall,
          ),
          onTap: () {
            Navigator.pop(context, value);
          },
        );
      },
      suggestionCallback: getSuggestions,
    );

    onChangedSuggestion(value as SuggestionEntity, field);
  }

  Future<List<SuggestionEntity>> getSuggestions(String? pattern) async {
    if (country != null) {
      if (country!.isDomestic()) {
        if ((pattern?.length ?? 0) > 4) {
          return GetIt.I
              .get<AddressService>()
              .searchForAddress(pattern, country!);
        } else {
          return Future.delayed(const Duration(seconds: 100), (() => []));
        }
      } else {
        return GetIt.I
            .get<AddressService>()
            .searchForAddress(pattern, country!);
      }
    }

    return [];
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveContainer(
      desktop: MuleInputAutoComplete<SuggestionEntity>(
        controller: controller,
        labelText: country?.isDomestic() ?? false
            ? 'Postcode search'
            : 'Postcode or address search',
        initialValue: initialValue,
        onSuggestionSelected: onChangedSuggestion,
        getSuggestions: getSuggestions,
        validator: validator,
        noResultMessage: 'No results',
        textFieldOnSaved: onSaved,
        textFieldValidator: textFieldValidator,
      ),
      mobile: Row(
        children: [
          Expanded(
            child: FormField<SuggestionEntity>(
              onSaved: (v) => onSaved?.call(v?.postcode),
              validator: validator,
              builder: (field) {
                return MuleMobileSecondaryButton(
                  onPress: () => onTap(context, field),
                  icon: SvgPicture.asset(
                    'assets/icons/search.svg',
                    package: 'address_module',
                  ),
                  iconDirection: TextDirection.ltr,
                  text: 'Search for a postcode or address',
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> onChangedSuggestion(SuggestionEntity? value,
      [FormFieldState? field]) async {
    if (value != null) {
      if (value.hasDetails) {
        onSuggestionSelected(value);
        if (field != null) {
          field.didChange(value);
        }
      } else {
        final details =
            await GetIt.I.get<AddressService>().getSuggestionDetails(value);

        onSuggestionSelected(details);

        if (field != null) {
          field.didChange(details);
        }
      }
    }
  }
}

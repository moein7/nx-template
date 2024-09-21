import 'package:address_module/application/address_service.dart';
import 'package:address_module/domain/entity/country.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mule_widgets/input/mule_input_auto_complete.dart';

class SelectCountryField extends StatefulWidget {
  const SelectCountryField({
    Key? key,
    this.textController,
    this.initialValue,
    this.validator,
    this.enabled = true,
    this.lableText,
    this.labelText,
    this.helperText,
    this.onSaved,
    this.onSelected,
    this.onChanged,
    this.helperMaxLines,
    this.inputDecoration,
    this.prefix,
    this.prefixIcon,
    this.prefixIconConstraints,
    this.excludedAlphaCodes,
    this.excludedCodes,
  }) : super(key: key);

  final TextEditingController? textController;
  final CountryEntity? initialValue;
  final FormFieldValidator<CountryEntity>? validator;
  final bool enabled;
  @Deprecated('Use `labelText` instead')
  final String? lableText;
  final String? labelText;
  final String? helperText;
  final int? helperMaxLines;
  final FormFieldSetter<CountryEntity>? onSaved;
  final void Function(CountryEntity value)? onSelected;
  final ValueChanged<CountryEntity?>? onChanged;
  final InputDecoration? inputDecoration;
  final Widget? prefix;
  final Widget? prefixIcon;
  final BoxConstraints? prefixIconConstraints;
  final List<String>? excludedAlphaCodes;
  final List<String>? excludedCodes;
  //TODO : support sufixIconConstraints
  @override
  State<SelectCountryField> createState() => _SelectCountryFieldState();
}

class _SelectCountryFieldState extends State<SelectCountryField> {
  final List<CountryEntity> countries = List.empty(growable: true);

  late final TextEditingController textController;

  @override
  void initState() {
    init();
    textController = widget.textController ?? TextEditingController();
    super.initState();
  }

  Future<void> init() async {
    countries.clear();

    final _countries = await GetIt.I.get<AddressService>().getCountries();

    if (widget.excludedAlphaCodes != null &&
        widget.excludedAlphaCodes!.isNotEmpty) {
      _countries.removeWhere(
        (e) => widget.excludedAlphaCodes!.contains(e.alpha2Code),
      );
    }

    if (widget.excludedCodes != null && widget.excludedCodes!.isNotEmpty) {
      _countries.removeWhere(
        (e) => widget.excludedCodes!.contains(e.code),
      );
    }

    countries.addAll(_countries);
  }

  @override
  void dispose() {
    if (widget.textController == null) {
      textController.dispose();
    }

    super.dispose();
  }

  Future<List<CountryEntity>> getCountries(String? pattern) async {
    if (pattern == null) {
      return countries;
    }
    /* we want to have a more meaningful, more intelligent search strategy in
    the getCountry field, the sceniario is as follow:
        - given a pattern we want to have the countries who's code
        matches the pattern show above the rest
        - for example when entering `ge`, Georiga (GE) should be first followed
        by Algeria (DZ), Germany (DE), Nigeria (NE) and etc */
    final codeMatches = countries
        .where((element) =>
            element.code.toLowerCase() == pattern.trim().toLowerCase())
        .toList();
    final nameMatches = countries
        .where((element) =>
            element.name.toLowerCase().contains(pattern.toLowerCase()))
        .toList();

    return [...codeMatches, ...nameMatches];
  }

  void onSuggestionSelected(CountryEntity country) {
    textController.text = country.toString();
    widget.onSelected?.call(country);
    widget.onChanged?.call(country);
  }

  @override
  Widget build(BuildContext context) {
    return MuleInputAutoComplete<CountryEntity>(
      controller: textController,
      labelText: widget.labelText ?? widget.lableText,
      validator: widget.validator,
      initialValue: widget.initialValue?.toString(),
      fieldInitialValue: widget.initialValue,
      onSaved: widget.onSaved,
      enabled: widget.enabled,
      helperText: widget.helperText,
      getSuggestions: getCountries,
      noResultMessage: 'No countries found',
      onSuggestionSelected: onSuggestionSelected,
      helperMaxLines: widget.helperMaxLines,
      inputDecoration: widget.inputDecoration,
      prefix: widget.prefix,
      prefixIcon: widget.prefixIcon,
      prefixIconConstraints: widget.prefixIconConstraints,
    );
  }
}

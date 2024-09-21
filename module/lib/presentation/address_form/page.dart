import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mule_theme/mule_theme.dart';
import 'package:mule_widgets/mule_widgets.dart';
import 'package:provider/provider.dart';

import 'package:address_module/domain/entity/address.dart';
import 'package:address_module/domain/entity/country.dart';

import 'controller.dart';
import 'widgets/address_form.dart';

typedef CountryOrPostcodeChanged = void Function(
    CountryEntity? country, String? postcode);

class AddressFormPage extends StatefulWidget {
  const AddressFormPage({
    Key? key,
    this.initialSender,
    this.initialRecipient,
    this.onSenderChanged,
    this.onRecipientChanged,
  }) : super(key: key);

  final AddressEntity? initialSender;
  final AddressEntity? initialRecipient;
  final CountryOrPostcodeChanged? onSenderChanged;
  final CountryOrPostcodeChanged? onRecipientChanged;

  @override
  State<AddressFormPage> createState() => AddressFormPageState();
}

class AddressFormPageState extends State<AddressFormPage> {
  late AddressFormController controller;

  Map<String, dynamic>? validateAndSave() {
    return controller.validateAndSave();
  }

  Map<String, dynamic>? save() {
    return controller.saveForm();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        controller = AddressFormController(
          service: GetIt.I.get(),
        );

        Future.microtask(controller.loadData);

        return controller;
      },
      builder: (context, child) {
        controller = context.read();

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: controller.formKey,
            child: FocusTraversalGroup(
              policy: OrderedTraversalPolicy(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ResponsiveContainer(
                    desktop: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: buildSenderForm(context),
                        ),
                        const SizedBox(width: 32),
                        Flexible(
                          child: buildRecipientForm(context),
                        ),
                      ],
                    ),
                    mobile: Column(
                      children: [
                        buildSenderForm(
                          context,
                        ),
                        const SizedBox(height: 32),
                        buildRecipientForm(
                          context,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  BaseSection buildRecipientForm(BuildContext context) {
    final AddressFormController controller = context.read();

    return BaseSection(
      title: 'Recipient details',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FocusTraversalGroup(
            policy: OrderedTraversalPolicy(),
            child: AddressForm(
              initialAddress: widget.initialRecipient?.address,
              initialPostcode: widget.initialRecipient?.postcode,
              initialCity: widget.initialRecipient?.city,
              initialCompanyName: widget.initialRecipient?.companyName,
              initialEmailAddress: widget.initialRecipient?.email,
              initialName: widget.initialRecipient?.name,
              initialPhoneNumber: widget.initialRecipient?.phoneNumber,
              initialSpecifyingInfo: widget.initialRecipient?.specifyingInfo,
              initialCountry: widget.initialRecipient?.country ??
                  const CountryEntity(code: 'GB', name: 'UK Mainland'),
              onSaved: (name, value) => controller.saveField(
                'recipient${name.toCapitalized()}',
                value,
              ),
              onChanged: widget.onRecipientChanged,
            ),
          )
        ],
      ),
    );
  }

  BaseSection buildSenderForm(
    BuildContext context,
  ) {
    final AddressFormController controller = context.read();

    return BaseSection(
      title: 'Sender details',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: controller.showGoToLogin,
            child: Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: MuleAppTheme.of(context).colors.background,
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.centerLeft,
              child: Text.rich(
                TextSpan(
                  children: [
                    const WidgetSpan(
                      child: Icon(
                        Icons.info_outline,
                        size: 16,
                      ),
                    ),
                    const WidgetSpan(
                      child: SizedBox(
                        width: 10,
                      ),
                    ),
                    TextSpan(
                      text: 'Log in',
                      style: MuleAppTheme.of(context)
                          .typography
                          .labelSmall
                          .copyWith(
                            color: MuleAppTheme.of(context).colors.primary,
                          ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = controller.onTapLogin,
                    ),
                    TextSpan(
                      text: ' ',
                      style: MuleAppTheme.of(context).typography.labelSmall,
                    ),
                    TextSpan(
                      text: context.isMobile
                          ? 'for information to be pre-filled.'
                          : 'to have information about the sender already filled.',
                      style: MuleAppTheme.of(context).typography.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Consumer<AddressFormController>(
            builder: (context, controller, child) {
              return controller.buildState(
                onLoaded: (data, message) {
                  return FocusTraversalGroup(
                    policy: OrderedTraversalPolicy(),
                    child: AddressForm(
                      initialCountry: widget.initialSender?.country ??
                          const CountryEntity(code: 'GB', name: 'UK Mainland'),
                      countryFieldHelperText:
                          'At the moment it is only possible to send parcels from GB',
                      countryEnabled: false,
                      onChanged: widget.onSenderChanged,
                      onSaved: (name, value) => controller.saveField(
                        'sender${name.toCapitalized()}',
                        value,
                      ),
                      initialAddress:
                          widget.initialSender?.address ?? data?.address,
                      initialCompanyName: widget.initialSender?.companyName ??
                          data?.companyName,
                      initialName: widget.initialSender?.name ?? data?.name,
                      initialEmailAddress:
                          widget.initialSender?.email ?? data?.email,
                      initialPhoneNumber: widget.initialSender?.phoneNumber ??
                          data?.phoneNumber,
                      initialSpecifyingInfo:
                          widget.initialSender?.specifyingInfo ??
                              data?.specifyingInfo,
                      initialPostcode:
                          widget.initialSender?.postcode ?? data?.postcode,
                      initialCity: widget.initialSender?.city ?? data?.city,
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1)}' : '';
}

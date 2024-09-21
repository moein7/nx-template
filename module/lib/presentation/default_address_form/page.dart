import 'package:address_module/presentation/default_address_form/widgets/default_address_form.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mule_widgets/mule_widgets.dart';
import 'package:provider/provider.dart';

import 'controller.dart';

class DefaultAddressFormPage extends StatelessWidget {
  const DefaultAddressFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final controller = DefaultAddressFormController(
          service: GetIt.I.get(),
        );
        Future.microtask(controller.loadData);
        return controller;
      },
      builder: (context, child) {
        final DefaultAddressFormController controller = context.read();

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: controller.formKey,
            child: FocusTraversalGroup(
              policy: OrderedTraversalPolicy(),
              child: ResponsiveContainer(
                desktop: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: buildDefaultAddressForm(context),
                    ),
                  ],
                ),
                mobile: Column(
                  children: [
                    const SizedBox(height: 32),
                    buildDefaultAddressForm(
                      context,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  BaseSection buildDefaultAddressForm(
    BuildContext context,
  ) {
    return BaseSection(
      title: 'Default Sender Address',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Consumer<DefaultAddressFormController>(
            builder: (context, controller, child) {
              return controller.buildState(
                onLoaded: (data, message) {
                  return DefaultAddressForm(
                    onTapSubmit: (context) async {
                      controller.submit(context);
                    },
                    countryFieldHelperText:
                        'At the moment it is only possible to send parcels from the United Kingdom.',
                    onSaved: (name, value) => controller.saveField(
                      'sender${name.toCapitalized()}',
                      value,
                    ),
                    address: data?.address,
                    specifyingInfo: data?.specifyingInfo,
                    postcode: data?.postcode,
                    city: data?.city,
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

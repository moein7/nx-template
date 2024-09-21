import 'dart:developer';

import 'package:auth_module/auth_module.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mule_common/mule_common.dart';
import 'package:mule_widgets/mule_widgets.dart';

class ErrorHandler {
  ErrorHandler(this.navigatorKey);

  final GlobalKey<NavigatorState> navigatorKey;

  bool handleError(dynamic error, StackTrace? stackTrace) {
    log(error.toString(), name: 'ERROR_HANDLER: ${error.runtimeType}');

    if (error is FlutterErrorDetails) {
      FlutterError.presentError(error);

      // TODO: Pass all uncaught errors from the framework to Crashlytics.
      // FirebaseCrashlytics.instance.recordFlutterFatalError(error);
      // FirebaseCrashlytics.instance.recordFlutterError(error);

    } else if (error is InternalException) {
      // TODO: Send error to firebase
      // FirebaseCrashlytics.instance.recordError(error, stackTrace);

      // Shows the error in a snackbar to users
      MuleSnackbar.show(
        context: navigatorKey.currentContext!,
        message: error.message,
        labelType: LabelType.error,
      );
    } else if (error is UnauthorizedException) {
      Navigator.of(navigatorKey.currentContext!)
          .pushNamed(GetIt.I.get<Auth>().initialRoute);
    }

    // Send logs to Cloudwatch
    // MuleLogger().error('[$error]: $stackTrace');

    // FirebaseCrashlytics.instance.recordError(error, stackTrace);

    return true;
  }
}

import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import 'app.dart';
import 'core/background_task/background_tasks_manager.dart';
import 'core/common/app_config.dart';
import 'core/common/local_storage.dart';
import 'core/constants/app/app_constants.dart';
import 'core/constants/app/app_settings.dart';
import 'core/constants/enums/app_options_enum.dart';
import 'core/dynamic_link/branch_io_dynamic_link.dart';
import 'core/errors/error_global_handler/catcher_handler.dart';
import 'core/errors/error_global_handler/email_manual_handler.dart';
import 'core/errors/error_global_handler/report.dart';
import 'core/firebase/firebase_messaging.dart';
import 'core/localization/localization_provider.dart';
import 'core/navigation/navigation_service.dart';
import 'core/net/http_overrides.dart';
import 'core/ui/error_ui/errors_screens/build_error_screen.dart';
import 'di/service_locator.dart';
import 'firebase_options.dart';
import 'generated/l10n.dart';
import 'services/api.dart';

void main() async {
  await _initAppConfigs();

  runApp(const App());

 
  AppConfig.clearNotificationSystemCount();
}

Future<void> _initAppConfigs() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorage.init();
  if (AppSettings.enableBranchIO) {
    BranchIODynamicLink.init();
  }

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  SystemChrome.setSystemUIChangeCallback(
    (systemOverlaysAreVisible) async {
      if (!systemOverlaysAreVisible)
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    },
  );

  /// Injectable initialization
  await configureInjection();

  /// Init Language.
  await LocalizationProvider().fetchLocale();

  /// Init app config
  await AppConfig().initApp();

  /// Init rotation of app (Should be called after [AppConfig.initApp()])
  await _initAppRotation();

  /// Init error catcher to catch any red screen error and add ability to send
  /// a report to developer e-mail
  _initErrorCatcher();

  /// In case of network handshake error
  HttpOverrides.global = new BadCertHttpOverrides();

  if (AppSettings.enableNotifications) {
    await FireBaseMessagingWrapper.notificationLock.acquire();

    /// Init firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    /// Init firebase messaging
    await FireBaseMessagingWrapper().init(onRefreshToken: () async {
      getIt<Api>().addOrUpdateFirebaseToken(
        FireBaseMessagingWrapper.getUpdateTokenParam(),
      );
    });

    if (!await LocalStorage.hasToken)
      await FireBaseMessagingWrapper().deleteFirebaseToken();
  }

  await BackgroundTasksManager.init();
}

Future<void> _initAppRotation() async {
  switch (AppSettings.orientation) {
    case OrientationOptions.PORTRAIT:
      await SystemChrome.setPreferredOrientations(
        [
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ],
      );
      break;
    case OrientationOptions.LANDSCAPE:
      await SystemChrome.setPreferredOrientations(
        [
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ],
      );
      break;
    case OrientationOptions.BOTH:
      await SystemChrome.setPreferredOrientations(
        [
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ],
      );
      break;
  }
}

void _initErrorCatcher() {
  if (AppSettings.enableErrorCatcher) {
    /// Initialize the error screen with our custom error catcher
    ErrorWidget.builder = (flutterErrorDetails) {
      final _catcherHandler = CatcherHandler();

      /// We must init the catcher handler parameters
      _catcherHandler.init();

      final context = getIt<NavigationService>().appContext!;

      return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(140)),
          child: Center(
            child: FittedBox(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  buildErrorScreen(
                    disableRetryButton: true,
                    title: S.current.errorOccurred,
                    content: S.current.reportError,
                    imageUrl: AppConstants.ERROR_UNKNOWING,
                    callback: null,
                    context: context,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      S.current.send,
                      style: const TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Report? report = _catcherHandler.createReport(
                          flutterErrorDetails.exception,
                          flutterErrorDetails.stack,
                          errorDetails: flutterErrorDetails);
                      if (report != null) {
                        EmailManualHandler(
                          ["info@osoustech.com"],
                          emailHeader: 'StarterApp',
                          emailTitle:
                              'Error report ${DateFormat("").format(DateTime.now())}',
                        ).handle(report);
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      );
    };
  }
}

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:statusbarz/statusbarz.dart';

import 'core/common/app_config.dart';
import 'core/common/provider_list.dart';
import 'core/constants/app/app_constants.dart';
import 'core/localization/flutter_localization.dart';
import 'core/localization/global_widgets_with_kurdish_localization_delegate.dart';
import 'core/localization/kurdish/flutter_kurdish_localization.dart';
import 'core/navigation/navigation_service.dart';
import 'core/navigation/route_generator.dart';
import 'core/ui/error_ui/error_widgets/global_error_widget.dart';
import 'core/ui/widgets/restart_widget.dart';
import 'di/service_locator.dart';
import 'features/splash/view/splash_view.dart';
import 'generated/l10n.dart';

class App extends StatefulWidget {
  const App({
    Key? key,
  }) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    // TODO: figure out how to get this to work
    // Location.instance.onLocationChanged.listen((event) async {
    //   if (event == ServiceStatus.disabled) {
    //     await LocationWrapper.singleton().hasLocationPermissionLogic(
    //       showDialog: () async => await ShowDialog().showElasticDialog(
    //         context: AppConfig().appContext!,
    //         barrierDismissible: false,
    //         builder: (context) => const PermissionAlertDialog(),
    //       ),
    //     );
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return RestartWidget(
      child: ScreenUtilInit(
        designSize: AppConfig.screenUtilDesignSize(),
        builder: (context, _) {
          return MultiProvider(
            providers: [...ApplicationProvider().dependItems],
            child: Consumer<LocalizationProvider>(
              builder: (_, provider, __) {
                return ThemeProvider(
                  initTheme: AppConfig().themeData,
                  builder: (_, theme) {
                    return RefreshConfiguration(
                      headerBuilder: () => MaterialClassicHeader(
                        color: theme.colorScheme.primary,
                        backgroundColor: Colors.white,
                        distance: 15,
                        height: 20,
                      ),
                      child: StatusbarzCapturer(
                        child: MaterialApp(
                          scrollBehavior:
                              ScrollConfiguration.of(context).copyWith(
                            physics: const ClampingScrollPhysics(),
                          ),
                          debugShowCheckedModeBanner: false,
                          title: AppConstants.TITLE_APP_NAME,

                          /// Routing
                          navigatorKey:
                              getIt<NavigationService>().getNavigationKey,
                          onGenerateRoute:
                              getIt<NavigationRoute>().generateRoute,
                          initialRoute: "/",

                          navigatorObservers: [Statusbarz.instance.observer],

                          /// Setup app localization
                          supportedLocales: S.delegate.supportedLocales,
                          locale: provider.appLocal,

                          localizationsDelegates: [
                            S.delegate,
                            KurdishMaterialLocalizations.delegate,
                            KurdishCupertinoLocalizations.delegate,

                            // Built-in localization of basic text for Material widgets
                            GlobalMaterialLocalizations.delegate,
                            // Built-in localization for text direction LTR/RTL
                            GlobalWidgetsWithKurdishLocalizations.delegate,
                            GlobalCupertinoLocalizations.delegate,
                            DefaultCupertinoLocalizations.delegate,
                          ],

                          /// Run app at first time on device language
                          localeResolutionCallback: (locale, supportedLocales) {
                            if (provider.firstStart) {
                              /// Check if the current device locale is supported
                              for (var supportedLocale in supportedLocales) {
                                if (supportedLocale.languageCode ==
                                    locale!.languageCode) {
                                  /// Set _firstStart false
                                  provider.firstStartOff();

                                  /// Change language
                                  provider.changeLanguage(
                                    Locale(locale.languageCode),
                                    context,
                                  );
                                  return supportedLocale;
                                }
                              }

                              /// If the locale of the device is not supported, use the first one
                              /// from the list (English, in this case).
                              provider.changeLanguage(
                                supportedLocales.first,
                                context,
                              );
                              return supportedLocales.first;
                            } else
                              return null;
                          },

                          /// Theming
                          theme: theme,
                          themeMode: theme.brightness == Brightness.light
                              ? ThemeMode.light
                              : ThemeMode.dark,

                          /// Init screen
                          home: SplashView(param: SplashViewParam()),

                          // builder: DevicePreview.appBuilder,

                          builder: (context, widget) {
                            // return DevicePreview.appBuilder(context, widget!);
                            _handleGlobalError(widget);

                            return MediaQuery(
                              //Setting font does not change with system font size
                              data: MediaQuery.of(context)
                                  .copyWith(textScaler: TextScaler.noScaling),
                              child: widget!,
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _handleGlobalError(Widget? widget) {
    ErrorWidget.builder = (errorDetails) {
      return (widget is Scaffold || widget is Navigator)
          ? Scaffold(
              body: Center(
                child: GlobalErrorWidget(flutterErrorDetails: errorDetails),
              ),
            )
          : GlobalErrorWidget(flutterErrorDetails: errorDetails);
    };
  }

  @override
  void dispose() {
    ApplicationProvider().dispose(context);
    super.dispose();
  }
}

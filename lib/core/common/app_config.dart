import 'dart:io';

import 'package:eraser/eraser.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:unique_identifier/unique_identifier.dart';

import '../../di/service_locator.dart';
import '../constants/enums/system_type.dart';
import '../localization/localization_provider.dart';
import '../navigation/navigation_service.dart';
import '../theme/themes_data.dart';
import 'local_storage.dart';

/// This class it contain multiple core functions
/// for get device info
/// for get and set language
/// for current app theme
/// for options in application
class AppConfig {
  static final AppConfig _instance = AppConfig._internal();

  factory AppConfig() {
    return _instance;
  }

  AppConfig._internal();

  final String apiKey = "";
  SystemType? _os;
  String? _currentVersion;
  late String _buildNumber;
  String? _appName;
  String? _appVersion;
  ThemeMode _themeMode = ThemeMode.light;

  BuildContext? get appContext => getIt<NavigationService>().appContext;

  Locale get appLanguage => LocalizationProvider().appLocal;

  SystemType? get os => _os;

  String? get currentVersion => _currentVersion;

  String get buildNumber => _buildNumber;

  String? get appVersion => _appVersion;

  String? get appName => _appName;

  ThemeData get themeData => _themeMode == ThemeMode.light
      ? ThemesData.lightTheme
      : ThemesData.darkTheme;

  ThemeMode get themeMode => _themeMode;
  set themeMode(ThemeMode v) {
    _themeMode = v;
  }

  String? deviceId;

  Future<String?> _getDeviceId() async {
    return await UniqueIdentifier.serial;
  }

  initApp() async {
    /// get OS
    if (Platform.isIOS) {
      _os = SystemType.IOS;
    }
    if (Platform.isAndroid) {
      _os = SystemType.Android;
    }

    /// get version
    final packageInfo = await PackageInfo.fromPlatform();
    _currentVersion = packageInfo.version;
    _buildNumber = packageInfo.buildNumber;
    _appName = packageInfo.appName;

    /// Get Initital Theme Mode
    _themeMode = LocalStorage.getThemeMode;

    deviceId = await _getDeviceId();
  }

  static Size screenUtilDesignSize() {
    // if (Device.get().isTablet) return const Size(1536, 2048);

    // if (Device.get().isPhone) return const Size(1080, 1920);

    return const Size(1080, 1920);
  }

  static void clearNotificationSystemCount() {
    if (Platform.isAndroid) Eraser.clearAllAppNotifications();
    if (Platform.isIOS)
      Eraser.resetBadgeCountAndRemoveNotificationsFromCenter();
  }
}

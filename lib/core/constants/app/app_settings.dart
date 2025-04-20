import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../common/text_formatters/iq_number_formatter.dart';
import '../enums/app_options_enum.dart';

class AppSettings {
  AppSettings._();

  /// Orientation option
  static const orientation = OrientationOptions.PORTRAIT;

  /// Error viewer view options
  static const errorViewOption = ErrorWidgetOptions.IMAGE;

  /// If app restart on change language or not
  static const bool changeLangRestart = true;

  /// Enable dio printing for debugging purposes
  static const bool enableDioPrinting = true;

  /// Enable [CatcherHandler] to handle any red screen with report
  static const bool enableErrorCatcher = true;

  static const bool enableNotifications = true;

  static const bool forceLocationPermission = false;

  static const bool enableBranchIO = false;

  // App Colors
  static const Color PRIMARY_COLOR_LIGHT = Colors.blue;
  static const Color ACCENT_COLOR_LIGHT = Colors.black;

  static const Color PRIMARY_COLOR_DARK = Colors.blue;
  static const Color ACCENT_COLOR_DARK = Colors.black;

  static final List<TextInputFormatter> PHONE_FIELD_FORMATTERS = [
    FilteringTextInputFormatter.allow(RegExp(r'^[0-9-]{1,12}')),
    IqNumberInputFormatter()
  ];
}

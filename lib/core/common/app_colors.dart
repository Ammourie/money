import 'package:flutter/material.dart';

import '../constants/app/app_settings.dart';

/// Centralizing application colors
class AppColors {
  AppColors._();

  // light theme colors
  static Color primaryColorLight = AppSettings.PRIMARY_COLOR_LIGHT;
  static Color accentColorLight = AppSettings.ACCENT_COLOR_LIGHT;

  // dark theme colors
  static Color primaryColorDark = AppSettings.PRIMARY_COLOR_DARK;
  static Color accentColorDark = AppSettings.ACCENT_COLOR_DARK;

  static const Color backgroundColorDark = Color(0xFF21252b);
  static const Color cardColor = Color(0xFF2b2d34);
  static const Color textDark = Colors.white;
  static const Color dark_text_gray = Color(0xFF666666);

  /// Not theme related
  static const Color lightFontColor = Color(0xFFfdfef9);
  static const Color backgroundColorLight = Colors.white;
  static const Color textLight = Color(0xFF333333);
  static const Color white = Color(0xFFFFFFFF);
  static const Color greenColor = Color(0xFF00ccb1);
  static const Color redColor = Color(0xFFf72448);
  static const Color bgColor = Color(0xFFfafdff);

  static const Color blueFontColor = Color(0xFF3f62ac);
  static const Color lightBlueColor = Color(0xFFe9f0fa);
  static const Color regularFontColor = Color(0xFF000000);
  static const Color facebookColor = Color(0xFFf4d6cac);
  static const Color termsBackgroundColor = Color(0xFFebf5f7);
  static const Color backgroundGradient1 = Color(0xFF202025);
  static const Color backgroundGradient2 = Color(0xFF393838);
  static const Color backgroundGradient3 = Color(0xFF202025);
  static const Color white_text = Color(0xFFFFFFFF);
  static const Color black_text = Color(0xFF000000);
  static const Color text_gray = Color(0xFF999999);
  static const Color text_gray_c = Color(0xFFcccccc);
  static const Color dark_button_text = Color(0xFFF2F2F2);
  static const Color dark_unselected_item_color = Color(0xFF4D4D4D);
  static const Color disabledTextColor = Color(0xFFa1a1a1);
  static const Color disabledColor = Colors.black87;
  static const Color canvasColor = Colors.transparent;
  static const Color toastTextColor = Colors.white;
}

import 'dart:io';

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../generated/l10n.dart';
import '../../theme/themes_data.dart';
import '../../ui/show_toast.dart';
import '../app_config.dart';
import '../local_storage.dart';

class Utils {
  Utils._();

  /// Find if any widget has focus in the given [context] and unfocus it
  static void unFocus(BuildContext context) {
    if (FocusScope.of(context).hasFocus) FocusScope.of(context).unfocus();
  }

  static Future<void> launchURL(Uri url, {LaunchMode? mode}) async {
    if (await canLaunchUrl(url)) {
      try {
        final platformLaunchMode = Platform.isIOS
            ? LaunchMode.externalApplication
            : LaunchMode.externalNonBrowserApplication;

        await launchUrl(
          url,
          mode: mode ?? platformLaunchMode,
        );
      } catch (e) {
        showToast(S.current.errorOccurred);
      }
    } else {
      showToast(S.current.errorOccurred);
    }
  }

  static void changeTheme(BuildContext context) async {
    ThemeSwitcher.of(context).changeTheme(
      theme: AppConfig().themeMode == ThemeMode.light
          ? ThemesData.darkTheme
          : ThemesData.lightTheme,
      isReversed: AppConfig().themeMode == ThemeMode.dark ? true : false,
    );

    ThemeMode theme = AppConfig().themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;

    await LocalStorage.persistThemeMode(theme);
    AppConfig().themeMode = theme;
  }

  static void share({
    required BuildContext context,
    required Uri link,
  }) {
    try {
      final box = context.findRenderObject() as RenderBox?;

      Share.share(
        link.toString(),
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
      );
    } catch (e) {
      showToast(S.current.errorOccurred);
    }
  }
}

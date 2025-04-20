part of '../themes_data.dart';

ThemeData _getDarkTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    colorScheme: const ColorScheme.dark().copyWith(
      primary: AppColors.primaryColorDark,
      secondary: AppColors.accentColorDark,
      surfaceTint: Colors.white,
    ),
    fontFamily: LanguageUtils.isLTR()
        ? GoogleFonts.poppins().fontFamily
        : AppConfig().appLanguage.toString() == AppConstants.LANG_AR
            ? GoogleFonts.cairo().fontFamily
            : GoogleFonts.notoNaskhArabic().fontFamily,
    textTheme: TextTheme(
      displayLarge: TextThemeStyles.displayLarge,
      displayMedium: TextThemeStyles.displayMedium,
      displaySmall: TextThemeStyles.displaySmall,
      headlineMedium: TextThemeStyles.headlineMedium,
      headlineSmall: TextThemeStyles.headlineSmall,
      titleLarge: TextThemeStyles.titleLarge,
      titleMedium: TextThemeStyles.titleMedium,
      titleSmall: TextThemeStyles.titleSmall,
      bodyLarge: TextThemeStyles.bodyLarge,
      bodyMedium: TextThemeStyles.bodyMedium,
      bodySmall: TextThemeStyles.bodySmall,
      labelLarge: TextThemeStyles.labelLarge,
      labelSmall: TextThemeStyles.labelSmall,
    ),
    extensions: [CustomThemeColors.dark],
  );
}

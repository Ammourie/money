import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';

import '../../../generated/l10n.dart';
import '../../constants/app/app_constants.dart';
import '../../constants/app/app_settings.dart';
import '../../constants/enums/languages_enum.dart';
import '../../localization/flutter_localization.dart';
import '../../navigation/nav.dart';
import '../widgets/restart_widget.dart';
import 'show_dialog.dart';

void showLanguageDialog({
  required BuildContext context,
}) {
  ShowDialog().showElasticDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return LanguageDialog(
        initialValue:
            mapStringToLanguagesEnum(intl.Intl.getCurrentLocale()).index,
      );
    },
  );
}

class LanguageDialog extends StatefulWidget {
  const LanguageDialog({
    required this.initialValue,
  });

  final int initialValue;

  @override
  State createState() => new LanguageDialogState();
}

class LanguageDialogState extends State<LanguageDialog> {
  int? _selectedId = 0;

  @override
  void initState() {
    super.initState();
    _selectedId = widget.initialValue;
  }

  Widget build(BuildContext context) {
    return new AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(
          const Radius.circular(15),
        ),
      ),
      title: Text(
        S.current.changeLangMessage,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      content: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(25)),
          ),
          padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              RadioListTile<int>(
                activeColor: Theme.of(context).primaryColor,
                title: const Text(AppConstants.LANG_EN_OUTPUT),
                groupValue: _selectedId,
                value: 0,
                onChanged: (index) {
                  setState(() {
                    _selectedId = index;
                  });
                },
              ),
              RadioListTile<int>(
                activeColor: Theme.of(context).primaryColor,
                title: Text(
                  AppConstants.LANG_AR_OUTPUT,
                  style: TextStyle(
                    fontFamily: GoogleFonts.cairo().fontFamily,
                  ),
                ),
                groupValue: _selectedId,
                value: 1,
                onChanged: (index) {
                  setState(() {
                    _selectedId = index;
                  });
                },
              ),
              RadioListTile<int>(
                activeColor: Theme.of(context).primaryColor,
                title: Text(
                  AppConstants.LANG_KU_OUTPUT,
                  style: TextStyle(
                    fontFamily: GoogleFonts.notoNaskhArabic().fontFamily,
                  ),
                ),
                groupValue: _selectedId,
                value: 2,
                onChanged: (index) {
                  setState(() {
                    _selectedId = index;
                  });
                },
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    child: Text(
                      S.current.cancel,
                    ),
                    onPressed: () {
                      // Navigator.of(context).pop();
                      Nav.pop();
                    },
                  ),
                  MaterialButton(
                    color: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        ScreenUtil().setWidth(35),
                      ),
                    ),
                    child: Text(
                      S.current.confirm,
                      style: const TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      if (this._selectedId == widget.initialValue) {
                        // Navigator.of(context).pop();
                        Nav.pop();
                        return;
                      }
                      switch (this._selectedId) {
                        case 0:
                          changeLanguage(
                            context,
                            const Locale(AppConstants.LANG_EN),
                          );

                          break;
                        case 1:
                          changeLanguage(
                              context, const Locale(AppConstants.LANG_AR));
                          // await Provider.of<AppConfigProvider>(context,
                          //         listen: false)
                          //     .changeLanguage(Locale(LANG_AR), context);
                          //
                          // BlocProvider.of<HomeInitBloc>(context)
                          //     .add(GetHomeInitEvent(CancelToken()));
                          break;
                        case 2:
                          changeLanguage(
                              context, const Locale(AppConstants.LANG_KU));
                      }
                      // Navigator.of(context).pop();
                      Nav.pop();
                    },
                    textColor: Theme.of(context).primaryColor,
                  ),
                ],
              )
            ],
          )),
    );
  }

  void changeLanguage(BuildContext context, Locale newLocale) async {
    await Provider.of<LocalizationProvider>(context, listen: false)
        .changeLanguage(newLocale, context);
    if (AppSettings.changeLangRestart) RestartWidget.restartApp(context);
  }
}

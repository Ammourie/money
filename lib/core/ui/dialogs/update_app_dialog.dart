import 'package:flutter/material.dart';

import '../../../generated/l10n.dart';
import '../../common/app_colors.dart';
import '../../common/app_config.dart';
import '../../common/utils/utils.dart';
import '../../navigation/nav.dart';
import '../widgets/custom_button.dart';

void showUpdateAppDialog(bool foreUpdate, String storeLink) {
  showDialog(
    context: AppConfig().appContext!,
    barrierDismissible: !foreUpdate,
    builder: (context) => _UpdateAppDialog(
      forceUpdate: foreUpdate,
      storeLink: storeLink,
    ),
  );
}

class _UpdateAppDialog extends StatelessWidget {
  final bool forceUpdate;
  final String storeLink;

  const _UpdateAppDialog({
    Key? key,
    required this.forceUpdate,
    required this.storeLink,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              forceUpdate
                  ? S.current.dialogUpdateTitle
                  : S.current.optionalUpdateTitle,
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              forceUpdate
                  ? S.current.dialogUpdateMessage
                  : S.current.optionalUpdateMessage,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 45,
              child: Row(
                children: [
                  if (!forceUpdate)
                    Expanded(
                      child: CustomButton(
                        fixedSize: const Size(0, 45),
                        primary: AppColors.primaryColorLight,
                        backgroundColor: Colors.transparent,
                        child: Text(
                          S.current.ignoreForNow,
                          textAlign: TextAlign.center,
                        ),
                        onPressed: () {
                          Nav.pop();
                        },
                      ),
                    ),
                  if (!forceUpdate) const SizedBox(width: 20),
                  Expanded(
                    child: CustomButton(
                      fixedSize: const Size(0, 45),
                      backgroundColor: Colors.grey,
                      child: Text(
                        S.current.update.toUpperCase(),
                      ),
                      onPressed: () {
                        Utils.launchURL(Uri.parse(storeLink));
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../generated/l10n.dart';
import '../../common/app_config.dart';
import '../../navigation/nav.dart';
import 'custom_dialogs.dart';

void showConfirmDialog({required VoidCallback onConfirmTap}) {
  showCustomConfirmCancelDialog(
    mainContext: AppConfig().appContext!,
    content: S.current.areYouSure,
    onConfirm: (context) {
      Nav.pop();
      onConfirmTap.call();
    },
  );
}

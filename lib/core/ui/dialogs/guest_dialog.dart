import 'package:flutter/material.dart';
import '../../common/app_config.dart';

void showGuestDialog() {
  showDialog(
    context: AppConfig().appContext!,
    builder: (context) {
      return const SimpleDialog(
        titlePadding: EdgeInsets.all(24),
        title: Text("Sorry, you are a guest, login to continue."),
      );
    },
  );
}

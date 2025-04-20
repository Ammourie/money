import 'dart:math';

import 'package:flutter/services.dart';

/// Format Iraqi phone numbers
/// Formatted phone  number will be like this xxx-xxx-xxxx
class IqNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final newText = newValue.text;
    final oldText = oldValue.text;
    int selectionIndex = newValue.selection.end;
    String formattedText = newText.replaceAll(r'-', "");
    final dashCounts = '-'.allMatches(newText).length;
    final oldDashCounts = '-'.allMatches(oldText).length;
    if (newText.length >= oldText.length ||
        (oldDashCounts == 2 &&
            oldText.length == 12 &&
            formattedText.length >= 6)) {
      if (formattedText.length >= 6) {
        formattedText =
            "${formattedText.substring(0, 3)}-${formattedText.substring(3, 6)}-${formattedText.length > 6 ? formattedText.substring(6) : ""}";
        if (selectionIndex >= 3) selectionIndex += dashCounts == 0 ? 1 : 0;
        if (selectionIndex >= 7) selectionIndex += dashCounts < 2 ? 1 : 0;
      } else if (formattedText.length >= 3 && dashCounts == 0) {
        formattedText =
            "${formattedText.substring(0, 3)}-${formattedText.length > 3 ? formattedText.substring(3) : ""}";
        if (selectionIndex >= 3) selectionIndex += 1;
      } else {
        formattedText = newText;
      }
    } else {
      formattedText = newText;
      if (formattedText.length > 0 &&
          formattedText[formattedText.length - 1] == '-') {
        formattedText = formattedText.substring(0, formattedText.length - 1);
      }
    }

    return TextEditingValue(
      text: formattedText.toString(),
      selection: new TextSelection.collapsed(
        offset: min(selectionIndex, formattedText.length),
      ),
    );
  }

  String getIraqMobileNumberAfterFormate(String mobileNumber) {
    return formatEditUpdate(
            TextEditingValue.empty, TextEditingValue(text: mobileNumber))
        .text;
  }

  static String getIraqMobileNumberWithZero(String mobileNumber) {
    return "0" + mobileNumber.replaceAll("-", "");
  }
}

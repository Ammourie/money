import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../generated/l10n.dart';
import '../../common/app_colors.dart';
import '../../common/app_config.dart';
import '../../constants/app/app_constants.dart';
import '../../constants/enums/success_dialog_type.dart';
import '../../navigation/nav.dart';

void showSuccessDialog({
  VoidCallback? onButtonPressed,
  required String title,
  required String content,
  String? buttonText,
  SuccessDialogType type = SuccessDialogType.type1,
}) {
  showDialog(
    context: AppConfig().appContext!,
    builder: (context) => _SuccessDialogWidget(
      onPressed: onButtonPressed,
      content: content,
      title: title,
      buttonText: buttonText,
      type: type,
    ),
  );
}

class _SuccessDialogWidget extends StatelessWidget {
  const _SuccessDialogWidget({
    this.onPressed,
    required this.title,
    required this.content,
    this.buttonText,
    this.type = SuccessDialogType.type1,
  });
  final VoidCallback? onPressed;
  final String title, content;
  final String? buttonText;
  final SuccessDialogType type;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const LinearBorder(),
      insetPadding: EdgeInsets.symmetric(
        horizontal: AppConstants.screenPadding,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppConstants.screenPadding,
          vertical: 24.h,
        ),
        child: type == SuccessDialogType.type1
            ? _SuccessDialogWidgetType1(
                buttonText: buttonText,
                onPressed: onPressed,
                content: content,
                title: title,
              )
            : _SuccessDialogWidgetType2(
                buttonText: buttonText,
                onPressed: onPressed,
                content: content,
                title: title,
              ),
      ),
    );
  }
}

class _SuccessDialogWidgetType1 extends StatelessWidget {
  const _SuccessDialogWidgetType1({
    this.onPressed,
    required this.title,
    required this.content,
    this.buttonText,
  });
  final VoidCallback? onPressed;
  final String title, content;
  final String? buttonText;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildTitle(),
        12.verticalSpace,
        _buildContent(),
        40.verticalSpace,
        _buildButton()
      ],
    );
  }

  FilledButton _buildButton() {
    return FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor: Colors.black,
      ),
      onPressed: onPressed ??
          () {
            Nav.pop();
          },
      child: Text(
        buttonText ?? S.current.close,
        style: TextStyle(
          color: Colors.white,
          fontSize: 32.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Text _buildContent() {
    return Text(
      content,
      style: TextStyle(
        color: Colors.black,
        fontSize: 38.sp,
        fontWeight: FontWeight.w400,
      ),
      textAlign: TextAlign.center,
    );
  }

  Row _buildTitle() {
    return Row(
      children: [
        Container(
          width: 80.sp,
          height: 80.sp,
          decoration: BoxDecoration(
            color: Colors.teal.shade600,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check_rounded,
            color: Colors.white,
            size: 32.sp,
          ),
        ),
        12.horizontalSpace,
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: Colors.black,
              fontSize: 38.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        )
      ],
    );
  }
}

class _SuccessDialogWidgetType2 extends StatelessWidget {
  const _SuccessDialogWidgetType2({
    this.onPressed,
    required this.title,
    required this.content,
    this.buttonText,
  });
  final VoidCallback? onPressed;
  final String title, content;
  final String? buttonText;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildTitle(),
        12.verticalSpace,
        _buildContent(),
        40.verticalSpace,
        _buildButton()
      ],
    );
  }

  FilledButton _buildButton() {
    return FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor: Colors.black,
      ),
      onPressed: onPressed ??
          () {
            Nav.pop();
          },
      child: Text(
        buttonText ?? S.current.close,
        style: TextStyle(
          color: Colors.white,
          fontSize: 32.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Text _buildContent() {
    return Text(
      content,
      style: TextStyle(
        color: Colors.black,
        fontSize: 38.sp,
        fontWeight: FontWeight.w400,
      ),
      textAlign: TextAlign.center,
    );
  }

  Column _buildTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 80.sp,
          height: 80.sp,
          decoration: BoxDecoration(
            color: Colors.teal.shade600,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check_rounded,
            color: AppColors.accentColorDark,
            size: 32.sp,
          ),
        ),
        10.verticalSpace,
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 38.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

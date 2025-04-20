import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../generated/l10n.dart';
import '../../common/app_config.dart';
import '../../constants/app/app_constants.dart';

class OTPWidget extends StatefulWidget {
  final String title;
  final Function(String) onChangeCode;
  final Function() onResendCodeTap;
  final Function() onConfirmButtonTap;

  OTPWidget({
    Key? key,
    required this.title,
    required this.onChangeCode,
    required this.onResendCodeTap,
    required this.onConfirmButtonTap,
  }) : super(key: key);

  @override
  State<OTPWidget> createState() => _OTPWidgetState();
}

class _OTPWidgetState extends State<OTPWidget> {
  final _pinCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // verification text
        _buildVerificationText(),
        22.verticalSpace,

        // enter code text
        Align(alignment: Alignment.center, child: _buildEnterCodeText()),
        67.verticalSpace,

        // pin code
        _buildPinCodeTextField(context),
        31.verticalSpace,

        // confirm button
        _buildConfirmButton(),
        100.verticalSpace,

        // didn't recieve code text
        Align(
          alignment: Alignment.center,
          child: _buildDidnotRecieveCodeText(),
        ),
        25.verticalSpace,

        // resend code
        Align(alignment: Alignment.center, child: _buildResendCodeText()),
      ],
    );
  }

  Text _buildVerificationText() {
    return Text(
      S.current.otpVerification,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 55.sp),
    );
  }

  Text _buildEnterCodeText() {
    return Text(widget.title, textAlign: TextAlign.center);
  }

  Text _buildDidnotRecieveCodeText() {
    return Text(
      S.current.didnotReceiveAnyCode,
      style: TextStyle(fontSize: 40.sp, color: Colors.grey.shade500),
    );
  }

  Text _buildResendCodeText() {
    return Text.rich(
      TextSpan(
        text: S.current.resendCode,
        recognizer: TapGestureRecognizer()..onTap = widget.onResendCodeTap,
      ),
      style: TextStyle(
        fontSize: 40.sp,
        decoration: TextDecoration.underline,
      ),
    );
  }

  PinCodeTextField _buildPinCodeTextField(BuildContext context) {
    return PinCodeTextField(
      controller: _pinCodeController,
      autoFocus: true,
      length: AppConstants.OTP_LENGTH,
      appContext: AppConfig().appContext!,
      pinTheme: PinTheme(
        fieldWidth: 60,
        fieldHeight: 60,
        shape: PinCodeFieldShape.underline,
        inactiveColor: Colors.grey.shade200,
        activeColor: Theme.of(context).colorScheme.primary,
        selectedColor: Theme.of(context).colorScheme.primary.withOpacity(.2),
      ),
      animationType: AnimationType.fade,
      keyboardType: TextInputType.number,
      onChanged: widget.onChangeCode,
      errorTextSpace: 24,
      errorTextDirection:
          AppConfig().appLanguage.languageCode == AppConstants.LANG_EN
              ? TextDirection.ltr
              : TextDirection.rtl,
      onCompleted: (_) => widget.onConfirmButtonTap(),
    );
  }

  Widget _buildConfirmButton() {
    return ValueListenableBuilder(
      valueListenable: _pinCodeController,
      builder: (context, value, child) {
        return Ink(
          width: 1.0.sw,
          decoration: BoxDecoration(
            color: value.text.length < AppConstants.OTP_LENGTH
                ? Theme.of(context).colorScheme.primary.withOpacity(.2)
                : Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(5),
          ),
          child: InkWell(
            onTap: value.text.length < AppConstants.OTP_LENGTH
                ? null
                : widget.onConfirmButtonTap,
            splashColor: Colors.white30,
            child: child,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Text(
          S.current.confirm.toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            letterSpacing: 1.5,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

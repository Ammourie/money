import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../../../core/common/text_formatters/iq_number_formatter.dart';
import '../../../core/common/view_model/base_view_model.dart';
import '../../../core/constants/enums/otp_request_type.dart';
import '../../../core/ui/dialogs/otp_dialog.dart';
import '../../../services/api_cubit/api_cubit.dart';
import '../model/param/login_param.dart';
import '../view/login_view.dart';

class LoginViewModel extends BaseViewModel<LoginViewParam> {
  LoginViewModel(super.param);

  /// Screen vars
  final FocusNode myFocusNodeUserName = FocusNode();

  final cancelToken = CancelToken();

  final formKey = GlobalKey<FormState>();
  final phoneOrEmailController = TextEditingController();

  final loginCubit = ApiCubit();

  // get, set

  /// Methods
  void unFocus() {
    myFocusNodeUserName.unfocus();
  }

  void login() async {
    unFocus();

    if (formKey.currentState!.validate()) {
      loginCubit.login(
        LoginParam(
          phoneNumber: IqNumberInputFormatter.getIraqMobileNumberWithZero(
            phoneOrEmailController.text,
          ),
          cancelToken: cancelToken,
        ),
      );
    }
  }

  void showOtp() {
    showOtpDialog(
      otpRequestType: OtpRequestType.ConfirmLoginOrRegister,
      phoneNumber: IqNumberInputFormatter.getIraqMobileNumberWithZero(
        phoneOrEmailController.text,
      ),
    );
  }

  @override
  void closeModel() {
    phoneOrEmailController.dispose();
    myFocusNodeUserName.dispose();
    loginCubit.close();
  }
}

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../features/account/model/param/confirm_code_param.dart';
import '../../../features/account/model/param/confirm_delete_my_account_param.dart';
import '../../../features/account/model/param/confirm_new_phone_number_param.dart';
import '../../../features/account/model/param/resend_code_param.dart';
import '../../../features/account/model/response/confirm_code_model.dart';
import '../../../features/home/view_model/app_main_view_model.dart';
import '../../../generated/l10n.dart';
import '../../../services/api_cubit/api_cubit.dart';
import '../../common/app_config.dart';
import '../../common/local_storage.dart';
import '../../common/text_formatters/iq_number_formatter.dart';
import '../../common/utils/language_utils.dart';
import '../../constants/app/app_constants.dart';
import '../../constants/enums/otp_request_type.dart';
import '../../navigation/nav.dart';
import '../../params/no_params.dart';
import '../error_ui/error_viewer/error_viewer.dart';
import '../show_toast.dart';
import '../widgets/otp_widget.dart';
import '../widgets/restart_widget.dart';

void showOtpDialog({
  required String phoneNumber,
  required OtpRequestType otpRequestType,
  VoidCallback? onSuccessConfirmNewPhoneNumber,
}) {
  showDialog(
    context: AppConfig().appContext!,
    builder: (_) {
      return _OTPDialog(
        otpRequestType: otpRequestType,
        phoneNumber: phoneNumber,
        onSuccessConfirmNewPhoneNumber: onSuccessConfirmNewPhoneNumber,
      );
    },
  );
}

class _OTPDialog extends StatefulWidget {
  const _OTPDialog({
    required this.phoneNumber,
    required this.otpRequestType,
    required this.onSuccessConfirmNewPhoneNumber,
  });
  final String phoneNumber;
  final OtpRequestType otpRequestType;
  final VoidCallback? onSuccessConfirmNewPhoneNumber;

  @override
  State<_OTPDialog> createState() => __OTPDialogState();
}

class __OTPDialogState extends State<_OTPDialog> {
  final apiCubit = ApiCubit();
  final confirmCodeCancelToken = CancelToken();
  final resendCodeCancelToken = CancelToken();

  String formattedPhoneNumber = '';
  bool _isLoading = false;
  String _otp = "";

  set isLoading(bool value) {
    setState(() => _isLoading = value);
  }

  @override
  void initState() {
    super.initState();
    formattedPhoneNumber = IqNumberInputFormatter()
        .getIraqMobileNumberAfterFormate(widget.phoneNumber.substring(1));

    if (LanguageUtils.isRTL()) {
      formattedPhoneNumber =
          formattedPhoneNumber.split('-').reversed.toList().join("-");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ApiCubit, ApiState>(
      bloc: apiCubit,
      listener: (context, state) {
        state.maybeWhen(
          orElse: () => isLoading = false,
          loading: () => isLoading = true,
          error: (error, callback) {
            isLoading = false;
            ErrorViewer.showError(
              context: context,
              error: error,
              callback: callback,
            );
          },
          confirmCodeLoaded: (confirmCodeEntity) {
            _confirmCodeLoaded(confirmCodeEntity);
          },
          successResendCode: () {
            isLoading = false;
            showToast(S.current.codeResent);
          },
          successConfirmNewPhoneNumber: () {
            widget.onSuccessConfirmNewPhoneNumber?.call();
            isLoading = false;
            showToast(S.current.updatedSuccessfully);
            Nav.pop();
          },
          successResendNewPhoneNumberCode: () {
            isLoading = false;
            showToast(S.current.codeResent);
          },
          successConfirmDeleteMyAccount: () {
            isLoading = false;
            Nav.pop();
            context.read<AppMainViewModel>().logout();
          },
          successResendDeleteMyAccountCode: () {
            isLoading = false;
            showToast(S.current.codeResent);
          },
          // successResendProfilePhonecode: () {
          //   isLoading = false;
          //   showToast(S.current.codeResent);
          // },
          // successResendAccountDeleteOTP: () {
          //   isLoading = false;
          //   showToast(S.current.codeResent);
          // },
          // successConfirmAccountDelete: () {
          //   isLoading = false;
          //   Nav.pop();
          //   widget.onSuccess?.call();
          // },
          // registerLoaded: (registerEntity) {
          //   showToast(registerEntity.name);
          // },
          // successProfilePhoneCodeConfirm: () {
          //   isLoading = false;
          //   Nav.pop();
          //   widget.onSuccess?.call();
          //   showToast(S.current.updatedSuccessfully);
          //   context.read<SessionData>().updateProfile(
          //         phoneNumber: widget.mobileNumber,
          //       );
          // },
        );
      },
      child: ModalProgressHUD(
        inAsyncCall: _isLoading,
        child: Align(
          child: SingleChildScrollView(
            child: Dialog(
              shape: const LinearBorder(),
              insetPadding: EdgeInsets.symmetric(
                horizontal: AppConstants.screenPadding,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 50.w,
                  vertical: 80.h,
                ),
                child: OTPWidget(
                  title: S.current.otpText(formattedPhoneNumber),
                  onChangeCode: (value) => _otp = value,
                  onConfirmButtonTap: _onConfirmTap,
                  onResendCodeTap: _onResendTap,
                  // focusNode: _focusNode,
                  // email: widget.email,
                  // mobileNumber: widget.mobileNumber,
                  // onComplete: (value) {
                  //   _otp = value;
                  //   _onConfirmTap();
                  // },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _confirmCodeLoaded(ConfirmCodeModel data) async {
    if (data.accessToken.isNotEmpty) {
      await LocalStorage.persistToken(data.accessToken);
      isLoading = false;
      RestartWidget.restartApp(context);
    }
  }

  void _onResendTap() {
    switch (widget.otpRequestType) {
      case OtpRequestType.ConfirmProfileNumberChange:
        apiCubit.resendNewPhoneNumberCode(NoParams());
        break;
      case OtpRequestType.ConfirmLoginOrRegister:
        apiCubit.resendCode(
          ResendCodeParam(
            phoneNumber: widget.phoneNumber,
            cancelToken: resendCodeCancelToken,
          ),
        );
      case OtpRequestType.AccountDelete:
        apiCubit.resendDeleteMyAccountCode();
        break;
    }
  }

  void _onConfirmTap() {
    switch (widget.otpRequestType) {
      case OtpRequestType.ConfirmProfileNumberChange:
        apiCubit.confirmNewPhoneNumber(
          ConfirmNewPhoneNumberParam(
            confirmationCode: _otp,
          ),
        );
        break;
      case OtpRequestType.ConfirmLoginOrRegister:
        apiCubit.confirmCode(
          ConfirmCodeParam(
            phoneNumber: widget.phoneNumber,
            code: _otp,
            cancelToken: confirmCodeCancelToken,
          ),
        );
      case OtpRequestType.AccountDelete:
        apiCubit.confirmDeleteMyAccount(
          ConfirmDeleteMyAccountParam(
            deletionCode: _otp,
          ),
        );
        break;
    }
  }

  @override
  void dispose() {
    super.dispose();
    apiCubit.close();
  }
}

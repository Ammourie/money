import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../../core/common/app_config.dart';
import '../../../../core/common/text_formatters/iq_number_formatter.dart';
import '../../../../core/common/validators.dart';
import '../../../../core/navigation/nav.dart';
import '../../../../core/providers/session_data.dart';
import '../../../../core/ui/error_ui/error_viewer/error_viewer.dart';
import '../../../../core/ui/widgets/custom_button.dart';
import '../../../../core/ui/widgets/custom_text_field.dart';
import '../../../../generated/l10n.dart';
import '../../../../services/api_cubit/api_cubit.dart';
import '../../model/param/update_profile_param.dart';

Future<String?> showChangePhoneNumberDialog() {
  return showDialog(
    context: AppConfig().appContext!,
    builder: (context) {
      return const _ChangePhoneNumberDialog();
    },
  );
}

class _ChangePhoneNumberDialog extends StatefulWidget {
  const _ChangePhoneNumberDialog();

  @override
  State<_ChangePhoneNumberDialog> createState() =>
      _ChangePhoneNumberDialogState();
}

class _ChangePhoneNumberDialogState extends State<_ChangePhoneNumberDialog> {
  final apiCubit = ApiCubit();
  final phoneNumberController = TextEditingController();
  final phoneNumberFocusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  set isLoading(bool v) {
    if (_isLoading == v) return;
    _isLoading = v;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    phoneNumberFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ApiCubit, ApiState>(
      bloc: apiCubit,
      listener: (context, state) {
        state.maybeWhen(
          loading: () => isLoading = true,
          error: (error, callback) {
            isLoading = false;
            ErrorViewer.showError(
                context: context, error: error, callback: callback);
          },
          successUpdateProfile: () {
            isLoading = false;
            Nav.pop(
              null,
              IqNumberInputFormatter.getIraqMobileNumberWithZero(
                phoneNumberController.text,
              ),
            );
          },
          orElse: () {},
        );
      },
      child: ModalProgressHUD(
        inAsyncCall: _isLoading,
        child: Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 25.w),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 60.h),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomTextField(
                    maxLength: 12,
                    decoration: InputDecoration(
                      hintText: S.of(context).newPhoneNumber,
                      counterText: '',
                    ),
                    controller: phoneNumberController,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.phone,
                    focusNode: phoneNumberFocusNode,
                    inputFormatters: [IqNumberInputFormatter()],
                    validator: (value) {
                      if (Validators.isValidPhoneNumber(value!))
                        return null;
                      else
                        return S.of(context).invalidPhoneNumber;
                    },
                    onFieldSubmitted: (_) => phoneNumberFocusNode.unfocus(),
                  ),
                  100.verticalSpace,

                  // Submit button.
                  CustomButton(
                    fixedSize: Size(1.sw, 120.h),
                    child: Text(S.current.submit),
                    onPressed: onSubmitTap,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onSubmitTap() {
    final profile = AppConfig().appContext?.read<SessionData>().profile;

    if (formKey.currentState?.validate() ?? false) {
      phoneNumberFocusNode.unfocus();

      apiCubit.updateProfile(
        UpdateProfileParam(
          firstName: profile?.firstName,
          lastName: profile?.lastName,
          emailAddress: profile?.emailAddress,
          gender: profile?.gender,
          phoneNumber: IqNumberInputFormatter.getIraqMobileNumberWithZero(
            phoneNumberController.text,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    apiCubit.close();
    phoneNumberController.dispose();
    phoneNumberFocusNode.dispose();
    super.dispose();
  }
}

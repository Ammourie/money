import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

import '../../../core/common/app_colors.dart';
import '../../../core/common/responsive/responsive_utils.dart';
import '../../../core/common/text_formatters/iq_number_formatter.dart';
import '../../../core/common/utils/utils.dart';
import '../../../core/common/validators.dart';
import '../../../core/navigation/nav.dart';
import '../../../core/ui/error_ui/error_viewer/error_viewer.dart';
import '../../../core/ui/screens/base_view.dart';
import '../../../core/ui/show_toast.dart';
import '../../../core/ui/widgets/custom_button.dart';
import '../../../core/ui/widgets/custom_scaffold.dart';
import '../../../core/ui/widgets/custom_text_field.dart';
import '../../../generated/l10n.dart';
import '../../../services/api_cubit/api_cubit.dart';
import '../view_model/login_view_model.dart';
import 'register_view.dart';

class LoginViewParam {}

class LoginView extends BaseView<LoginViewParam> {
  static const routeName = "/LoginScreen";

  LoginView({required LoginViewParam param, Key? key})
      : super(param: param, key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late LoginViewModel vm;

  @override
  void initState() {
    super.initState();
    vm = LoginViewModel(widget.param);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: vm,
      builder: (context, _) {
        context.select<LoginViewModel, bool>((p) => p.isLoading);

        return BlocListener<ApiCubit, ApiState>(
          bloc: vm.loginCubit,
          listener: (context, state) {
            state.maybeWhen(
              loading: () => vm.isLoading = true,
              error: (error, callback) {
                vm.isLoading = false;
                ErrorViewer.showError(
                    context: context, error: error, callback: callback);
              },
              loginLoaded: (data) {
                vm.isLoading = false;

                if (data.isUserExist) {
                  vm.showOtp();
                } else {
                  showToast(S.current.userDoesNotExist);
                }
              },
              orElse: () {},
            );
          },
          child: CustomScaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: ModalProgressHUD(
              inAsyncCall: vm.isLoading,
              child: Form(
                key: vm.formKey,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  height: ScreenUtil().screenHeight,
                  width: ScreenUtil().screenWidth,
                  child: getValueForOrientation(
                    context,
                    portrait: _buildPortrait(),
                    landscape: _buildLandscape(),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPortrait() {
    return Container(
      height: 1.sh,
      alignment: Alignment.center,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            64.verticalSpace,
            Text(
              S.of(context).welcome(""),
              style: Theme.of(context).textTheme.bodyLarge!,
            ),
            64.verticalSpace,
            _buildPhoneNumberField(),
            64.verticalSpace,
            _buildButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildLandscape() {
    return Row(
      children: [
        Container(
          width: ScreenUtil().screenWidth * 0.6,
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  S.of(context).welcome(""),
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontSize: 120.sp,
                      ),
                ),
                32.verticalSpace,
                _buildPhoneNumberField(),
              ],
            ),
          ),
        ),
        32.verticalSpace,
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            64.verticalSpace,
            CustomButton(
              backgroundColor: AppColors.greenColor,
              primary: AppColors.lightFontColor,
              child: Text(S.of(context).login),
              onPressed: () {
                vm.login();
              },
            ),
            12.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  S.of(context).or,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).primaryColor,
                      ),
                ),
              ],
            ),
            32.verticalSpace,
            CustomButton(
              backgroundColor: AppColors.lightBlueColor,
              child: Text(S.of(context).signUp),
              primary: AppColors.blueFontColor,
              onPressed: () {
                vm.unFocus();
                Nav.to(RegisterView.routeName, arguments: RegisterViewParam());
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPhoneNumberField() {
    return CustomTextField(
      maxLength: 12,
      controller: vm.phoneOrEmailController,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.phone,
      focusNode: vm.myFocusNodeUserName,
      decoration: InputDecoration(
        hintText: S.of(context).phone,
        counterText: '',
      ),
      inputFormatters: [IqNumberInputFormatter()],
      validator: (value) {
        if (Validators.isValidPhoneNumber(value!))
          return null;
        else
          return S.of(context).invalidPhoneNumber;
      },
      onFieldSubmitted: (term) {
        Utils.unFocus(context);
        vm.login();
      },
    );
  }

  @override
  void dispose() {
    vm.closeModel();
    super.dispose();
  }

  Widget _buildButtons() {
    return Column(
      children: [
        CustomButton(
          fixedSize: Size(400.w, 0),
          backgroundColor: AppColors.greenColor,
          child: Text(S.of(context).login),
          primary: AppColors.lightFontColor,
          onPressed: () {
            vm.login();
          },
        ),
        32.verticalSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              S.of(context).or,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).primaryColor,
                  ),
            ),
          ],
        ),
        32.verticalSpace,
        CustomButton(
          fixedSize: Size(400.w, 0),
          backgroundColor: AppColors.lightBlueColor,
          child: Text(S.of(context).signUp),
          primary: AppColors.blueFontColor,
          onPressed: () {
            vm.unFocus();
            Nav.to(RegisterView.routeName, arguments: RegisterViewParam());
          },
        ),
      ],
    );
  }
}

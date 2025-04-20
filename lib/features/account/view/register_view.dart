import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

import '../../../core/common/app_colors.dart';
import '../../../core/common/text_formatters/iq_number_formatter.dart';
import '../../../core/common/validators.dart';
import '../../../core/constants/enums/gender_enum.dart';
import '../../../core/constants/enums/otp_request_type.dart';
import '../../../core/navigation/animations/animated_route.dart';
import '../../../core/ui/dialogs/otp_dialog.dart';
import '../../../core/ui/error_ui/error_viewer/error_viewer.dart';
import '../../../core/ui/screens/base_view.dart';
import '../../../core/ui/widgets/custom_button.dart';
import '../../../core/ui/widgets/custom_scaffold.dart';
import '../../../core/ui/widgets/custom_text_field.dart';
import '../../../generated/l10n.dart';
import '../../../services/api_cubit/api_cubit.dart';
import '../view_model/register_view_model.dart';

class RegisterViewParam {}

class RegisterView extends BaseView {
  static const routeName = "/RegisterView";

  RegisterView({required RegisterViewParam param, Key? key})
      : super(param: param, key: key);

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late RegisterViewModel vm;

  @override
  void initState() {
    super.initState();
    vm = RegisterViewModel(widget.param);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: vm,
      builder: (context, _) {
        context.select<RegisterViewModel, bool>((p) => p.isLoading);

        return BlocListener<ApiCubit, ApiState>(
          bloc: vm.registerCubit,
          listener: (context, state) {
            state.maybeWhen(
              loading: () => vm.isLoading = true,
              error: (error, callback) {
                vm.isLoading = false;
                ErrorViewer.showError(
                  context: context,
                  error: error,
                  callback: callback,
                );
              },
              registerLoaded: (data) {
                vm.isLoading = false;
                showOtpDialog(
                  phoneNumber:
                      IqNumberInputFormatter.getIraqMobileNumberWithZero(
                    vm.phoneNumberController.text,
                  ),
                  otpRequestType: OtpRequestType.ConfirmLoginOrRegister,
                );
              },
              orElse: () {},
            );
          },
          child: ModalProgressHUD(
            inAsyncCall: vm.isLoading,
            child: CustomScaffold(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              appBar: AppBar(
                title: Text(S.of(context).signUp),
              ),
              body: _buildScreen(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildScreen() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
          child: Form(
            key: vm.formKey,
            child: Column(
              children: <Widget>[
                SlidingAnimated(
                  initialOffsetX: 1.5,
                  intervalStart: 0,
                  intervalEnd: 0.1,
                  child: _buildNameField(),
                ),
                64.verticalSpace,
                SlidingAnimated(
                  initialOffsetX: 1.5,
                  intervalStart: 0.1,
                  intervalEnd: 0.2,
                  child: _buildSurnameField(),
                ),
                64.verticalSpace,
                SlidingAnimated(
                  initialOffsetX: 1.5,
                  intervalStart: 0.2,
                  intervalEnd: 0.4,
                  child: _buildPhoneField(),
                ),
                64.verticalSpace,
                SlidingAnimated(
                  initialOffsetX: 1.5,
                  intervalStart: 0.4,
                  intervalEnd: 0.6,
                  child: _buildEmailField(),
                ),
                64.verticalSpace,
                SlidingAnimated(
                  initialOffsetX: 1.5,
                  intervalStart: 0.5,
                  intervalEnd: 0.7,
                  child: _buildBirthDateField(),
                ),
                64.verticalSpace,
                SlidingAnimated(
                  initialOffsetX: 1.5,
                  intervalStart: 0.7,
                  intervalEnd: 0.8,
                  child: _buildSelectGender(),
                ),
                128.verticalSpace,
                SlidingAnimated(
                  initialOffsetX: 2,
                  intervalStart: 0.2,
                  intervalEnd: 1,
                  child: CustomButton(
                    fixedSize: Size(400.w, 0),
                    backgroundColor: AppColors.greenColor,
                    child: Text(S.of(context).signUp),
                    primary: AppColors.lightFontColor,
                    onPressed: () => vm.register(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return CustomTextField(
      decoration: InputDecoration(
        hintText: S.of(context).name,
      ),
      controller: vm.nameController,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.text,
      focusNode: vm.nameFocusNode,
      validator: (value) {
        if (Validators.isValidName(value!))
          return null;
        else
          return S.of(context).errorEmptyField;
      },
      onFieldSubmitted: (term) {
        vm.surnameFocusNode.requestFocus();
      },
    );
  }

  Widget _buildSurnameField() {
    return CustomTextField(
      decoration: InputDecoration(
        hintText: S.of(context).surname,
      ),
      controller: vm.surameController,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.text,
      focusNode: vm.surnameFocusNode,
      validator: (value) {
        if (Validators.isValidName(value!))
          return null;
        else
          return S.of(context).errorEmptyField;
      },
      onFieldSubmitted: (term) => vm.phoneNumberFocusNode.requestFocus(),
    );
  }

  Widget _buildPhoneField() {
    return CustomTextField(
      maxLength: 12,
      decoration: InputDecoration(
        hintText: S.of(context).phone,
        counterText: '',
      ),
      controller: vm.phoneNumberController,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.phone,
      focusNode: vm.phoneNumberFocusNode,
      inputFormatters: [IqNumberInputFormatter()],
      validator: (value) {
        if (Validators.isValidPhoneNumber(value!))
          return null;
        else
          return S.of(context).invalidPhoneNumber;
      },
      onFieldSubmitted: (_) => vm.emailFocusNode.requestFocus(),
    );
  }

  Widget _buildEmailField() {
    return CustomTextField(
      decoration: InputDecoration(
        hintText: S.current.emailAddress,
      ),
      controller: vm.emailController,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.text,
      focusNode: vm.emailFocusNode,
      validator: (value) {
        if (value == null || value.isEmpty || Validators.isValidEmail(value))
          return null;
        else
          return S.of(context).notValidEmail;
      },
      onFieldSubmitted: (term) => vm.emailFocusNode.unfocus(),
    );
  }

  Widget _buildSelectGender() {
    return Builder(
      builder: (context) {
        context.select<RegisterViewModel, GenderEnum?>((p) => p.gender);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(S.current.selectYourGender),
            RadioListTile<GenderEnum>(
              contentPadding: EdgeInsets.zero,
              value: GenderEnum.Male,
              groupValue: vm.gender,
              onChanged: (value) {
                vm.gender = value;
              },
              title: Text(S.current.male),
            ),
            RadioListTile<GenderEnum>(
              contentPadding: EdgeInsets.zero,
              value: GenderEnum.Female,
              groupValue: vm.gender,
              onChanged: (value) {
                vm.gender = value;
              },
              title: Text(S.current.female),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBirthDateField() {
    return Builder(
      builder: (context) {
        context.select<RegisterViewModel, DateTime?>((p) => p.dateOfBirth);

        return Stack(
          children: [
            CustomTextField(
              decoration: InputDecoration(
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.calendar_month),
                prefixIconConstraints: const BoxConstraints(minWidth: 60),
                hintText: S.current.dateOfBirth,
              ),
              controller: TextEditingController(text: vm.formattedDateOdBirth),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
            ),
            Positioned.fill(child: InkWell(onTap: vm.onBirthDateTap)),
            if (vm.dateOfBirth != null)
              PositionedDirectional(
                end: 0,
                top: 0,
                bottom: 0,
                child: InkWell(
                  onTap: vm.onClearDateOfBirthTap,
                  child: const Icon(
                    Icons.close,
                    color: Colors.red,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    vm.closeModel();
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

import '../../../core/common/text_formatters/iq_number_formatter.dart';
import '../../../core/common/validators.dart';
import '../../../core/constants/app/app_constants.dart';
import '../../../core/constants/enums/gender_enum.dart';
import '../../../core/constants/enums/otp_request_type.dart';
import '../../../core/providers/session_data.dart';
import '../../../core/ui/dialogs/otp_dialog.dart';
import '../../../core/ui/error_ui/error_viewer/error_viewer.dart';
import '../../../core/ui/screens/base_view.dart';
import '../../../core/ui/show_toast.dart';
import '../../../core/ui/widgets/custom_button.dart';
import '../../../core/ui/widgets/custom_scaffold.dart';
import '../../../core/ui/widgets/custom_text_field.dart';
import '../../../generated/l10n.dart';
import '../../../services/api_cubit/api_cubit.dart';
import '../view_model/profile_view_model.dart';

class ProfileViewParam {}

class ProfileView extends BaseView<ProfileViewParam> {
  const ProfileView({super.key, required super.param});

  static const String routeName = "/ProfileView";

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late final ProfileViewModel vm;

  @override
  void initState() {
    super.initState();
    vm = ProfileViewModel(widget.param);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ApiCubit, ApiState>(
      bloc: vm.updateProfileCubit,
      listener: (context, state) {
        state.maybeWhen(
          loading: () => vm.isLoading = true,
          error: (error, callback) {
            vm.isLoading = false;
            ErrorViewer.showError(
                context: context, error: error, callback: callback);
          },
          successUpdateProfile: () {
            vm.isLoading = false;
            context.read<SessionData>().updateProfile(
                  firstName: vm.nameController.text,
                  lastName: vm.surnameController.text,
                  dateOfBirth: vm.dateOfBirth,
                  emailAddress: vm.emailController.text,
                  gender: vm.gender,
                  genderText: vm.gender.toString(),
                );
            showToast(S.current.updatedSuccessfully);
          },
          successRequestDeleteMyAccount: () {
            vm.isLoading = false;
            showOtpDialog(
              phoneNumber:
                  context.read<SessionData>().profile?.phoneNumber ?? '',
              otpRequestType: OtpRequestType.AccountDelete,
            );
          },
          orElse: () {},
        );
      },
      child: ChangeNotifierProvider.value(
        value: vm,
        builder: (context, child) {
          context.select<ProfileViewModel, bool>((p) => p.isLoading);

          return ModalProgressHUD(
            inAsyncCall: vm.isLoading,
            child: _buildContent(),
          );
        },
      ),
    );
  }

  Widget _buildContent() {
    return CustomScaffold(
      key: vm.scaffoldKey,
      appBar: AppBar(
        title: Text(S.current.myProfile),
        actions: [_buildDeleteAccountButton()],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: AppConstants.screenPadding),
        child: Form(
          key: vm.formKey,
          child: Column(
            children: [
              _buildNameField(),
              64.verticalSpace,
              _buildSurnameField(),
              64.verticalSpace,
              _buildPhoneField(),
              64.verticalSpace,
              _buildEmailField(),
              64.verticalSpace,
              _buildBirthDateField(),
              64.verticalSpace,
              _buildSelectGender(),
              64.verticalSpace,
              _buildUpdateProfileButton(),
              32.verticalSpace,
              _buildChangePhoneNumberButton(),
            ],
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
      controller: vm.surnameController,
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
      enabled: false,
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
        context.select<ProfileViewModel, GenderEnum?>((p) => p.gender);

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
        context.select<ProfileViewModel, DateTime?>((p) => p.dateOfBirth);

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

  Widget _buildUpdateProfileButton() {
    return CustomButton(
      fixedSize: Size(1.sw, 120.h),
      child: Text(
        S.current.updateProfile,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      onPressed: vm.onUpdateProfileTap,
    );
  }

  Widget _buildChangePhoneNumberButton() {
    return CustomButton(
      fixedSize: Size(1.sw, 120.h),
      child: Text(
        S.current.changePhoneNumber,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      onPressed: vm.onChangePhoneNumberTap,
    );
  }

  Widget _buildDeleteAccountButton() {
    return InkWell(
      onTap: vm.onDeleteAccountTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Row(
          children: [
            Icon(
              Icons.delete,
              size: 48.sp,
              color: Colors.red,
            ),
            Text(
              S.current.deleteAccount,
              style: TextStyle(
                fontSize: 28.sp,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/common/app_config.dart';
import '../../../core/common/text_formatters/iq_number_formatter.dart';
import '../../../core/common/view_model/base_view_model.dart';
import '../../../core/constants/enums/gender_enum.dart';
import '../../../core/constants/enums/otp_request_type.dart';
import '../../../core/providers/session_data.dart';
import '../../../core/ui/dialogs/confirm_dialog.dart';
import '../../../core/ui/dialogs/otp_dialog.dart';
import '../../../services/api_cubit/api_cubit.dart';
import '../model/param/update_profile_param.dart';
import '../view/profile_view.dart';
import '../view/widgets/change_phone_number_dialog.dart';

class ProfileViewModel extends BaseViewModel<ProfileViewParam> {
  ProfileViewModel(super.param) {
    final profile = AppConfig().appContext?.read<SessionData>().profile;
    if (profile != null) {
      nameController.text = profile.firstName;
      surnameController.text = profile.lastName;
      phoneNumberController.text = IqNumberInputFormatter()
          .getIraqMobileNumberAfterFormate(profile.phoneNumber.substring(1));
      emailController.text = profile.emailAddress;
      _gender = profile.gender;
      _dateOfBirth = profile.dateOfBirth;
    }
  }
  final updateProfileCubit = ApiCubit();
  final scaffoldKey = GlobalKey();
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final surnameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final emailController = TextEditingController();

  final nameFocusNode = FocusNode();
  final surnameFocusNode = FocusNode();
  final phoneNumberFocusNode = FocusNode();
  final emailFocusNode = FocusNode();

  GenderEnum? _gender;
  DateTime? _dateOfBirth;

  DateTime? get dateOfBirth => _dateOfBirth;
  GenderEnum? get gender => _gender;
  String? get formattedDateOdBirth =>
      _dateOfBirth != null ? DateFormat('d/M/y').format(_dateOfBirth!) : null;

  set gender(GenderEnum? v) {
    if (v == _gender) return;
    _gender = v;
    notifyListeners();
  }

  set dateOfBirth(DateTime? v) {
    if (v == _dateOfBirth) return;
    _dateOfBirth = v;
    notifyListeners();
  }

  void onBirthDateTap() async {
    final value = await showDatePicker(
      context: AppConfig().appContext!,
      initialDate: _dateOfBirth ?? DateTime(DateTime.now().year - 15),
      firstDate: DateTime(1900),
      lastDate: DateTime(DateTime.now().year - 15),
      builder: (context, child) {
        return TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0.3, end: 1),
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOutBack,
          builder: (context, value, _) {
            return Transform.scale(
              scale: value,
              child: child!,
            );
          },
        );
      },
    );

    if (value != null) {
      dateOfBirth = value;
    }
  }

  void onClearDateOfBirthTap() {
    dateOfBirth = null;
  }

  void onDeleteAccountTap() {
    showConfirmDialog(onConfirmTap: () {
      updateProfileCubit.deleteMyAccount();
    });
  }

  void onUpdateProfileTap() {
    if (formKey.currentState?.validate() ?? false) {
      showConfirmDialog(onConfirmTap: () {
        updateProfileCubit.updateProfile(
          UpdateProfileParam(
            firstName: nameController.text,
            lastName: surnameController.text,
            emailAddress: emailController.text,
            dateOfBirth: _dateOfBirth,
            gender: _gender,
            phoneNumber: IqNumberInputFormatter.getIraqMobileNumberWithZero(
                phoneNumberController.text),
          ),
        );
      });
    }
  }

  void onChangePhoneNumberTap() async {
    final newPhoneNumber = await showChangePhoneNumberDialog();
    if (newPhoneNumber != null) {
      showOtpDialog(
        phoneNumber: newPhoneNumber,
        otpRequestType: OtpRequestType.ConfirmProfileNumberChange,
        onSuccessConfirmNewPhoneNumber: () {
          // Update profile in session.
          AppConfig().appContext!.read<SessionData>().updateProfile(
                phoneNumber: newPhoneNumber,
              );

          // Change phone number controller text.
          phoneNumberController.text = IqNumberInputFormatter()
              .getIraqMobileNumberAfterFormate(newPhoneNumber.substring(1));
        },
      );
    }
  }

  @override
  void closeModel() {
    updateProfileCubit.close();
    nameController.dispose();
    surnameController.dispose();
    phoneNumberController.dispose();
    emailController.dispose();
    nameFocusNode.dispose();
    surnameFocusNode.dispose();
    phoneNumberFocusNode.dispose();
    emailFocusNode.dispose();
    this.dispose();
  }
}

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/common/app_config.dart';
import '../../../core/common/text_formatters/iq_number_formatter.dart';
import '../../../core/common/view_model/base_view_model.dart';
import '../../../core/constants/enums/gender_enum.dart';
import '../../../services/api_cubit/api_cubit.dart';
import '../model/param/register_param.dart';
import '../view/register_view.dart';

class RegisterViewModel extends BaseViewModel<RegisterViewParam> {
  RegisterViewModel(super.param);

  final registerCubit = ApiCubit();
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final surameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final emailController = TextEditingController();

  final nameFocusNode = FocusNode();
  final surnameFocusNode = FocusNode();
  final phoneNumberFocusNode = FocusNode();
  final emailFocusNode = FocusNode();
  final cancelToken = CancelToken();

  DateTime? _dateOfBirth;
  GenderEnum? _gender;

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

  /// Methods
  void register() {
    unFocus();

    if (formKey.currentState!.validate()) {
      registerCubit.register(
        RegisterParam(
          name: nameController.text,
          surname: surameController.text,
          phoneNumber: IqNumberInputFormatter.getIraqMobileNumberWithZero(
              phoneNumberController.text),
          emailAddress:
              emailController.text.isEmpty ? null : emailController.text,
          dateOfBirth: _dateOfBirth,
          gender: gender,
          cancelToken: cancelToken,
        ),
      );
    }
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

  void unFocus() {
    nameFocusNode.unfocus();
    surnameFocusNode.unfocus();
    phoneNumberFocusNode.unfocus();
    emailFocusNode.unfocus();
  }

  @override
  void closeModel() {
    cancelToken.cancel();
    nameController.dispose();
    surameController.dispose();
    phoneNumberController.dispose();
    emailController.dispose();
    nameFocusNode.dispose();
    surnameFocusNode.dispose();
    phoneNumberFocusNode.dispose();
    emailFocusNode.dispose();
    registerCubit.close();
  }
}

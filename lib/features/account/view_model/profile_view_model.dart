import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:slim_starter_application/core/ui/widgets/restart_widget.dart';

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
import '../model/response/user_model.dart';
import '../view/profile_view.dart';
import '../view/widgets/change_phone_number_dialog.dart';

class ProfileViewModel extends BaseViewModel<ProfileViewParam> {
  ProfileViewModel(super.param) {
    // final profile = AppConfig().appContext?.read<SessionData>().profile;
    // if (profile != null) {
    //   nameController.text = profile.firstName;
    //   surnameController.text = profile.lastName;
    //   phoneNumberController.text = IqNumberInputFormatter()
    //       .getIraqMobileNumberAfterFormate(profile.phoneNumber.substring(1));
    //   emailController.text = profile.emailAddress;
    //   _gender = profile.gender;
    //   _dateOfBirth = profile.dateOfBirth;
    // }
    _init();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
  bool _isLoading = false;
  String? _errorMessage;
  User? _user;
  UserModel? _userData;
  StreamSubscription<DocumentSnapshot>? _userDataSubscription;
  bool _isObscurePassword = true;
  // Form controllers
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  // final formKey = GlobalKey<FormState>();

  // State variables
  bool _isAdmin = false;
  bool _isRegistrationComplete = false;

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get user => _user;
  UserModel? get userData => _userData;
  bool get isAdmin => _isAdmin;
  bool get isRegistrationComplete => _isRegistrationComplete;
  bool get isObscurePassword => _isObscurePassword;

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

  void _init() {
    // Check if user is already signed in
    _user = _auth.currentUser;

    if (_user != null) {
      _setupUserDataListener();
    }
  }

  void _setupUserDataListener() {
    // Listen for real-time updates to user data
    _userDataSubscription = _firestore
        .collection('pro_users')
        .doc(_user!.uid)
        .snapshots()
        .listen((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        _userData = UserModel.fromFirestore(snapshot);
        fullNameController.text = _userData!.fullName;
        _isAdmin = _userData!.isAdmin;
        phoneController.text = _userData!.phoneNumber ?? '';
        _isRegistrationComplete = true;
        _isLoading = false;
        notifyListeners();

        // // Navigate to home screen when profile is complete
        // _navigateToHomeIfProfileComplete();
      } else if (_user!.displayName != null) {
        // New user, pre-fill with Google data
        fullNameController.text = _user!.displayName!;
        _isRegistrationComplete = false;
        _isLoading = false;
        notifyListeners();
      } else {
        // No data and no display name
        _isLoading = false;
        notifyListeners();
      }
    }, onError: (error) {
      _errorMessage = 'Error loading user data: $error';
      _isLoading = false;
      notifyListeners();
    });
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

  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();

    try {
      _userDataSubscription?.cancel();
      await _auth.signOut();
      await _googleSignIn.signOut();

      _user = null;
      _isLoading = false;
      _isRegistrationComplete = false;
      _userData = null;
      fullNameController.clear();
      phoneController.clear();
      _isAdmin = false;

      RestartWidget.restartApp(AppConfig().appContext!);
      // notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Sign out failed: ${e.toString()}';
      notifyListeners();
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

  void setAdmin(bool value) {
    _isAdmin = value;
    notifyListeners();
  }

  void setRegistrationComplete(bool value) {
    _isRegistrationComplete = value;
    notifyListeners();
  }

  Future<void> updateUserData() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Update user data in Firestore
      await _firestore.collection('pro_users').doc(_user!.uid).update({
        'fullName': fullNameController.text.trim(),
        'isAdmin': _isAdmin,
        'phoneNumber': phoneController.text.trim().isEmpty
            ? null
            : phoneController.text.trim(),
        'lastUpdated': FieldValue.serverTimestamp(),
      });

      // Update local userData model with new values
      if (_userData != null) {
        _userData = _userData!.copyWith(
          fullName: fullNameController.text.trim(),
          isAdmin: _isAdmin,
          phoneNumber: phoneController.text.trim().isEmpty
              ? null
              : phoneController.text.trim(),
        );
      }

      _isRegistrationComplete = true;
      _isLoading = false;
      notifyListeners();

      // // Navigate to home after successful profile update
      // _navigateToHomeIfProfileComplete();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Update failed: ${e.toString()}';
      notifyListeners();
    }
  }

  Future<void> completeRegistration() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Create user model
      final newUser = UserModel(
        uid: _user!.uid,
        email: _user!.email!,
        fullName: fullNameController.text.trim(),
        isAdmin: _isAdmin,
        photoURL: _user!.photoURL,
        phoneNumber: phoneController.text.trim().isEmpty
            ? null
            : phoneController.text.trim(),
      );

      // Save user data to Firestore
      await _firestore.collection('pro_users').doc(_user!.uid).set({
        ...newUser.toMap(),
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      _isRegistrationComplete = true;
      _userData = newUser;
      _isLoading = false;
      notifyListeners();

     
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Registration failed: ${e.toString()}';
      notifyListeners();
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

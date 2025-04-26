import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import '../model/response/user_model.dart';
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
          // Listen to loading state changes
          final isLoading =
              context.select<ProfileViewModel, bool>((vm) => vm.isLoading);
          // Listen to registration complete state changes
          final isRegistrationComplete = context.select<ProfileViewModel, bool>(
              (vm) => vm.isRegistrationComplete);

          return ModalProgressHUD(
            inAsyncCall: isLoading,
            child: CustomScaffold(
              key: vm.scaffoldKey,
              appBar: AppBar(
                title: Text(
                  S.current.myProfile,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                // actions: [_buildDeleteAccountButton()],
              ),
              // Use isRegistrationComplete to conditionally show the appropriate screen
              body: isRegistrationComplete
                  ? _buildUserInfoScreen(context)
                  : _buildRegistrationForm(context),
            ),
          );
        },
      ),
    );
  }

  Widget _infoTile(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 0.4.sw,
            child: Text(title, style: Theme.of(context).textTheme.bodySmall),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  Widget _buildUserInfoScreen(BuildContext context) {
    // Get specific data without rebuilding the entire widget
    final viewModel = Provider.of<ProfileViewModel>(context, listen: false);
    final user = context.select<ProfileViewModel, User?>((vm) => vm.user);
    final userData =
        context.select<ProfileViewModel, UserModel?>((vm) => vm.userData);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  if (user?.photoURL != null)
                    CircleAvatar(
                      backgroundImage: NetworkImage(user!.photoURL!),
                      radius: 60,
                    )
                  else
                    const CircleAvatar(
                      backgroundImage:
                          AssetImage(AppConstants.AVATAR_PLACEHOLDER),
                      radius: 60,
                    ),
                  const SizedBox(height: 20),
                  Text(
                    userData?.fullName ?? S.current.user,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    userData?.email ?? '',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Text(
              S.current.accountInformation,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            _infoTile(
              S.current.role,
              userData?.isAdmin == true
                  ? S.current.admin
                  : S.current.regularUser,
            ),
            if (userData?.phoneNumber != null)
              _infoTile(S.current.phone, userData!.phoneNumber!),
            if (userData?.createdAt != null)
              _infoTile(S.current.createdAt, _formatDate(userData!.createdAt!)),
            if (userData?.lastUpdated != null)
              _infoTile(
                  S.current.lastUpdated, _formatDate(userData!.lastUpdated!)),
            const SizedBox(height: 30),
            Center(
              child: Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      viewModel.setRegistrationComplete(false);
                    },
                    icon: const Icon(Icons.edit),
                    label: Text(S.current.editProfile),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(200, 45),
                    ),
                  ),
                  const SizedBox(height: 15),
                  OutlinedButton.icon(
                    onPressed: viewModel.signOut,
                    icon: const Icon(Icons.logout),
                    label: Text(S.current.signOut),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(200, 45),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegistrationForm(BuildContext context) {
    // Get specific data without rebuilding the entire widget
    final viewModel = Provider.of<ProfileViewModel>(context, listen: false);
    final user = context.select<ProfileViewModel, User?>((vm) => vm.user);
    final userData =
        context.select<ProfileViewModel, UserModel?>((vm) => vm.userData);
    final errorMessage =
        context.select<ProfileViewModel, String?>((vm) => vm.errorMessage);
    final isAdmin = context.select<ProfileViewModel, bool>((vm) => vm.isAdmin);

    final bool isNewUser = userData == null;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: viewModel.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Column(
                  children: [
                    if (user?.photoURL != null)
                      CircleAvatar(
                        backgroundImage: NetworkImage(user!.photoURL!),
                        radius: 60,
                      ),
                    const SizedBox(height: 20),
                    Text(
                      isNewUser
                          ? S.current.completeRegister
                          : S.current.editProfile,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      user?.email ?? '',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              if (errorMessage != null)
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.red),
                  ),
                  child: Text(
                    errorMessage,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),
              const SizedBox(height: 15),
              TextFormField(
                controller: viewModel.fullNameController,
                decoration: InputDecoration(
                  labelText: S.current.name,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.person),
                ),
                validator: (value) {
                  if (!Validators.isValidFullName(value)) {
                    return S.current.invalidName;
                  } else
                    return null;
                },
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: viewModel.phoneController,
                decoration: InputDecoration(
                  labelText: '${S.current.phone} (${S.current.optional})',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value != null &&
                      value.isNotEmpty &&
                      !Validators.isValidPhoneNumber(value)) {
                    return S.current.invalidPhoneNumber;
                  } else
                    return null;
                },
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 15),
              ListTile(
                title: Text(S.current.admin),
                subtitle: Text(S.current.GrandAdminPrevilegesToThisAccount),
                leading: const Icon(Icons.admin_panel_settings),
                trailing: Switch(
                  value: isAdmin,
                  onChanged: viewModel.setAdmin,
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: isNewUser
                    ? viewModel.completeRegistration
                    : viewModel.updateUserData,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  isNewUser
                      ? S.current.completeRegister
                      : S.current.editProfile,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 15),
              TextButton(
                onPressed: isNewUser
                    ? viewModel.signOut
                    : () {
                        viewModel.setRegistrationComplete(true);
                      },
                child: Text(
                    isNewUser ? S.current.cancelAndSignOut : S.current.cancel),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNawmeField() {
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
}

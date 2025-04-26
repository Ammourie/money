import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:slim_starter_application/core/constants/app/app_constants.dart';

import '../../../core/ui/screens/base_view.dart';
import '../../../features/account/view_model/auth_view_model.dart';
import '../../../generated/l10n.dart';

class AuthViewParam {}

class AuthView extends BaseView<AuthViewParam> {
  const AuthView({required AuthViewParam param, Key? key})
      : super(param: param, key: key);
  static const routeName = "/AuthView";
  @override
  _AuthViewState createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  late final AuthViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = AuthViewModel(widget.param);
    _viewModel.init();
  }

  @override
  void dispose() {
    _viewModel.closeModel();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
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

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Consumer<AuthViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                S.current.userRegisteration,
                style: Theme.of(context).textTheme.displaySmall,
              ),
              actions:
                  viewModel.user != null && viewModel.isRegistrationComplete
                      ? [
                          IconButton(
                            icon: const Icon(Icons.exit_to_app),
                            onPressed: viewModel.signOut,
                            tooltip: S.current.signOut,
                          ),
                        ]
                      : null,
            ),
            body: viewModel.isLoading
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 16),
                        Text(S.current.pleaseWait),
                      ],
                    ),
                  )
                : viewModel.user != null
                    ? viewModel.isRegistrationComplete
                        ? _buildUserInfoScreen()
                        : _buildRegistrationForm()
                    : _buildSignInScreen(),
          );
        },
      ),
    );
  }

  Widget _buildUserInfoScreen() {
    return Consumer<AuthViewModel>(
      builder: (context, viewModel, child) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      if (viewModel.user?.photoURL != null)
                        CircleAvatar(
                          backgroundImage:
                              NetworkImage(viewModel.user!.photoURL!),
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
                        viewModel.userData?.fullName ?? S.current.user,
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        viewModel.userData?.email ?? '',
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
                  viewModel.userData?.isAdmin == true
                      ? S.current.admin
                      : S.current.regularUser,
                ),
                if (viewModel.userData?.phoneNumber != null)
                  _infoTile(S.current.phone, viewModel.userData!.phoneNumber!),
                if (viewModel.userData?.createdAt != null)
                  _infoTile(S.current.createdAt,
                      _formatDate(viewModel.userData!.createdAt!)),
                if (viewModel.userData?.lastUpdated != null)
                  _infoTile(S.current.lastUpdated,
                      _formatDate(viewModel.userData!.lastUpdated!)),
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
      },
    );
  }

  Widget _buildRegistrationForm() {
    return Consumer<AuthViewModel>(
      builder: (context, viewModel, child) {
        final bool isNewUser = viewModel.userData == null;

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
                        if (viewModel.user?.photoURL != null)
                          CircleAvatar(
                            backgroundImage:
                                NetworkImage(viewModel.user!.photoURL!),
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
                          viewModel.user?.email ?? '',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  if (viewModel.errorMessage != null)
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.red),
                      ),
                      child: Text(
                        viewModel.errorMessage!,
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
                    validator: viewModel.validateFullName,
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
                    validator: viewModel.validatePhone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 15),
                  // DropdownButtonFormField<String>(
                  //   value: viewModel.departmentController.text.isEmpty
                  //       ? null
                  //       : viewModel.departmentController.text,
                  //   decoration: InputDecoration(
                  //     labelText: 'Department (Optional)',
                  //     border: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(10),
                  //     ),
                  //     prefixIcon: const Icon(Icons.business),
                  //   ),
                  //   items: viewModel.departments.map((String department) {
                  //     return DropdownMenuItem<String>(
                  //       value: department,
                  //       child: Text(department),
                  //     );
                  //   }).toList(),
                  //   onChanged: (String? newValue) {
                  //     if (newValue != null) {
                  //       viewModel.departmentController.text = newValue;
                  //     }
                  //   },
                  // ),
                  // const SizedBox(height: 20),
                  ListTile(
                    title: Text(S.current.admin),
                    subtitle: Text(S.current.GrandAdminPrevilegesToThisAccount),
                    leading: const Icon(Icons.admin_panel_settings),
                    trailing: Switch(
                      value: viewModel.isAdmin,
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
                    child: Text(isNewUser
                        ? S.current.cancelAndSignOut
                        : S.current.cancel),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSignInScreen() {
    return Consumer<AuthViewModel>(
      builder: (context, viewModel, child) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.account_circle,
                  size: 100,
                  color: Colors.blue,
                ),
                const SizedBox(height: 30),
                Text(
                  S.current.welcome,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  S.current.signInToContinueToTheApplication,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                if (viewModel.errorMessage != null)
                  Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.red),
                    ),
                    child: Text(
                      viewModel.errorMessage!,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ElevatedButton.icon(
                  icon: Image.network(
                    AppConstants.google_Icon,
                    height: 24.0,
                  ),
                  label: Text(S.current.signInWithGoogle),
                  onPressed: viewModel.signInWithGoogle,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                // const SizedBox(height: 20),
                // TextButton(
                //   onPressed: () {
                //     // TODO: Implement other authentication methods if needed
                //   },
                //   child: const Text('Other Sign In Options'),
                // ),
              ],
            ),
          ),
        );
      },
    );
  }
}

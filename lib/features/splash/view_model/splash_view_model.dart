import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:slim_starter_application/core/common/app_config.dart';
import 'package:slim_starter_application/features/account/model/response/user_model.dart';

import '../../../core/common/view_model/base_view_model.dart';
import '../../../core/constants/app/app_settings.dart';
import '../../../core/navigation/nav.dart';
import '../../../core/providers/session_data.dart';
import '../../../core/ui/custom_map/logic/location_wrapper.dart';
import '../../../core/ui/dialogs/update_app_dialog.dart';
import '../../../services/api_cubit/api_cubit.dart';
import '../../account/view/auth_view.dart';
import '../../home/model/response/home_init_model.dart';
import '../../home/view/app_main_view.dart';
import '../view/splash_view.dart';

class SplashViewModel extends BaseViewModel<SplashViewParam> {
  SplashViewModel(super.param);
  bool canGo = true;
  HomeInitModel? homeInit;

  final splashCubit = ApiCubit();

  /// methods
  void getSplash() {
    splashCubit.getSplash();
  }

  void outFromSplash() async {
    final isForce = AppSettings.forceLocationPermission;
    if (isForce) {
      await LocationWrapper.singleton()
          .checkLocationPermissions(isForce: isForce);
    }

    handleNavigation();
  }

  void handleNavigation() async {
    // if (LocalStorage.hasToken) {
    //   Nav.off(AppMainView.routeName, arguments: AppMainViewParam());
    // } else {
    //   Nav.off(
    //     AuthView.routeName,
    //     arguments: AuthViewParam(),
    //   );
    //   // Nav.off(
    //   //   LoginView.routeName,
    //   //   arguments: LoginViewParam(),
    //   // );
    // }

    final FirebaseAuth _auth = FirebaseAuth.instance;
    final _user = _auth.currentUser;
    if (_user == null) {
      Nav.off(
        AuthView.routeName,
        arguments: AuthViewParam(),
      );
    } else {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      _firestore
          .collection('pro_users')
          .doc(_user.uid)
          .get()
          .then((DocumentSnapshot snapshot) {
        if (snapshot.exists) {
          AppConfig().appContext!.read<SessionData>().user =
              UserModel.fromFirestore(snapshot);
          Nav.off(
            AppMainView.routeName,
            arguments: AppMainViewParam(),
          );
        } else
          Nav.off(
            AuthView.routeName,
            arguments: AuthViewParam(),
          );
      });
    }

    // Check if there is a new version.
    if (homeInit?.needUpdate ?? false) {
      showUpdateAppDialog(
        homeInit!.forceUpdate,
        homeInit!.appVersionUrl ?? '',
      );
    }
  }

  @override
  void closeModel() {
    splashCubit.close();
    this.dispose();
  }
}

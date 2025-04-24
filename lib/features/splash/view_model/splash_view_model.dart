import '../../../core/common/local_storage.dart';
import '../../../core/common/view_model/base_view_model.dart';
import '../../../core/constants/app/app_settings.dart';
import '../../../core/navigation/nav.dart';
import '../../../core/ui/custom_map/logic/location_wrapper.dart';
import '../../../core/ui/dialogs/update_app_dialog.dart';
import '../../../services/api_cubit/api_cubit.dart';
import '../../account/view/auth_view.dart';
import '../../home/model/response/home_init_model.dart';
import '../../home/view/app_main_view.dart';
import '../view/splash_view.dart';

class SplashViewModel extends BaseViewModel<SplashViewParam> {
  SplashViewModel(super.param);
  bool canGo = false;
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
    if (LocalStorage.hasToken) {
      Nav.off(AppMainView.routeName, arguments: AppMainViewParam());
    } else {
      Nav.off(
        AuthView.routeName,
        arguments: AuthViewParam(),
      );
      // Nav.off(
      //   LoginView.routeName,
      //   arguments: LoginViewParam(),
      // );
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

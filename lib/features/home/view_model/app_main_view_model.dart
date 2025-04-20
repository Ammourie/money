import 'package:slim_starter_application/services/api_cubit/api_cubit.dart';

import '../../../core/common/view_model/base_view_model.dart';
import '../view/app_main_view.dart';

class AppMainViewModel extends BaseViewModel<AppMainViewParam> {
  AppMainViewModel(super.param);

  final logoutCubit = ApiCubit();

  // Methods
  void logout() {
    logoutCubit.logout();
  }

  @override
  void closeModel() {
    logoutCubit.close();
    this.dispose();
  }
}

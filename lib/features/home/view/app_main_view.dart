import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../core/constants/app/app_settings.dart';
import '../../../core/firebase/firebase_messaging.dart';
import '../../../core/ui/error_ui/error_viewer/error_viewer.dart';
import '../../../core/ui/screens/base_view.dart';
import '../../../core/ui/widgets/system/double_tap_back_exit_app.dart';
import '../../../services/api_cubit/api_cubit.dart';
import '../view_model/app_main_view_model.dart';
import 'home_view.dart';

class AppMainViewParam {}

class AppMainView extends BaseView<AppMainViewParam> {
  const AppMainView({super.key, required super.param});

  static const String routeName = "/AppMainView";

  @override
  State<AppMainView> createState() => _AppMainViewState();
}

class _AppMainViewState extends State<AppMainView> {
  late final AppMainViewModel vm;

  @override
  void initState() {
    super.initState();
    vm = context.read<AppMainViewModel>();

    if (AppSettings.enableNotifications &&
        FireBaseMessagingWrapper.notificationLock.isLocked)
      FireBaseMessagingWrapper.notificationLock.release();
  }

  @override
  Widget build(BuildContext context) {
    context.select<AppMainViewModel, bool>((p) => p.isLoading);

    return DoubleTapBackExitApp(
      child: ModalProgressHUD(
        inAsyncCall: vm.isLoading,
        child: BlocListener<ApiCubit, ApiState>(
          bloc: vm.logoutCubit,
          listener: (context, state) {
            state.maybeWhen(
              loading: () => vm.isLoading = true,
              error: (error, callback) {
                vm.isLoading = false;
                ErrorViewer.showError(
                    context: context, error: error, callback: callback);
              },
              successLogout: () {},
              orElse: () {},
            );
          },
          child: HomeView(param: HomeViewParam()),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

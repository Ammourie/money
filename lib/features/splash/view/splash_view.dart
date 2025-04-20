import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app/app_constants.dart';
import '../../../core/errors/app_errors.dart';
import '../../../core/providers/session_data.dart';
import '../../../core/ui/error_ui/error_viewer/dialog/errv_dialog_options.dart';
import '../../../core/ui/error_ui/error_viewer/error_viewer.dart';
import '../../../core/ui/screens/base_view.dart';
import '../../../core/ui/widgets/custom_scaffold.dart';
import '../../../generated/l10n.dart';
import '../../../services/api_cubit/api_cubit.dart';
import '../model/response/splash_model.dart';
import '../view_model/splash_view_model.dart';

class SplashViewParam {}

class SplashView extends BaseView<SplashViewParam> {
  const SplashView({super.key, required SplashViewParam param})
      : super(param: param);

  static const String routeName = "/SplashView";

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  late SplashViewModel vm;

  @override
  void initState() {
    super.initState();
    vm = SplashViewModel(widget.param);
    vm.getSplash();

    Future.delayed(const Duration(seconds: 4), () {
      if (vm.canGo) {
        vm.outFromSplash();
      } else {
        vm.canGo = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: vm,
      builder: (context, child) {
        return BlocListener<ApiCubit, ApiState>(
          bloc: vm.splashCubit,
          listener: (context, state) {
            state.maybeWhen(
              initial: () {},
              loading: () {},
              splashLoaded: _splashScreenLoaded,
              error: _handleSplashError,
              orElse: () {},
            );
          },
          child: _buildContent(),
        );
      },
    );
  }

  Widget _buildContent() {
    return CustomScaffold(
      body: SizedBox(
        width: 1.sw,
        height: 1.sh,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AppConstants.APP_LOGO,
              width: 150,
              height: 150,
            ),
            32.verticalSpace,
            const CircularProgressIndicator(strokeWidth: 2.5),
          ],
        ),
      ),
    );
  }

  void _splashScreenLoaded(SplashModel splashModel) async {
    vm.homeInit = splashModel.homeInit;
    context.read<SessionData>().profile = splashModel.profile;
    context.read<SessionData>().homeInit = splashModel.homeInit;

    if (vm.canGo) {
      vm.outFromSplash();
    } else {
      vm.canGo = true;
    }
  }

  void _handleSplashError(AppErrors error, VoidCallback callback) {
    ErrorViewer.showError(
      context: context,
      error: error,
      callback: callback,
      errorViewerOptions: ErrVDialogOptions(
        isDismissible: false,
        cancelOptions: ErrVButtonOptions(
          buttonText: S.current.closeApp,
          onBtnPressed: (context) {
            SystemNavigator.pop();
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    vm.closeModel();
  }
}

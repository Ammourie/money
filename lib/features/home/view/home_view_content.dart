import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

import '../../../../core/ui/clippers/theme_circle_clipper.dart';
import '../../../../generated/l10n.dart';
import '../../../core/ui/error_ui/error_viewer/error_viewer.dart';
import '../../../core/ui/widgets/custom_scaffold.dart';
import '../../../core/ui/widgets/custom_switch.dart';
import '../../../services/api_cubit/api_cubit.dart';
import '../view_model/home_view_model.dart';

class HomeViewContent extends StatefulWidget {
  const HomeViewContent({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeViewContent> createState() => _HomeViewContentState();
}

class _HomeViewContentState extends State<HomeViewContent> {
  late HomeViewModel vm;

  @override
  Widget build(BuildContext context) {
    vm = context.read<HomeViewModel>();

    return BlocListener<ApiCubit, ApiState>(
      bloc: vm.apiCubit,
      listener: (context, state) {
        state.maybeWhen(
          loading: () => vm.isLoading = true,
          error: (error, callback) {
            vm.isLoading = false;
            ErrorViewer.showError(
              context: context,
              error: error,
              callback: callback,
            );
          },
          successChangeNotificationStatus: () {
            vm.isLoading = false;
            vm.notificationStatus = !vm.notificationStatus;
          },
          orElse: () {},
        );
      },
      child: ThemeSwitchingArea(
        child: Theme(
          data: Theme.of(context),
          child: Consumer<HomeViewModel>(
            builder: (context, model, child) {
              return ModalProgressHUD(
                inAsyncCall: model.isLoading,
                child: _buildHomeScreen(context),
              );
            },
          ),
        ),
      ),
    );
  }

  CustomScaffold _buildHomeScreen(BuildContext context) {
    return CustomScaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(S.of(context).homePage),
      ),
      body: _buildHomeScreenBody(context),
      drawer: _drawerList(context),
    );
  }

  Padding _buildHomeScreenBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          24.verticalSpace,
          const Text("Translation test"),
          10.verticalSpace,
          Text(S.of(context).welcome),
        ],
      ),
    );
  }

  Drawer _drawerList(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewPadding.bottom,
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: Align(
                  alignment: AlignmentDirectional.topEnd,
                  child: _themeSwitcher(),
                ),
              ),
            ),
            ListTile(
              title: Text(
                S.of(context).changeLanguage,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              onTap: () {
                provider(context, listen: false)
                    .onChangeLanguageDialogTap(context);
              },
              trailing: const Icon(Icons.language),
            ),
            const Divider(),
            ListTile(
              title: Text(
                S.current.myProfile,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              onTap: () => context.read<HomeViewModel>().onMyProfileTap(),
              trailing: const Icon(Icons.person_outline),
            ),
            const Divider(),
            ListTile(
              title: Text(
                S.current.notifications,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              onTap: () => context.read<HomeViewModel>().onNotificationsTap(),
              trailing: const Icon(Icons.notifications_outlined),
            ),
            const Divider(),
            ListTile(
              title: Text(
                S.current.changeNotificationStatus,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              onTap: () =>
                  context.read<HomeViewModel>().onChangeNotificationStatus(),
              trailing: Builder(builder: (context) {
                context
                    .select<HomeViewModel, bool>((p) => p.notificationStatus);

                return SizedBox(
                  width: 120.w,
                  child: FittedBox(
                    child: CustomSwitch(
                      value: vm.notificationStatus,
                      activeColor: Colors.blue,
                      inactiveColor: Colors.grey.shade400,
                    ),
                  ),
                );
              }),
            ),
            const Divider(),
            ListTile(
              title: Text(
                S.current.aboutUs,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              onTap: () => context.read<HomeViewModel>().onAboutUsTap(),
            ),
            const Divider(),
            ListTile(
              title: Text(
                S.current.contactUs,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              onTap: () => context.read<HomeViewModel>().onContactUsTap(),
            ),
            const Divider(),
            ListTile(
              title: Text(
                S.current.faqs,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              onTap: () => context.read<HomeViewModel>().onFaqsTap(),
            ),
            const Divider(),
            ListTile(
              title: Text(
                S.current.termsAndConditions,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              onTap: () =>
                  context.read<HomeViewModel>().onTermsAndConditionsTap(),
            ),
            const Divider(),
            ListTile(
              title: Text(
                S.current.privacyPolicy,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              onTap: () => context.read<HomeViewModel>().onPrivacyPolicyTap(),
            ),
            const Divider(),
            ListTile(
              title: Text(
                S.current.myTickets,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              onTap: () => context.read<HomeViewModel>().onMyTicketsTap(),
              trailing: const Icon(Icons.tab),
            ),
            const Divider(),
            ListTile(
              title: Text(
                S.current.blogs,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              onTap: () => context.read<HomeViewModel>().onBlogsTap(),
              trailing: const Icon(Icons.filter_frames),
            ),
            const Divider(),
            ListTile(
              title: Text(
                S.of(context).logOut,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              onTap: () =>
                  provider(context, listen: false).onLogoutTap(context),
              trailing: const Icon(Icons.logout),
            ),
          ],
        ),
      ),
    );
  }

  Widget _themeSwitcher() {
    return ThemeSwitcher(
      clipper: const CustomThemeSwitcherCircleClipper(),
      builder: (context) {
        return IconButton(
          icon: Icon(
            provider(context, listen: false).getThemeIcon(context),
          ),
          onPressed: () {
            provider(context, listen: false).onThemeSwitcherTap(context);
          },
        );
      },
    );
  }

  HomeViewModel provider(BuildContext context, {bool listen = true}) =>
      Provider.of<HomeViewModel>(context, listen: listen);
}

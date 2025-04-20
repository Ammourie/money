import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/view_model/base_view_model.dart';
import '../../../../core/ui/dialogs/language_dialog.dart';
import '../../../core/common/app_config.dart';
import '../../../core/common/utils/utils.dart';
import '../../../core/navigation/nav.dart';
import '../../../core/providers/session_data.dart';
import '../../../core/ui/dialogs/confirm_dialog.dart';
import '../../../services/api_cubit/api_cubit.dart';
import '../../account/view/profile_view.dart';
import '../../blog/view/blog_list_view.dart';
import '../../more/view/about_us_view.dart';
import '../../more/view/contact_us_view.dart';
import '../../more/view/faqs_view.dart';
import '../../more/view/privacy_policy_view.dart';
import '../../more/view/terms_and_conditions_view.dart';
import '../../notification/model/param/change_notification_status_param.dart';
import '../../notification/view/notification_list_view.dart';
import '../../tickets/view/ticket_list_view.dart';
import '../view/home_view.dart';
import 'app_main_view_model.dart';

class HomeViewModel extends BaseViewModel<HomeViewParam> {
  HomeViewModel(super.param) {
    final context = AppConfig().appContext;
    _notificationStatus =
        context?.read<SessionData>().profile?.isNotificationOn ?? false;
  }
  final apiCubit = ApiCubit();
  late bool _notificationStatus;

  bool get notificationStatus => _notificationStatus;
  set notificationStatus(bool v) {
    if (_notificationStatus == v) return;

    _notificationStatus = v;
    if (hasListeners) notifyListeners();
  }

  /// Methods
  void onLogoutTap(BuildContext context) {
    showConfirmDialog(onConfirmTap: () {
      context.read<AppMainViewModel>().logout();
    });
  }

  void onAboutUsTap() {
    Nav.to(AboutUsView.routeName, arguments: AboutUsViewParam());
  }

  void onContactUsTap() {
    Nav.to(ContactUsView.routeName, arguments: ContactUsViewParam());
  }

  void onNotificationsTap() {
    Nav.to(NotificationListView.routeName,
        arguments: NotificationListViewParam());
  }

  void onChangeNotificationStatus() {
    apiCubit.changeNotificationStatus(
      ChangeNotificationStatusParam(
        status: !notificationStatus,
      ),
    );
  }

  void onFaqsTap() {
    Nav.to(FaqsView.routeName, arguments: FaqsViewParam());
  }

  void onMyTicketsTap() {
    Nav.to(TicketListView.routeName, arguments: TicketListViewParam());
  }

  void onBlogsTap() {
    Nav.to(BlogListView.routeName, arguments: BlogListViewParam());
  }

  void onMyProfileTap() {
    Nav.to(ProfileView.routeName, arguments: ProfileViewParam());
  }

  void onTermsAndConditionsTap() {
    Nav.to(TermsAndConditionsView.routeName,
        arguments: TermsAndConditionsViewParam());
  }

  void onPrivacyPolicyTap() {
    Nav.to(PrivacyPolicyView.routeName, arguments: PrivacyPolicyViewParam());
  }

  void onChangeLanguageDialogTap(BuildContext context) {
    showLanguageDialog(
      context: context,
    );
  }

  void onThemeSwitcherTap(BuildContext context) {
    Utils.changeTheme(context);
  }

  IconData getThemeIcon(BuildContext context) {
    return (Theme.of(context).brightness) == Brightness.light
        ? Icons.nightlight_round_outlined
        : Icons.wb_sunny_outlined;
  }

  @override
  void closeModel() {
    apiCubit.close();
  }
}

import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:slim_starter_application/features/blog/view/blog_list_view.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

import '../../di/service_locator.dart';
import '../../features/account/view/login_view.dart';
import '../../features/account/view/profile_view.dart';
import '../../features/account/view/register_view.dart';
import '../../features/blog/view/blog_details_view.dart';
import '../../features/home/view/app_main_view.dart';
import '../../features/home/view/home_view.dart';
import '../../features/more/view/about_us_view.dart';
import '../../features/more/view/contact_us_view.dart';
import '../../features/more/view/faqs_view.dart';
import '../../features/more/view/privacy_policy_view.dart';
import '../../features/more/view/terms_and_conditions_view.dart';
import '../../features/notification/view/notification_list_view.dart';
import '../../features/tickets/view/ticket_details_view.dart';
import '../../features/tickets/view/ticket_list_view.dart';
import '../constants/enums/route_type.dart';
import '../ui/screens/base_view.dart';
import 'animations/animated_route.dart';
import 'animations/fade_route.dart';
import 'navigation_service.dart';

@lazySingleton
class NavigationRoute {
  Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    // final args = settings.arguments;

    switch (settings.name) {
      case LoginView.routeName:
        return _getRoute<LoginViewParam>(
          settings: settings,
          createScreen: (param) => LoginView(param: param),
        );
      case RegisterView.routeName:
        return _getRoute<RegisterViewParam>(
          type: RouteType.ANIMATED,
          settings: settings,
          createScreen: (param) => RegisterView(param: param),
        );
      case AppMainView.routeName:
        return _getRoute<AppMainViewParam>(
          settings: settings,
          createScreen: (param) => AppMainView(param: param),
        );
      case HomeView.routeName:
        return _getRoute<HomeViewParam>(
          settings: settings,
          createScreen: (param) => HomeView(param: param),
        );

      case AboutUsView.routeName:
        return _getRoute<AboutUsViewParam>(
          settings: settings,
          createScreen: (param) => AboutUsView(param: param),
        );
      case ContactUsView.routeName:
        return _getRoute<ContactUsViewParam>(
          settings: settings,
          createScreen: (param) => ContactUsView(param: param),
        );
      case NotificationListView.routeName:
        return _getRoute<NotificationListViewParam>(
          settings: settings,
          createScreen: (param) => NotificationListView(param: param),
        );
      case FaqsView.routeName:
        return _getRoute<FaqsViewParam>(
          settings: settings,
          createScreen: (param) => FaqsView(param: param),
        );
      case TicketListView.routeName:
        return _getRoute<TicketListViewParam>(
          settings: settings,
          createScreen: (param) => TicketListView(param: param),
        );
      case TicketDetailsView.routeName:
        return _getRoute<TicketDetailsViewParam>(
          settings: settings,
          createScreen: (param) => TicketDetailsView(param: param),
        );
      case BlogListView.routeName:
        return _getRoute<BlogListViewParam>(
          settings: settings,
          createScreen: (param) => BlogListView(param: param),
        );
      case BlogDetailsView.routeName:
        return _getRoute<BlogDetailsViewParam>(
          settings: settings,
          createScreen: (param) => BlogDetailsView(param: param),
        );
      case ProfileView.routeName:
        return _getRoute<ProfileViewParam>(
          settings: settings,
          createScreen: (param) => ProfileView(param: param),
        );
      case TermsAndConditionsView.routeName:
        return _getRoute<TermsAndConditionsViewParam>(
          settings: settings,
          createScreen: (param) => TermsAndConditionsView(param: param),
        );
      case PrivacyPolicyView.routeName:
        return _getRoute<PrivacyPolicyViewParam>(
          settings: settings,
          createScreen: (param) => PrivacyPolicyView(param: param),
        );
      default:
        // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute();
    }
  }

  Route _getRoute<ParamType>({
    required RouteSettings settings,
    required BaseView createScreen(
      ParamType param,
    ),
    RouteType type = RouteType.FADE,
  }) {
    try {
      final args = settings.arguments;
      if (args != null && args is ParamType) {
        switch (type) {
          case RouteType.FADE:
            return FadeRoute(
              page: createScreen(
                args as ParamType,
              ),
              settings: settings,
            );
          case RouteType.ANIMATED:
            return AnimatedRoute(
              page: createScreen(
                args as ParamType,
              ),
              settings: settings,
            );
          case RouteType.SWIPABLE:
            return SwipeablePageRoute(
              canOnlySwipeFromEdge: true,
              builder: (context) {
                return createScreen(args as ParamType);
              },
              settings: settings,
            );
        }
      }
    } catch (e) {
      return _errorRoute();
    }

    return _errorRoute(argumentError: true);
  }

  Route<dynamic> _errorRoute({bool argumentError = false}) {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          backgroundColor: Theme.of(
                  getIt<NavigationService>().getNavigationKey.currentContext!)
              .scaffoldBackgroundColor,
          appBar: AppBar(title: const Text('Error')),
          body: Center(
            child: Text(
              argumentError
                  ? 'ROUTE ERROR CHECK ARGUMENT THAT PASSED TO THIS SCREEN.'
                  : 'ROUTE ERROR CHECK THE ROUTE GENERATOR.',
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }
}

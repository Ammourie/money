import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:slim_starter_application/features/blog/model/response/blog_model.dart';

import '../../core/common/app_config.dart';
import '../../core/common/local_storage.dart';
import '../../core/common/utils/cubit_utils.dart';
import '../../core/constants/shared_preference/shared_preference_keys.dart';
import '../../core/errors/app_errors.dart';
import '../../core/firebase/firebase_messaging.dart';
import '../../core/params/id_param.dart';
import '../../core/params/no_params.dart';
import '../../core/params/page_param.dart';
import '../../core/results/result.dart';
import '../../core/ui/widgets/restart_widget.dart';
import '../../di/service_locator.dart';
import '../../features/account/model/param/confirm_code_param.dart';
import '../../features/account/model/param/confirm_delete_my_account_param.dart';
import '../../features/account/model/param/confirm_new_phone_number_param.dart';
import '../../features/account/model/param/get_profile_param.dart';
import '../../features/account/model/param/login_param.dart';
import '../../features/account/model/param/register_param.dart';
import '../../features/account/model/param/resend_code_param.dart';
import '../../features/account/model/param/update_profile_param.dart';
import '../../features/account/model/response/confirm_code_model.dart';
import '../../features/account/model/response/login_model.dart';
import '../../features/account/model/response/profile_model.dart';
import '../../features/account/model/response/register_model.dart';
import '../../features/blog/model/response/blog_list_model.dart';
import '../../features/home/model/param/home_init_param.dart';
import '../../features/home/model/response/home_init_model.dart';
import '../../features/more/model/param/report_problem_param.dart';
import '../../features/more/model/response/faq_section_list_model.dart';
import '../../features/notification/model/param/add_or_update_firebase_token_param.dart';
import '../../features/notification/model/param/change_notification_status_param.dart';
import '../../features/notification/model/param/notification_list_param.dart';
import '../../features/notification/model/response/notification_list_model.dart';
import '../../features/splash/model/response/splash_model.dart';
import '../../features/tickets/model/param/create_ticket_params.dart';
import '../../features/tickets/model/response/ticket_list_model.dart';
import '../../features/tickets/model/response/ticket_model.dart';
import '../api.dart';

part 'api_cubit.freezed.dart';
part 'api_state.dart';

class ApiCubit extends Cubit<ApiState> {
  ApiCubit() : super(const ApiState.initial());

  void login(LoginParam param) async {
    emit(const ApiState.loading());
    final result = await getIt<Api>().login(param);

    result.pick(
      onData: (data) {
        emit(ApiState.loginLoaded(data: data));
      },
      onError: (error) {
        emit(ApiState.error(error, () => login(param)));
      },
    );
  }

  void register(RegisterParam param) async {
    emit(const ApiState.loading());
    final result = await getIt<Api>().register(param);

    result.pick(
      onData: (data) {
        emit(ApiState.registerLoaded(data: data));
      },
      onError: (error) {
        emit(ApiState.error(error, () => register(param)));
      },
    );
  }

  void getProfile(GetProfileParam param) async {
    emit(const ApiState.loading());
    final result = await getIt<Api>().getProfile(param);

    result.pick(
      onData: (data) {
        emit(ApiState.profileLoaded(data: data));
      },
      onError: (error) {
        emit(ApiState.error(error, () => getProfile(param)));
      },
    );
  }

  void addOrUpdateFirebaseToken(AddOrUpdateFirebaseTokenParam param) async {
    emit(const ApiState.loading());
    final result = await getIt<Api>().addOrUpdateFirebaseToken(param);

    result.pick(
      onData: (data) {
        emit(const ApiState.successAddOrUpdateFirebaseToken());
      },
      onError: (error) {
        emit(ApiState.error(error, () => addOrUpdateFirebaseToken(param)));
      },
    );
  }

  void getNotificationList(NotificationListParam param) async {
    emit(const ApiState.loading());
    final result = await getIt<Api>().getNotifications(param);

    result.pick(
      onData: (data) {
        emit(ApiState.notificationListLoaded(data: data));
      },
      onError: (error) {
        emit(ApiState.error(error, () => getNotificationList(param)));
      },
    );
  }

  void changeNotificationStatus(ChangeNotificationStatusParam param) async {
    emit(const ApiState.loading());

    final result = await getIt<Api>().changeNotificationStatus(param);

    result.pick(
      onData: (data) {
        emit(const ApiState.successChangeNotificationStatus());
      },
      onError: (error) {
        emit(ApiState.error(error, () => changeNotificationStatus(param)));
      },
    );
  }

  void reportProblem(ReportProblemParam params) async {
    emit(const ApiState.loading());
    final result = await getIt<Api>().reportProblem(params);

    result.pick(
      onData: (data) {
        emit(const ApiState.successReportProblem());
      },
      onError: (error) {
        emit(ApiState.error(error, () => reportProblem(params)));
      },
    );
  }

  void getFaqs(PageParam param) async {
    emit(const ApiState.loading());

    final result = await getIt<Api>().getFaqs(param);

    result.pick(
      onData: (data) {
        emit(ApiState.faqsLoaded(data: data));
      },
      onError: (error) {
        emit(ApiState.error(error, () => getFaqs(param)));
      },
    );
  }

  void getSplash() async {
    emit(const ApiState.loading());

    final List<Result> results = await Future.wait([
      // Send FCM token.
      getIt<Api>().addOrUpdateFirebaseToken(
        FireBaseMessagingWrapper.getUpdateTokenParam(),
      ),

      // Home init
      getIt<Api>().homeInit(
        HomeInitParam(deviceId: AppConfig().deviceId),
      ),

      if (LocalStorage.hasToken) ...[
        getIt<Api>().getProfile(
          GetProfileParam(deviceId: AppConfig().deviceId),
        ),
      ]
    ]);
    final error = CubitUtils.checkError(results);

    if (error != null) {
      emit(ApiState.error(error, () => this.getSplash()));
    } else {
      if (LocalStorage.hasToken) {
        emit(
          ApiState.splashLoaded(
            data: SplashModel(
              homeInit: results[1].data as HomeInitModel,
              profile: results[2].data as ProfileModel,
            ),
          ),
        );
      } else {
        emit(
          ApiState.splashLoaded(
            data: SplashModel(
              homeInit: results[1].data as HomeInitModel,
              profile: null,
            ),
          ),
        );
      }
    }
  }

  void getTickets(PageParam param) async {
    emit(const ApiState.loading());
    final result = await getIt<Api>().getTickets(param);
    result.pick(
      onData: (data) {
        emit(ApiState.ticketsLoaded(data: data));
      },
      onError: (error) {
        emit(ApiState.error(error, () => getTickets(param)));
      },
    );
  }

  void ticketDetails(IdParam param) async {
    emit(const ApiState.loading());
    final result = await getIt<Api>().ticketDetails(param);
    result.pick(
      onData: (data) {
        emit(ApiState.ticketDetailsLoaded(data));
      },
      onError: (error) {
        emit(ApiState.error(error, () => ticketDetails(param)));
      },
    );
  }

  void createTicket(CreateTicketParams param) async {
    emit(const ApiState.loading());
    final result = await getIt<Api>().createTicket(param);

    result.pick(
      onData: (data) {
        emit(const ApiState.successCreateTicket());
      },
      onError: (error) {
        emit(ApiState.error(error, () => createTicket(param)));
      },
    );
  }

  void confirmCode(ConfirmCodeParam param) async {
    emit(const ApiState.loading());
    final result = await getIt<Api>().confirmCode(param);

    result.pick(
      onData: (data) {
        emit(ApiState.confirmCodeLoaded(data: data));
      },
      onError: (error) {
        emit(ApiState.error(error, () => confirmCode(param)));
      },
    );
  }

  void resendCode(ResendCodeParam param) async {
    emit(const ApiState.loading());
    final result = await getIt<Api>().resendCode(param);

    result.pick(
      onData: (data) {
        emit(const ApiState.successResendCode());
      },
      onError: (error) {
        emit(ApiState.error(error, () => resendCode(param)));
      },
    );
  }

  void updateProfile(UpdateProfileParam param) async {
    emit(const ApiState.loading());
    final result = await getIt<Api>().updateProfile(param);

    result.pick(
      onData: (data) {
        emit(const ApiState.successUpdateProfile());
      },
      onError: (error) {
        emit(ApiState.error(error, () => updateProfile(param)));
      },
    );
  }

  void confirmNewPhoneNumber(ConfirmNewPhoneNumberParam param) async {
    emit(const ApiState.loading());
    final result = await getIt<Api>().confirmNewPhoneNumber(param);

    result.pick(
      onData: (data) {
        emit(const ApiState.successConfirmNewPhoneNumber());
      },
      onError: (error) {
        emit(ApiState.error(error, () => confirmNewPhoneNumber(param)));
      },
    );
  }

  void resendNewPhoneNumberCode(NoParams param) async {
    emit(const ApiState.loading());
    final result = await getIt<Api>().resendNewPhoneNumberCode(param);

    result.pick(
      onData: (data) {
        emit(const ApiState.successResendNewPhoneNumberCode());
      },
      onError: (error) {
        emit(ApiState.error(error, () => resendNewPhoneNumberCode(param)));
      },
    );
  }

  void homeInit(HomeInitParam param) async {
    emit(const ApiState.loading());
    final result = await getIt<Api>().homeInit(param);

    result.pick(
      onData: (data) {
        emit(ApiState.homeInitLoaded(data: data));
      },
      onError: (error) {
        emit(ApiState.error(error, () => homeInit(param)));
      },
    );
  }

  void deleteMyAccount() async {
    emit(const ApiState.loading());
    final result = await getIt<Api>().deleteMyAccount(NoParams());

    result.pick(
      onData: (data) {
        emit(const ApiState.successRequestDeleteMyAccount());
      },
      onError: (error) {
        emit(ApiState.error(error, () => deleteMyAccount()));
      },
    );
  }

  void confirmDeleteMyAccount(ConfirmDeleteMyAccountParam param) async {
    emit(const ApiState.loading());
    final result = await getIt<Api>().confirmDeleteMyAccount(param);

    result.pick(
      onData: (data) {
        emit(const ApiState.successConfirmDeleteMyAccount());
      },
      onError: (error) {
        emit(ApiState.error(error, () => confirmDeleteMyAccount(param)));
      },
    );
  }

  void resendDeleteMyAccountCode() async {
    emit(const ApiState.loading());
    final result = await getIt<Api>().resendDeleteMyAccountCode(NoParams());

    result.pick(
      onData: (data) {
        emit(const ApiState.successResendDeleteMyAccountCode());
      },
      onError: (error) {
        emit(ApiState.error(error, () => resendDeleteMyAccountCode()));
      },
    );
  }

  void logout() async {
    emit(const ApiState.loading());

    // Todo: remove this line
    await Future.delayed(const Duration(seconds: 1));

    final List<Result> results = await Future.wait([]);
    final error = CubitUtils.checkError(results);

    if (error != null) {
      emit(ApiState.error(error, () => this.logout()));
    } else {
      for (String key in SharedPreferenceKeys.REMOVE_KEYS_ON_LOGOUT) {
        bool success = await LocalStorage.sharedPreferences.remove(key);
        if (success) debugPrint("$key removed");
      }

      emit(const ApiState.successLogout());
      RestartWidget.restartApp(AppConfig().appContext!);
    }
  }

  /// blogs
  void getBlogs(PageParam param) async {
    emit(const ApiState.loading());
    final result = await getIt<Api>().getBlogs(param);
    result.pick(
      onData: (data) {
        emit(ApiState.blogListLoaded(data: data));
      },
      onError: (error) {
        emit(ApiState.error(error, () => getBlogs(param)));
      },
    );
  }

  void getBlogDetails(IdParam param) async {
    emit(const ApiState.loading());
    final result = await getIt<Api>().getBlogDetails(param);
    result.pick(
      onData: (data) {
        emit(ApiState.blogDetailsLoaded(data: data));
      },
      onError: (error) {
        emit(ApiState.error(error, () => getBlogDetails(param)));
      },
    );
  }
}

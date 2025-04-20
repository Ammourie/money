part of 'api_cubit.dart';

@freezed
class ApiState with _$ApiState {
  const factory ApiState.initial() = InitialState;
  const factory ApiState.loading() = LoadingState;

  const factory ApiState.successLogout() = SuccessLogoutState;
  const factory ApiState.successResendCode() = SuccessResendCodeState;
  const factory ApiState.successCreateTicket() = SuccessCreateTicketState;
  const factory ApiState.successReportProblem() = SuccessReportProblemState;
  const factory ApiState.successUpdateProfile() = SuccessUpdateProfileState;
  const factory ApiState.successRequestDeleteMyAccount() =
      SuccessRequestDeleteMyAccountState;
  const factory ApiState.successResendDeleteMyAccountCode() =
      SuccessResendDeleteMyAccountCodeState;
  const factory ApiState.successConfirmDeleteMyAccount() =
      SuccessConfirmDeleteMyAccountState;
  const factory ApiState.successResendNewPhoneNumberCode() =
      SuccessResendNewPhoneNumberCodeState;
  const factory ApiState.successConfirmNewPhoneNumber() =
      SuccessConfirmNewPhoneNumberState;
  const factory ApiState.successAddOrUpdateFirebaseToken() =
      SuccessAddOrUpdateFirebaseTokenState;

  const factory ApiState.loginLoaded({
    required LoginModel data,
  }) = LoginLoadedState;

  const factory ApiState.registerLoaded({
    required RegisterModel data,
  }) = RegisterLoadedState;

  const factory ApiState.notificationListLoaded({
    required NotificationListModel data,
  }) = NotificationListLoadedState;

  const factory ApiState.successChangeNotificationStatus() =
      SuccessChangeNotificationStatusState;

  const factory ApiState.faqsLoaded({
    required FaqSectionListModel data,
  }) = FaqsLoadedState;

  const factory ApiState.ticketsLoaded({
    required TicketListModel data,
  }) = TicketsLoadedState;

  const factory ApiState.ticketDetailsLoaded(
    TicketModel data,
  ) = TicketDetailsLoadedState;

  const factory ApiState.splashLoaded({
    required SplashModel data,
  }) = SplashLoadedState;

  const factory ApiState.confirmCodeLoaded({
    required ConfirmCodeModel data,
  }) = ConfirmCodeLoadedState;

  const factory ApiState.profileLoaded({
    required ProfileModel data,
  }) = ProfileLoadedState;

  const factory ApiState.homeInitLoaded({
    required HomeInitModel data,
  }) = HomeInitLoadedState;

  /// Blogs states
  const factory ApiState.blogListLoaded({
    required BlogListModel data,
  }) = BlogListLoadedState;
  const factory ApiState.blogDetailsLoaded({
    required BlogModel data,
  }) = BlogDetailsLoadedState;

  const factory ApiState.error(AppErrors error, VoidCallback callback) =
      ErrorState;
}

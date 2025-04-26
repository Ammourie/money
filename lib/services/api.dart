// ignore_for_file: unused_field

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';

import '../core/common/type_validators.dart';
import '../core/constants/enums/error_code_type.dart';
import '../core/constants/enums/http_method.dart';
import '../core/datasources/remote_data_source.dart';
import '../core/errors/app_errors.dart';
import '../core/models/empty_response.dart';
import '../core/models/number_model.dart';
import '../core/net/api_url.dart';
import '../core/net/create_model_interceptor/primative_create_model_interceptor.dart';
import '../core/params/id_param.dart';
import '../core/params/no_params.dart';
import '../core/params/page_param.dart';
import '../core/results/result.dart';
import '../features/account/model/param/confirm_code_param.dart';
import '../features/account/model/param/confirm_delete_my_account_param.dart';
import '../features/account/model/param/confirm_new_phone_number_param.dart';
import '../features/account/model/param/get_profile_param.dart';
import '../features/account/model/param/login_param.dart';
import '../features/account/model/param/register_param.dart';
import '../features/account/model/param/resend_code_param.dart';
import '../features/account/model/param/update_profile_param.dart';
import '../features/account/model/response/confirm_code_model.dart';
import '../features/account/model/response/login_model.dart';
import '../features/account/model/response/profile_model.dart';
import '../features/account/model/response/register_model.dart';
import '../features/blog/model/response/blog_list_model.dart';
import '../features/blog/model/response/blog_model.dart';
import '../features/home/model/param/home_init_param.dart';
import '../features/home/model/response/home_init_model.dart';
import '../features/more/model/param/report_problem_param.dart';
import '../features/more/model/response/faq_section_list_model.dart';
import '../features/notification/model/param/add_or_update_firebase_token_param.dart';
import '../features/notification/model/param/change_notification_status_param.dart';
import '../features/notification/model/param/notification_list_param.dart';
import '../features/notification/model/response/notification_list_model.dart';
import '../features/tickets/model/param/create_ticket_params.dart';
import '../features/tickets/model/response/ticket_list_model.dart';
import '../features/tickets/model/response/ticket_model.dart';

@lazySingleton
class Api extends RemoteDataSource {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // Home
  Future<Result<AppErrors, HomeInitModel>> homeInit(HomeInitParam params) {
    return request(
      converter: (json) => HomeInitModel.fromJson(json),
      method: HttpMethod.GET,
      url: APIUrls.API_HOME_INIT,
      queryParameters: params.toMap(),
      cancelToken: params.cancelToken,
    );
  }

  // Account
  Future<Result<AppErrors, LoginModel>> login(LoginParam param) async {
    return request(
      converter: (json) => LoginModel.fromMap(json),
      method: HttpMethod.POST,
      url: APIUrls.API_LOGIN,
      body: param.toMap(),
    );
  }

  Future<Result<AppErrors, RegisterModel>> register(RegisterParam param) async {
    return request<RegisterModel>(
      converter: (json) => RegisterModel.fromMap(json),
      method: HttpMethod.POST,
      url: APIUrls.API_REGISTER,
      body: param.toMap(),
      cancelToken: param.cancelToken,
    );
  }

  Future<Result<AppErrors, EmptyResponse>> addOrUpdateFirebaseToken(
    AddOrUpdateFirebaseTokenParam param,
  ) {
    return request<EmptyResponse>(
      converter: (json) => EmptyResponse.fromMap(json),
      method: HttpMethod.POST,
      url: APIUrls.API_ADD_OR_UPDATE_FIREBASE_TOKEN,
      body: param.toMap(),
      cancelToken: param.cancelToken,
    );
  }

  Future<Result<AppErrors, EmptyResponse>> changeNotificationStatus(
      ChangeNotificationStatusParam param) async {
    return await request(
      converter: (json) => EmptyResponse.fromMap(json),
      method: HttpMethod.PUT,
      url: APIUrls.API_CHANGE_NOTIFICATION_STATUS,
      queryParameters: param.toMap(),
      createModelInterceptor: const PrimativeCreateModelInterceptor(),
    );
  }

  Future<Result<AppErrors, ConfirmCodeModel>> confirmCode(
      ConfirmCodeParam params) {
    return request(
      converter: (json) => ConfirmCodeModel.fromMap(json),
      method: HttpMethod.POST,
      url: APIUrls.API_CONFIRM_CODE,
      body: params.toMap(),
    );
  }

  Future<Result<AppErrors, EmptyResponse>> resendCode(ResendCodeParam params) {
    return request(
      converter: (json) => EmptyResponse.fromMap(json),
      method: HttpMethod.POST,
      url: APIUrls.API_RESEND_CODE,
      queryParameters: params.toMap(),
    );
  }

  Future<Result<AppErrors, ProfileModel>> getProfile(GetProfileParam params) {
    return request(
      converter: (json) => ProfileModel.fromJson(json),
      method: HttpMethod.GET,
      url: APIUrls.API_PROFILE,
      queryParameters: params.toMap(),
    );
  }

  Future<Result<AppErrors, EmptyResponse>> updateProfile(
      UpdateProfileParam params) {
    return request(
      converter: (json) => EmptyResponse.fromMap(json),
      method: HttpMethod.PUT,
      url: APIUrls.API_UPDATE_PROFILE,
      body: params.toMap(),
      cancelToken: params.cancelToken,
    );
  }

  Future<Result<AppErrors, EmptyResponse>> confirmNewPhoneNumber(
      ConfirmNewPhoneNumberParam params) {
    return request(
      converter: (json) => EmptyResponse.fromMap(json),
      method: HttpMethod.PUT,
      url: APIUrls.API_CONFIRM_NEW_PHONE_NUMBER,
      body: params.toMap(),
      cancelToken: params.cancelToken,
    );
  }

  Future<Result<AppErrors, EmptyResponse>> resendNewPhoneNumberCode(
      NoParams params) {
    return request(
      converter: (json) => EmptyResponse.fromMap(json),
      method: HttpMethod.PUT,
      url: APIUrls.API_RESEND_NEW_PHONE_NUMBER_CODE,
      cancelToken: params.cancelToken,
    );
  }

  Future<Result<AppErrors, EmptyResponse>> deleteMyAccount(NoParams params) {
    return request(
      converter: (json) => EmptyResponse.fromMap(json),
      method: HttpMethod.PUT,
      url: APIUrls.API_DELETE_MY_ACCOUNT,
      cancelToken: params.cancelToken,
    );
  }

  Future<Result<AppErrors, EmptyResponse>> confirmDeleteMyAccount(
      ConfirmDeleteMyAccountParam params) {
    return request(
      converter: (json) => EmptyResponse.fromMap(json),
      method: HttpMethod.DELETE,
      url: APIUrls.API_CONFIRM_DELETE_ACCOUNT,
      queryParameters: params.toMap(),
      cancelToken: params.cancelToken,
    );
  }

  Future<Result<AppErrors, EmptyResponse>> resendDeleteMyAccountCode(
      NoParams params) {
    return request(
      converter: (json) => EmptyResponse.fromMap(json),
      method: HttpMethod.PUT,
      url: APIUrls.API_RESEND_DELETE_ACCOUNT_CODE,
      cancelToken: params.cancelToken,
    );
  }

  // Notification
  Future<Result<AppErrors, NotificationListModel>> getNotifications(
      NotificationListParam param) {
    return request(
      converter: (json) => NotificationListModel.fromMap(json),
      method: HttpMethod.GET,
      url: APIUrls.API_NOTIFICATION_LIST,
      cancelToken: param.cancelToken,
      queryParameters: param.toMap(),
    );
  }

  // Faqs
  Future<Result<AppErrors, FaqSectionListModel>> getFaqs(
      PageParam param) async {
    return request(
      converter: (json) => FaqSectionListModel.fromJson(json),
      method: HttpMethod.GET,
      url: APIUrls.API_FAQ_SECTIONS_LIST,
      queryParameters: param.toMap(),
    );
  }

  // Tickets
  Future<Result<AppErrors, TicketListModel>> getTickets(PageParam param) {
    return request(
      converter: (json) => TicketListModel.fromMap(json),
      method: HttpMethod.GET,
      url: APIUrls.API_MY_TICKETS,
      queryParameters: param.toMap(),
    );
  }

  Future<Result<AppErrors, TicketModel>> ticketDetails(IdParam params) {
    return request(
      converter: (json) => TicketModel.fromMap(
          listV(json['result']?['items']).firstOrNull ?? {}),
      method: HttpMethod.GET,
      url: APIUrls.API_MY_TICKETS,
      queryParameters: params.toMap(),
      createModelInterceptor: const PrimativeCreateModelInterceptor(),
    );
  }

  Future<Result<AppErrors, NumberModel>> createTicket(
      CreateTicketParams params) {
    return request(
      converter: (json) => NumberModel.fromMap(json),
      method: HttpMethod.POST,
      url: APIUrls.API_CREATE_TICKET,
      body: params.toMap(),
      createModelInterceptor: const PrimativeCreateModelInterceptor(),
    );
  }

  // More
  Future<Result<AppErrors, EmptyResponse>> reportProblem(
      ReportProblemParam params) {
    return request(
      converter: (json) => EmptyResponse.fromMap(json),
      method: HttpMethod.POST,
      url: APIUrls.API_REPORT_PROBLEM,
      body: params.toMap(),
    );
  }

  // Blogs
  Future<Result<AppErrors, BlogListModel>> getBlogs(PageParam params) {
    return request(
      converter: (json) => BlogListModel.fromJson(json),
      method: HttpMethod.GET,
      url: APIUrls.BLOG_LIST,
      queryParameters: params.toMap(),
    );
  }

  Future<Result<AppErrors, BlogModel>> getBlogDetails(IdParam params) {
    return request(
      converter: (json) => BlogModel.fromJson(json),
      method: HttpMethod.GET,
      url: APIUrls.BLOG_DETAILS,
      queryParameters: params.toMap(),
    );
  }

  Future<Result<AppErrors, UserCredential>> signInWithGoogle() async {
    log('Starting Google Sign-In process', name: 'firebase-log');
    try {
      // Trigger the Google Sign-In flow
      log('Triggering Google Sign-In flow', name: 'firebase-log');
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User canceled the sign-in flow
        log('Google Sign-In canceled by user', name: 'firebase-log');
        return Result.error(
          const InternalServerWithDataError(
            500,
            message: 'Sign in canceled',
            type: ErrorCodeType.Unkown,
          ),
        );
      }

      log('Google Sign-In successful for user: ${googleUser.email}',
          name: 'firebase-log');

      // Obtain the auth details from the request
      log('Obtaining auth details', name: 'firebase-log');
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential for Firebase
      log('Creating Firebase credential', name: 'firebase-log');
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      log('Signing in to Firebase with Google credential',
          name: 'firebase-log');
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      log('Firebase sign-in successful for user: ${userCredential.user?.uid}',
          name: 'firebase-log');

      return Result.data(userCredential);
    } catch (e) {
      log('Sign-in error: $e', name: 'firebase-log');
      return Result.error(
        const InternalServerWithDataError(
          500,
          message: 'Sign in failed',
          type: ErrorCodeType.Unkown,
        ),
      );
    }
  }
}

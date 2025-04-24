// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name =
        (locale.countryCode?.isEmpty ?? false)
            ? locale.languageCode
            : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Error Occured 😢`
  String get errorOccurred {
    return Intl.message(
      'Error Occured 😢',
      name: 'errorOccurred',
      desc: '',
      args: [],
    );
  }

  /// `An error has been occurred, please click send to help us fixing the problem`
  String get reportError {
    return Intl.message(
      'An error has been occurred, please click send to help us fixing the problem',
      name: 'reportError',
      desc: '',
      args: [],
    );
  }

  /// `Unauthorized`
  String get unauthorized {
    return Intl.message(
      'Unauthorized',
      name: 'unauthorized',
      desc: '',
      args: [],
    );
  }

  /// `An error has occurred. Please try again later`
  String get generalErrorMessage {
    return Intl.message(
      'An error has occurred. Please try again later',
      name: 'generalErrorMessage',
      desc: '',
      args: [],
    );
  }

  /// `Bad Request`
  String get badRequest {
    return Intl.message('Bad Request', name: 'badRequest', desc: '', args: []);
  }

  /// `Forbidden`
  String get forbidden {
    return Intl.message('Forbidden', name: 'forbidden', desc: '', args: []);
  }

  /// `{url} not Found`
  String notFound(Object url) {
    return Intl.message(
      '$url not Found',
      name: 'notFound',
      desc: '',
      args: [url],
    );
  }

  /// `Conflict Error`
  String get conflictError {
    return Intl.message(
      'Conflict Error',
      name: 'conflictError',
      desc: '',
      args: [],
    );
  }

  /// `Not valid response`
  String get notValidResponse {
    return Intl.message(
      'Not valid response',
      name: 'notValidResponse',
      desc: '',
      args: [],
    );
  }

  /// `Connection time out`
  String get connectionTimeOut {
    return Intl.message(
      'Connection time out',
      name: 'connectionTimeOut',
      desc: '',
      args: [],
    );
  }

  /// `Unknown error occurred, please try again`
  String get unknownError {
    return Intl.message(
      'Unknown error occurred, please try again',
      name: 'unknownError',
      desc: '',
      args: [],
    );
  }

  /// `The server encountered an internal error or misconfigurtion and was unable to complete your request.`
  String get internalServerErrorMessage {
    return Intl.message(
      'The server encountered an internal error or misconfigurtion and was unable to complete your request.',
      name: 'internalServerErrorMessage',
      desc: '',
      args: [],
    );
  }

  /// `Please check your internet connection`
  String get connectionErrorMessage {
    return Intl.message(
      'Please check your internet connection',
      name: 'connectionErrorMessage',
      desc: '',
      args: [],
    );
  }

  /// `OOPS !`
  String get oopsErrorMessage {
    return Intl.message('OOPS !', name: 'oopsErrorMessage', desc: '', args: []);
  }

  /// `Failed to get data`
  String get failedRefresher {
    return Intl.message(
      'Failed to get data',
      name: 'failedRefresher',
      desc: '',
      args: [],
    );
  }

  /// `No data`
  String get noDataRefresher {
    return Intl.message('No data', name: 'noDataRefresher', desc: '', args: []);
  }

  /// `This field can't be empty`
  String get errorTxt {
    return Intl.message(
      'This field can\'t be empty',
      name: 'errorTxt',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logOut {
    return Intl.message('Logout', name: 'logOut', desc: '', args: []);
  }

  /// `Change Language`
  String get changeLanguage {
    return Intl.message(
      'Change Language',
      name: 'changeLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Confirm`
  String get confirm {
    return Intl.message('Confirm', name: 'confirm', desc: '', args: []);
  }

  /// `Select a language, the application will restart`
  String get changeLangMessage {
    return Intl.message(
      'Select a language, the application will restart',
      name: 'changeLangMessage',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message('Login', name: 'login', desc: '', args: []);
  }

  /// `Welcome`
  String get welcome {
    return Intl.message('Welcome', name: 'welcome', desc: '', args: []);
  }

  /// `Press twice to exit`
  String get pressTwiceToExit {
    return Intl.message(
      'Press twice to exit',
      name: 'pressTwiceToExit',
      desc: '',
      args: [],
    );
  }

  /// `User name`
  String get userName {
    return Intl.message('User name', name: 'userName', desc: '', args: []);
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `Please enter a valid phone number ex: 7xx-xxx-xxx`
  String get invalidPhoneNumber {
    return Intl.message(
      'Please enter a valid phone number ex: 7xx-xxx-xxx',
      name: 'invalidPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Must be at least 8 characters long`
  String get invalidPassword {
    return Intl.message(
      'Must be at least 8 characters long',
      name: 'invalidPassword',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get retry {
    return Intl.message('Retry', name: 'retry', desc: '', args: []);
  }

  /// `Close App`
  String get closeApp {
    return Intl.message('Close App', name: 'closeApp', desc: '', args: []);
  }

  /// `Update Required`
  String get updateTitle {
    return Intl.message(
      'Update Required',
      name: 'updateTitle',
      desc: '',
      args: [],
    );
  }

  /// `For the best experience, update to the latest version to get new features and improvements.`
  String get updateMessage {
    return Intl.message(
      'For the best experience, update to the latest version to get new features and improvements.',
      name: 'updateMessage',
      desc: '',
      args: [],
    );
  }

  /// `Empty`
  String get empty {
    return Intl.message('Empty', name: 'empty', desc: '', args: []);
  }

  /// `Close`
  String get close {
    return Intl.message('Close', name: 'close', desc: '', args: []);
  }

  /// `The page has no content ..`
  String get pageEmpty {
    return Intl.message(
      'The page has no content ..',
      name: 'pageEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Refresh`
  String get refresh {
    return Intl.message('Refresh', name: 'refresh', desc: '', args: []);
  }

  /// `Apply`
  String get apply {
    return Intl.message('Apply', name: 'apply', desc: '', args: []);
  }

  /// `An error happened while connecting to server, please try again later`
  String get responseError {
    return Intl.message(
      'An error happened while connecting to server, please try again later',
      name: 'responseError',
      desc: '',
      args: [],
    );
  }

  /// `The connection has been interrupted`
  String get errorCancelToken {
    return Intl.message(
      'The connection has been interrupted',
      name: 'errorCancelToken',
      desc: '',
      args: [],
    );
  }

  /// `Signup`
  String get signUp {
    return Intl.message('Signup', name: 'signUp', desc: '', args: []);
  }

  /// `Or`
  String get or {
    return Intl.message('Or', name: 'or', desc: '', args: []);
  }

  /// `Phone Number`
  String get phone {
    return Intl.message('Phone Number', name: 'phone', desc: '', args: []);
  }

  /// `Ok`
  String get ok {
    return Intl.message('Ok', name: 'ok', desc: '', args: []);
  }

  /// `Confirm Password`
  String get confirmPassword {
    return Intl.message(
      'Confirm Password',
      name: 'confirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Password and confirm password doesn't match`
  String get invalidConfirmPassword {
    return Intl.message(
      'Password and confirm password doesn\'t match',
      name: 'invalidConfirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message('Name', name: 'name', desc: '', args: []);
  }

  /// `Surname`
  String get surname {
    return Intl.message('Surname', name: 'surname', desc: '', args: []);
  }

  /// `This field mustn't be empty`
  String get errorEmptyField {
    return Intl.message(
      'This field mustn\'t be empty',
      name: 'errorEmptyField',
      desc: '',
      args: [],
    );
  }

  /// `Switch theme`
  String get switchTheme {
    return Intl.message(
      'Switch theme',
      name: 'switchTheme',
      desc: '',
      args: [],
    );
  }

  /// `Account Not Verified`
  String get accountNotVerifiedErrorMessage {
    return Intl.message(
      'Account Not Verified',
      name: 'accountNotVerifiedErrorMessage',
      desc: '',
      args: [],
    );
  }

  /// `Operation has been cancelled`
  String get cancelErrorMessage {
    return Intl.message(
      'Operation has been cancelled',
      name: 'cancelErrorMessage',
      desc: '',
      args: [],
    );
  }

  /// `login Error Required`
  String get loginErrorRequired {
    return Intl.message(
      'login Error Required',
      name: 'loginErrorRequired',
      desc: '',
      args: [],
    );
  }

  /// `This page is empty`
  String get emptyScreen {
    return Intl.message(
      'This page is empty',
      name: 'emptyScreen',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get send {
    return Intl.message('Send', name: 'send', desc: '', args: []);
  }

  /// `Couldn't find path`
  String get mapPathError {
    return Intl.message(
      'Couldn\'t find path',
      name: 'mapPathError',
      desc: '',
      args: [],
    );
  }

  /// `Could not fetch distance`
  String get errorFetchDistance {
    return Intl.message(
      'Could not fetch distance',
      name: 'errorFetchDistance',
      desc: '',
      args: [],
    );
  }

  /// `OTP Verification`
  String get otpVerification {
    return Intl.message(
      'OTP Verification',
      name: 'otpVerification',
      desc: '',
      args: [],
    );
  }

  /// `please type the verification code send to`
  String get enterCodeText {
    return Intl.message(
      'please type the verification code send to',
      name: 'enterCodeText',
      desc: '',
      args: [],
    );
  }

  /// `Resend Code`
  String get resendCode {
    return Intl.message('Resend Code', name: 'resendCode', desc: '', args: []);
  }

  /// `No Result Found`
  String get noResultFound {
    return Intl.message(
      'No Result Found',
      name: 'noResultFound',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message('Search', name: 'search', desc: '', args: []);
  }

  /// `Sorry, you are a guest, login to continue.`
  String get guetsMessage {
    return Intl.message(
      'Sorry, you are a guest, login to continue.',
      name: 'guetsMessage',
      desc: '',
      args: [],
    );
  }

  /// `Update Required`
  String get dialogUpdateTitle {
    return Intl.message(
      'Update Required',
      name: 'dialogUpdateTitle',
      desc: '',
      args: [],
    );
  }

  /// `New Update!`
  String get optionalUpdateTitle {
    return Intl.message(
      'New Update!',
      name: 'optionalUpdateTitle',
      desc: '',
      args: [],
    );
  }

  /// `For the best experience, update to the latest version to get new features and improvements.`
  String get dialogUpdateMessage {
    return Intl.message(
      'For the best experience, update to the latest version to get new features and improvements.',
      name: 'dialogUpdateMessage',
      desc: '',
      args: [],
    );
  }

  /// `There is a new version for this app. Update to get new features and improvements`
  String get optionalUpdateMessage {
    return Intl.message(
      'There is a new version for this app. Update to get new features and improvements',
      name: 'optionalUpdateMessage',
      desc: '',
      args: [],
    );
  }

  /// `Ignore`
  String get ignoreForNow {
    return Intl.message('Ignore', name: 'ignoreForNow', desc: '', args: []);
  }

  /// `Update`
  String get update {
    return Intl.message('Update', name: 'update', desc: '', args: []);
  }

  /// `Access Denied!`
  String get accessDenied {
    return Intl.message(
      'Access Denied!',
      name: 'accessDenied',
      desc: '',
      args: [],
    );
  }

  /// `{permissionName} permission required!`
  String specificPermissionRequired(Object permissionName) {
    return Intl.message(
      '$permissionName permission required!',
      name: 'specificPermissionRequired',
      desc: '',
      args: [permissionName],
    );
  }

  /// `Make sure {permissionName} permission is granted to be able to use the app.`
  String makeSureSpecificPermissionGranted(Object permissionName) {
    return Intl.message(
      'Make sure $permissionName permission is granted to be able to use the app.',
      name: 'makeSureSpecificPermissionGranted',
      desc: '',
      args: [permissionName],
    );
  }

  /// `Try enabling it from your phone settings`
  String get tryEnablingItFromYourPhoneSettings {
    return Intl.message(
      'Try enabling it from your phone settings',
      name: 'tryEnablingItFromYourPhoneSettings',
      desc: '',
      args: [],
    );
  }

  /// `Open App Settings`
  String get openAppSettings {
    return Intl.message(
      'Open App Settings',
      name: 'openAppSettings',
      desc: '',
      args: [],
    );
  }

  /// `Location`
  String get locationPermission {
    return Intl.message(
      'Location',
      name: 'locationPermission',
      desc: '',
      args: [],
    );
  }

  /// `Camera`
  String get cameraPermission {
    return Intl.message('Camera', name: 'cameraPermission', desc: '', args: []);
  }

  /// `The previous permission is required!`
  String get permissionRequiredTitle {
    return Intl.message(
      'The previous permission is required!',
      name: 'permissionRequiredTitle',
      desc: '',
      args: [],
    );
  }

  /// `make sure to grant the previous permission to be able to use the app.`
  String get permissionRequiredMessage {
    return Intl.message(
      'make sure to grant the previous permission to be able to use the app.',
      name: 'permissionRequiredMessage',
      desc: '',
      args: [],
    );
  }

  /// `Didn't you receive any code?`
  String get didnotReceiveAnyCode {
    return Intl.message(
      'Didn\'t you receive any code?',
      name: 'didnotReceiveAnyCode',
      desc: '',
      args: [],
    );
  }

  /// `Faild to fetch data`
  String get faildToFetchData {
    return Intl.message(
      'Faild to fetch data',
      name: 'faildToFetchData',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `No notifications yet`
  String get noNotifications {
    return Intl.message(
      'No notifications yet',
      name: 'noNotifications',
      desc: '',
      args: [],
    );
  }

  /// `Thank you for reporting`
  String get thankYouForReporting {
    return Intl.message(
      'Thank you for reporting',
      name: 'thankYouForReporting',
      desc: '',
      args: [],
    );
  }

  /// `About US`
  String get aboutUs {
    return Intl.message('About US', name: 'aboutUs', desc: '', args: []);
  }

  /// `Contact US`
  String get contactUs {
    return Intl.message('Contact US', name: 'contactUs', desc: '', args: []);
  }

  /// `FAQs`
  String get faqs {
    return Intl.message('FAQs', name: 'faqs', desc: '', args: []);
  }

  /// `My Tickets`
  String get myTickets {
    return Intl.message('My Tickets', name: 'myTickets', desc: '', args: []);
  }

  /// `Type`
  String get type {
    return Intl.message('Type', name: 'type', desc: '', args: []);
  }

  /// `Ticket`
  String get ticket {
    return Intl.message('Ticket', name: 'ticket', desc: '', args: []);
  }

  /// `Submitted at`
  String get submittedAt {
    return Intl.message(
      'Submitted at',
      name: 'submittedAt',
      desc: '',
      args: [],
    );
  }

  /// `My message`
  String get myMessage {
    return Intl.message('My message', name: 'myMessage', desc: '', args: []);
  }

  /// `Pending`
  String get pending {
    return Intl.message('Pending', name: 'pending', desc: '', args: []);
  }

  /// `Closed`
  String get closed {
    return Intl.message('Closed', name: 'closed', desc: '', args: []);
  }

  /// `Ticket Number`
  String get ticketNumber {
    return Intl.message(
      'Ticket Number',
      name: 'ticketNumber',
      desc: '',
      args: [],
    );
  }

  /// `Admin Reply`
  String get adminReply {
    return Intl.message('Admin Reply', name: 'adminReply', desc: '', args: []);
  }

  /// `Ticket Created Successfully`
  String get yourTicketSubmittedSuccessfullyTitle {
    return Intl.message(
      'Ticket Created Successfully',
      name: 'yourTicketSubmittedSuccessfullyTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your ticket has been submitted successfully, we will contact you ASAP`
  String get yourTicketSubmittedSuccessfully {
    return Intl.message(
      'Your ticket has been submitted successfully, we will contact you ASAP',
      name: 'yourTicketSubmittedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Submit Ticket`
  String get submitTicket {
    return Intl.message(
      'Submit Ticket',
      name: 'submitTicket',
      desc: '',
      args: [],
    );
  }

  /// `I want to ask about ...`
  String get iWantToAskAbout {
    return Intl.message(
      'I want to ask about ...',
      name: 'iWantToAskAbout',
      desc: '',
      args: [],
    );
  }

  /// `Complaint`
  String get complaint {
    return Intl.message('Complaint', name: 'complaint', desc: '', args: []);
  }

  /// `Question`
  String get question {
    return Intl.message('Question', name: 'question', desc: '', args: []);
  }

  /// `Suggesstion`
  String get suggesstion {
    return Intl.message('Suggesstion', name: 'suggesstion', desc: '', args: []);
  }

  /// `Please write your concern and will reply during 24h`
  String get ticketDialogText {
    return Intl.message(
      'Please write your concern and will reply during 24h',
      name: 'ticketDialogText',
      desc: '',
      args: [],
    );
  }

  /// `New Ticket`
  String get newTicket {
    return Intl.message('New Ticket', name: 'newTicket', desc: '', args: []);
  }

  /// `Select subject`
  String get selectSubject {
    return Intl.message(
      'Select subject',
      name: 'selectSubject',
      desc: '',
      args: [],
    );
  }

  /// `User doesn't exist`
  String get userDoesNotExist {
    return Intl.message(
      'User doesn\'t exist',
      name: 'userDoesNotExist',
      desc: '',
      args: [],
    );
  }

  /// `Code resent`
  String get codeResent {
    return Intl.message('Code resent', name: 'codeResent', desc: '', args: []);
  }

  /// `Please Enter the code sent to {number}`
  String otpText(Object number) {
    return Intl.message(
      'Please Enter the code sent to $number',
      name: 'otpText',
      desc: '',
      args: [number],
    );
  }

  /// `Select your gender`
  String get selectYourGender {
    return Intl.message(
      'Select your gender',
      name: 'selectYourGender',
      desc: '',
      args: [],
    );
  }

  /// `male`
  String get male {
    return Intl.message('male', name: 'male', desc: '', args: []);
  }

  /// `female`
  String get female {
    return Intl.message('female', name: 'female', desc: '', args: []);
  }

  /// `Date of birth`
  String get dateOfBirth {
    return Intl.message(
      'Date of birth',
      name: 'dateOfBirth',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure?`
  String get areYouSure {
    return Intl.message(
      'Are you sure?',
      name: 'areYouSure',
      desc: '',
      args: [],
    );
  }

  /// `Email Address`
  String get emailAddress {
    return Intl.message(
      'Email Address',
      name: 'emailAddress',
      desc: '',
      args: [],
    );
  }

  /// `Not Valid Email`
  String get notValidEmail {
    return Intl.message(
      'Not Valid Email',
      name: 'notValidEmail',
      desc: '',
      args: [],
    );
  }

  /// `My profile`
  String get myProfile {
    return Intl.message('My profile', name: 'myProfile', desc: '', args: []);
  }

  /// `Update profile`
  String get updateProfile {
    return Intl.message(
      'Update profile',
      name: 'updateProfile',
      desc: '',
      args: [],
    );
  }

  /// `Change phone number`
  String get changePhoneNumber {
    return Intl.message(
      'Change phone number',
      name: 'changePhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Delete Account`
  String get deleteAccount {
    return Intl.message(
      'Delete Account',
      name: 'deleteAccount',
      desc: '',
      args: [],
    );
  }

  /// `Updated Successfully`
  String get updatedSuccessfully {
    return Intl.message(
      'Updated Successfully',
      name: 'updatedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `New phone number`
  String get newPhoneNumber {
    return Intl.message(
      'New phone number',
      name: 'newPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get submit {
    return Intl.message('Submit', name: 'submit', desc: '', args: []);
  }

  /// `Terms And Conditions`
  String get termsAndConditions {
    return Intl.message(
      'Terms And Conditions',
      name: 'termsAndConditions',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Policy`
  String get privacyPolicy {
    return Intl.message(
      'Privacy Policy',
      name: 'privacyPolicy',
      desc: '',
      args: [],
    );
  }

  /// `Change notification status`
  String get changeNotificationStatus {
    return Intl.message(
      'Change notification status',
      name: 'changeNotificationStatus',
      desc: '',
      args: [],
    );
  }

  /// `Home Page`
  String get homePage {
    return Intl.message('Home Page', name: 'homePage', desc: '', args: []);
  }

  /// `Translation Test`
  String get translationTest {
    return Intl.message(
      'Translation Test',
      name: 'translationTest',
      desc: '',
      args: [],
    );
  }

  /// `Just Log`
  String get justLog {
    return Intl.message('Just Log', name: 'justLog', desc: '', args: []);
  }

  /// `Test Success Request`
  String get testSuccessRequest {
    return Intl.message(
      'Test Success Request',
      name: 'testSuccessRequest',
      desc: '',
      args: [],
    );
  }

  /// `Test Failure Request`
  String get testFailureRequest {
    return Intl.message(
      'Test Failure Request',
      name: 'testFailureRequest',
      desc: '',
      args: [],
    );
  }

  /// `Test Validator Request`
  String get testValidatorRequest {
    return Intl.message(
      'Test Validator Request',
      name: 'testValidatorRequest',
      desc: '',
      args: [],
    );
  }

  /// `Get People`
  String get getPeople {
    return Intl.message('Get People', name: 'getPeople', desc: '', args: []);
  }

  /// `Get Pokemons`
  String get getPokemons {
    return Intl.message(
      'Get Pokemons',
      name: 'getPokemons',
      desc: '',
      args: [],
    );
  }

  /// `Test Error Handler`
  String get testErrorScreen {
    return Intl.message(
      'Test Error Handler',
      name: 'testErrorScreen',
      desc: '',
      args: [],
    );
  }

  /// `Blogs`
  String get blogs {
    return Intl.message('Blogs', name: 'blogs', desc: '', args: []);
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
      Locale.fromSubtags(languageCode: 'ku'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}

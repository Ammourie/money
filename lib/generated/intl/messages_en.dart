// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(permissionName) =>
      "Make sure ${permissionName} permission is granted to be able to use the app.";

  static String m1(url) => "${url} not Found";

  static String m2(number) => "Please Enter the code sent to ${number}";

  static String m3(permissionName) => "${permissionName} permission required!";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "aboutUs": MessageLookupByLibrary.simpleMessage("About US"),
        "accessDenied": MessageLookupByLibrary.simpleMessage("Access Denied!"),
        "accountNotVerifiedErrorMessage":
            MessageLookupByLibrary.simpleMessage("Account Not Verified"),
        "adminReply": MessageLookupByLibrary.simpleMessage("Admin Reply"),
        "apply": MessageLookupByLibrary.simpleMessage("Apply"),
        "areYouSure": MessageLookupByLibrary.simpleMessage("Are you sure?"),
        "badRequest": MessageLookupByLibrary.simpleMessage("Bad Request"),
        "blogs": MessageLookupByLibrary.simpleMessage("Blogs"),
        "cameraPermission": MessageLookupByLibrary.simpleMessage("Camera"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "cancelErrorMessage": MessageLookupByLibrary.simpleMessage(
            "Operation has been cancelled"),
        "changeLangMessage": MessageLookupByLibrary.simpleMessage(
            "Select a language, the application will restart"),
        "changeLanguage":
            MessageLookupByLibrary.simpleMessage("Change Language"),
        "changeNotificationStatus":
            MessageLookupByLibrary.simpleMessage("Change notification status"),
        "changePhoneNumber":
            MessageLookupByLibrary.simpleMessage("Change phone number"),
        "close": MessageLookupByLibrary.simpleMessage("Close"),
        "closeApp": MessageLookupByLibrary.simpleMessage("Close App"),
        "closed": MessageLookupByLibrary.simpleMessage("Closed"),
        "codeResent": MessageLookupByLibrary.simpleMessage("Code resent"),
        "complaint": MessageLookupByLibrary.simpleMessage("Complaint"),
        "confirm": MessageLookupByLibrary.simpleMessage("Confirm"),
        "confirmPassword":
            MessageLookupByLibrary.simpleMessage("Confirm Password"),
        "conflictError": MessageLookupByLibrary.simpleMessage("Conflict Error"),
        "connectionErrorMessage": MessageLookupByLibrary.simpleMessage(
            "Please check your internet connection"),
        "connectionTimeOut":
            MessageLookupByLibrary.simpleMessage("Connection time out"),
        "contactUs": MessageLookupByLibrary.simpleMessage("Contact US"),
        "dateOfBirth": MessageLookupByLibrary.simpleMessage("Date of birth"),
        "deleteAccount": MessageLookupByLibrary.simpleMessage("Delete Account"),
        "dialogUpdateMessage": MessageLookupByLibrary.simpleMessage(
            "For the best experience, update to the latest version to get new features and improvements."),
        "dialogUpdateTitle":
            MessageLookupByLibrary.simpleMessage("Update Required"),
        "didnotReceiveAnyCode": MessageLookupByLibrary.simpleMessage(
            "Didn\'t you receive any code?"),
        "emailAddress": MessageLookupByLibrary.simpleMessage("Email Address"),
        "empty": MessageLookupByLibrary.simpleMessage("Empty"),
        "emptyScreen":
            MessageLookupByLibrary.simpleMessage("This page is empty"),
        "enterCodeText": MessageLookupByLibrary.simpleMessage(
            "please type the verification code send to"),
        "errorCancelToken": MessageLookupByLibrary.simpleMessage(
            "The connection has been interrupted"),
        "errorEmptyField": MessageLookupByLibrary.simpleMessage(
            "This field mustn\'t be empty"),
        "errorFetchDistance":
            MessageLookupByLibrary.simpleMessage("Could not fetch distance"),
        "errorOccurred":
            MessageLookupByLibrary.simpleMessage("Error Occured 😢"),
        "errorTxt":
            MessageLookupByLibrary.simpleMessage("This field can\'t be empty"),
        "faildToFetchData":
            MessageLookupByLibrary.simpleMessage("Faild to fetch data"),
        "failedRefresher":
            MessageLookupByLibrary.simpleMessage("Failed to get data"),
        "faqs": MessageLookupByLibrary.simpleMessage("FAQs"),
        "female": MessageLookupByLibrary.simpleMessage("female"),
        "forbidden": MessageLookupByLibrary.simpleMessage("Forbidden"),
        "generalErrorMessage": MessageLookupByLibrary.simpleMessage(
            "An error has occurred. Please try again later"),
        "getPeople": MessageLookupByLibrary.simpleMessage("Get People"),
        "getPokemons": MessageLookupByLibrary.simpleMessage("Get Pokemons"),
        "guetsMessage": MessageLookupByLibrary.simpleMessage(
            "Sorry, you are a guest, login to continue."),
        "homePage": MessageLookupByLibrary.simpleMessage("Home Page"),
        "iWantToAskAbout":
            MessageLookupByLibrary.simpleMessage("I want to ask about ..."),
        "ignoreForNow": MessageLookupByLibrary.simpleMessage("Ignore"),
        "internalServerErrorMessage": MessageLookupByLibrary.simpleMessage(
            "The server encountered an internal error or misconfigurtion and was unable to complete your request."),
        "invalidConfirmPassword": MessageLookupByLibrary.simpleMessage(
            "Password and confirm password doesn\'t match"),
        "invalidPassword": MessageLookupByLibrary.simpleMessage(
            "Must be at least 8 characters long"),
        "invalidPhoneNumber": MessageLookupByLibrary.simpleMessage(
            "Please enter a valid phone number ex: 7xx-xxx-xxx"),
        "justLog": MessageLookupByLibrary.simpleMessage("Just Log"),
        "locationPermission": MessageLookupByLibrary.simpleMessage("Location"),
        "logOut": MessageLookupByLibrary.simpleMessage("Logout"),
        "login": MessageLookupByLibrary.simpleMessage("Login"),
        "loginErrorRequired":
            MessageLookupByLibrary.simpleMessage("login Error Required"),
        "makeSureSpecificPermissionGranted": m0,
        "male": MessageLookupByLibrary.simpleMessage("male"),
        "mapPathError":
            MessageLookupByLibrary.simpleMessage("Couldn\'t find path"),
        "myMessage": MessageLookupByLibrary.simpleMessage("My message"),
        "myProfile": MessageLookupByLibrary.simpleMessage("My profile"),
        "myTickets": MessageLookupByLibrary.simpleMessage("My Tickets"),
        "name": MessageLookupByLibrary.simpleMessage("Name"),
        "newPhoneNumber":
            MessageLookupByLibrary.simpleMessage("New phone number"),
        "newTicket": MessageLookupByLibrary.simpleMessage("New Ticket"),
        "noDataRefresher": MessageLookupByLibrary.simpleMessage("No data"),
        "noNotifications":
            MessageLookupByLibrary.simpleMessage("No notifications yet"),
        "noResultFound":
            MessageLookupByLibrary.simpleMessage("No Result Found"),
        "notFound": m1,
        "notValidEmail":
            MessageLookupByLibrary.simpleMessage("Not Valid Email"),
        "notValidResponse":
            MessageLookupByLibrary.simpleMessage("Not valid response"),
        "notifications": MessageLookupByLibrary.simpleMessage("Notifications"),
        "ok": MessageLookupByLibrary.simpleMessage("Ok"),
        "oopsErrorMessage": MessageLookupByLibrary.simpleMessage("OOPS !"),
        "openAppSettings":
            MessageLookupByLibrary.simpleMessage("Open App Settings"),
        "optionalUpdateMessage": MessageLookupByLibrary.simpleMessage(
            "There is a new version for this app. Update to get new features and improvements"),
        "optionalUpdateTitle":
            MessageLookupByLibrary.simpleMessage("New Update!"),
        "or": MessageLookupByLibrary.simpleMessage("Or"),
        "otpText": m2,
        "otpVerification":
            MessageLookupByLibrary.simpleMessage("OTP Verification"),
        "pageEmpty":
            MessageLookupByLibrary.simpleMessage("The page has no content .."),
        "password": MessageLookupByLibrary.simpleMessage("Password"),
        "pending": MessageLookupByLibrary.simpleMessage("Pending"),
        "permissionRequiredMessage": MessageLookupByLibrary.simpleMessage(
            "make sure to grant the previous permission to be able to use the app."),
        "permissionRequiredTitle": MessageLookupByLibrary.simpleMessage(
            "The previous permission is required!"),
        "phone": MessageLookupByLibrary.simpleMessage("Phone Number"),
        "pressTwiceToExit":
            MessageLookupByLibrary.simpleMessage("Press twice to exit"),
        "privacyPolicy": MessageLookupByLibrary.simpleMessage("Privacy Policy"),
        "question": MessageLookupByLibrary.simpleMessage("Question"),
        "refresh": MessageLookupByLibrary.simpleMessage("Refresh"),
        "reportError": MessageLookupByLibrary.simpleMessage(
            "An error has been occurred, please click send to help us fixing the problem"),
        "resendCode": MessageLookupByLibrary.simpleMessage("Resend Code"),
        "responseError": MessageLookupByLibrary.simpleMessage(
            "An error happened while connecting to server, please try again later"),
        "retry": MessageLookupByLibrary.simpleMessage("Retry"),
        "search": MessageLookupByLibrary.simpleMessage("Search"),
        "selectSubject": MessageLookupByLibrary.simpleMessage("Select subject"),
        "selectYourGender":
            MessageLookupByLibrary.simpleMessage("Select your gender"),
        "send": MessageLookupByLibrary.simpleMessage("Send"),
        "signUp": MessageLookupByLibrary.simpleMessage("Signup"),
        "specificPermissionRequired": m3,
        "submit": MessageLookupByLibrary.simpleMessage("Submit"),
        "submitTicket": MessageLookupByLibrary.simpleMessage("Submit Ticket"),
        "submittedAt": MessageLookupByLibrary.simpleMessage("Submitted at"),
        "suggesstion": MessageLookupByLibrary.simpleMessage("Suggesstion"),
        "surname": MessageLookupByLibrary.simpleMessage("Surname"),
        "switchTheme": MessageLookupByLibrary.simpleMessage("Switch theme"),
        "termsAndConditions":
            MessageLookupByLibrary.simpleMessage("Terms And Conditions"),
        "testErrorScreen":
            MessageLookupByLibrary.simpleMessage("Test Error Handler"),
        "testFailureRequest":
            MessageLookupByLibrary.simpleMessage("Test Failure Request"),
        "testSuccessRequest":
            MessageLookupByLibrary.simpleMessage("Test Success Request"),
        "testValidatorRequest":
            MessageLookupByLibrary.simpleMessage("Test Validator Request"),
        "thankYouForReporting":
            MessageLookupByLibrary.simpleMessage("Thank you for reporting"),
        "ticket": MessageLookupByLibrary.simpleMessage("Ticket"),
        "ticketDialogText": MessageLookupByLibrary.simpleMessage(
            "Please write your concern and will reply during 24h"),
        "ticketNumber": MessageLookupByLibrary.simpleMessage("Ticket Number"),
        "translationTest":
            MessageLookupByLibrary.simpleMessage("Translation Test"),
        "tryEnablingItFromYourPhoneSettings":
            MessageLookupByLibrary.simpleMessage(
                "Try enabling it from your phone settings"),
        "type": MessageLookupByLibrary.simpleMessage("Type"),
        "unauthorized": MessageLookupByLibrary.simpleMessage("Unauthorized"),
        "unknownError": MessageLookupByLibrary.simpleMessage(
            "Unknown error occurred, please try again"),
        "update": MessageLookupByLibrary.simpleMessage("Update"),
        "updateMessage": MessageLookupByLibrary.simpleMessage(
            "For the best experience, update to the latest version to get new features and improvements."),
        "updateProfile": MessageLookupByLibrary.simpleMessage("Update profile"),
        "updateTitle": MessageLookupByLibrary.simpleMessage("Update Required"),
        "updatedSuccessfully":
            MessageLookupByLibrary.simpleMessage("Updated Successfully"),
        "userDoesNotExist":
            MessageLookupByLibrary.simpleMessage("User doesn\'t exist"),
        "userName": MessageLookupByLibrary.simpleMessage("User name"),
        "welcome": MessageLookupByLibrary.simpleMessage("Welcome"),
        "yourTicketSubmittedSuccessfully": MessageLookupByLibrary.simpleMessage(
            "Your ticket has been submitted successfully, we will contact you ASAP"),
        "yourTicketSubmittedSuccessfullyTitle":
            MessageLookupByLibrary.simpleMessage("Ticket Created Successfully")
      };
}

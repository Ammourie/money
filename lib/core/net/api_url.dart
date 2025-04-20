/// API
class APIUrls {
  /// Domain url
  static const BASE_URL = "https://starter.osousdev.com/api/api/";

  // Home
  static const API_HOME_INIT = "Customer/Home/Init";

  // Account
  static const API_REGISTER = "Customer/Account/Register";
  static const API_LOGIN = "Customer/Account/RegisterOrLogin";
  static const API_PROFILE = "Customer/Account/MyProfile";
  static const API_UPDATE_PROFILE = "Customer/Account/UpdateMyProfile";
  static const API_CONFIRM_NEW_PHONE_NUMBER =
      "Customer/Account/ConfirmPhoneNumber";
  static const API_RESEND_NEW_PHONE_NUMBER_CODE =
      "Customer/Account/ReSendNewPhoneConfirmationCode";
  static const API_RESEND_CODE =
      "Customer/Account/ReSendPhoneNumberConfirmationCodeUsingOTP";
  static const API_CHANGE_NOTIFICATION_STATUS =
      "Customer/Account/TurnOnOrOffNotifications";
  static const API_ADD_OR_UPDATE_FIREBASE_TOKEN =
      "Customer/Account/AddOrUpdateFireBaseToken";
  static const API_DELETE_MY_ACCOUNT = "Customer/Account/DeleteMyAccount";
  static const API_CONFIRM_DELETE_ACCOUNT =
      "Customer/Account/ConfirmDeleteAccount";
  static const API_RESEND_DELETE_ACCOUNT_CODE =
      "Customer/Account/ReSendDeletionCode";

  // City
  static const API_CITY_DETAILS = "Customer/City/Details";
  static const API_CITY_LIST = "Customer/City/List";
  static const API_CITY_SEARCH = "Customer/City/Search";

  // Ticket
  static const API_MY_TICKETS = "Customer/Ticket/List";
  static const API_CREATE_TICKET = "Customer/Ticket/Create";

  // FAQs
  static const API_FAQ_SECTIONS_LIST = "Customer/FAQSection/List";

  // Notification
  static const API_NOTIFICATION_LIST = "Customer/Notification/MyNotifications";

  // AuditLog
  static const API_REPORT_PROBLEM = "Customer/AuditLog/ReportError";

  // TokenAuth
  static const API_CONFIRM_CODE = "TokenAuth/ConfirmCode";

  // Blogs
  static const BLOG_LIST = "Customer/Blog/List";
  static const BLOG_DETAILS = "Customer/Blog/Details";
}

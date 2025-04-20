import '../../../../core/common/app_config.dart';
import '../../../../core/common/type_validators.dart';
import '../../../../core/constants/enums/system_type.dart';
import '../../../../core/models/base_model.dart';
import '../../../category/model/response/category_section_model.dart';
import '../../../category/model/response/category_with_children_model.dart';
import 'banner_model.dart';

class HomeInitModel extends BaseModel {
  final bool isNotificationOn;
  final List<CategoryWithChildrenModel> categoriesWithChildren;
  final String aboutUsPage;
  final String contactUsPage;
  final String privacyPolicyPage;
  final String termAndConditionsPage;
  final bool isEmailRegistrationEnabled;
  final bool isPhoneNumberRegistrationEnabled;
  final List<BannerModel> banners;
  final _ConfigsModel? configs;
  final List<CategorySectionModel> homePageCategoriesSection;
  final List<CategorySectionModel> homePageParentCategories;

  HomeInitModel({
    required this.isNotificationOn,
    required this.categoriesWithChildren,
    required this.aboutUsPage,
    required this.contactUsPage,
    required this.privacyPolicyPage,
    required this.termAndConditionsPage,
    required this.isEmailRegistrationEnabled,
    required this.isPhoneNumberRegistrationEnabled,
    required this.banners,
    required this.configs,
    required this.homePageCategoriesSection,
    required this.homePageParentCategories,
  });

  final _currentBuild = int.tryParse(AppConfig().buildNumber) ?? 1;

  bool get needUpdate =>
      (AppConfig().os == SystemType.Android
          ? configs?.androidAppVersion ?? 0
          : configs?.iosAppVersion ?? 0) >
      _currentBuild;
  bool get forceUpdate =>
      (AppConfig().os == SystemType.Android
          ? configs?.lastAndroidSupportedAppVersion ?? 0
          : configs?.lastIosSupportedAppVersion ?? 0) >
      _currentBuild;
  String? get appVersionUrl => AppConfig().os == SystemType.Android
      ? configs?.androidAppVersionUrl
      : configs?.iosAppVersionUrl;

  factory HomeInitModel.fromJson(Map<String, dynamic> json) => HomeInitModel(
        isNotificationOn: boolV(json["isNotificationOn"]),
        categoriesWithChildren: json["categoriesWithChildren"] == null
            ? []
            : List<CategoryWithChildrenModel>.from(
                json["categoriesWithChildren"]
                    .map((x) => CategoryWithChildrenModel.fromJson(x))),
        aboutUsPage: stringV(json["staticPages"]?["aboutUsPage"]),
        contactUsPage: stringV(json["staticPages"]?["contactUsPage"]),
        privacyPolicyPage: stringV(json["staticPages"]?["privacyPolicyPage"]),
        termAndConditionsPage:
            stringV(json["staticPages"]?["termAndConditionsPage"]),
        isEmailRegistrationEnabled:
            boolV(json["featurePlugins"]?["isEmailRegistrationEnabled"]),
        isPhoneNumberRegistrationEnabled:
            boolV(json["featurePlugins"]?["isPhoneNumberRegistrationEnabled"]),
        banners: json["banners"] == null
            ? []
            : List<BannerModel>.from(
                json["banners"].map((x) => BannerModel.fromJson(x))),
        configs: json["configs"] == null
            ? null
            : _ConfigsModel.fromJson(json["configs"]),
        homePageCategoriesSection: json["homePageCategoriesSection"] == null
            ? []
            : List<CategorySectionModel>.from(json["homePageCategoriesSection"]
                .map((x) => CategorySectionModel.fromJson(x))),
        homePageParentCategories: json["homePageParentCategories"] == null
            ? []
            : List<CategorySectionModel>.from(json["homePageParentCategories"]
                .map((x) => CategorySectionModel.fromJson(x))),
      );
}

class _ConfigsModel extends BaseModel {
  final String androidAppVersionUrl;
  final int androidAppVersion;
  final int lastAndroidSupportedAppVersion;
  final String iosAppVersionUrl;
  final int iosAppVersion;
  final int lastIosSupportedAppVersion;
  final String supportWhatsappNumber;
  final String supportPhoneNumber;
  final String supportEmail;
  final String facebook;
  final String instagram;
  final String twitter;
  final String snapchat;
  final String youtube;
  final double? defaultLongitude;
  final double? defaultLatitude;
  final String websiteUrl;
  final String logoUrl;
  final String logoWithNameUrl;
  final String primaryColor;
  final String secondaryColor;
  final String secondaryAccentColor;
  final String successColor;

  _ConfigsModel({
    required this.androidAppVersionUrl,
    required this.androidAppVersion,
    required this.lastAndroidSupportedAppVersion,
    required this.iosAppVersionUrl,
    required this.iosAppVersion,
    required this.lastIosSupportedAppVersion,
    required this.supportWhatsappNumber,
    required this.supportPhoneNumber,
    required this.supportEmail,
    required this.facebook,
    required this.instagram,
    required this.twitter,
    required this.snapchat,
    required this.youtube,
    required this.defaultLongitude,
    required this.defaultLatitude,
    required this.websiteUrl,
    required this.logoUrl,
    required this.logoWithNameUrl,
    required this.primaryColor,
    required this.secondaryColor,
    required this.secondaryAccentColor,
    required this.successColor,
  });

  factory _ConfigsModel.fromJson(Map<String, dynamic> json) => _ConfigsModel(
        androidAppVersionUrl: stringV(json["androidAppVersionUrl"]),
        androidAppVersion: numV(json["androidAppVersion"]) ?? 0,
        lastAndroidSupportedAppVersion:
            numV(json["lastAndroidSupportedAppVersion"]) ?? 0,
        iosAppVersionUrl: stringV(json["iosAppVersionUrl"]),
        iosAppVersion: numV(json["iosAppVersion"]) ?? 0,
        lastIosSupportedAppVersion:
            numV(json["lastIosSupportedAppVersion"]) ?? 0,
        supportWhatsappNumber: stringV(json["supportWhatsappNumber"]),
        supportPhoneNumber: stringV(json["supportPhoneNumber"]),
        supportEmail: stringV(json["supportEmail"]),
        facebook: stringV(json["facebook"]),
        instagram: stringV(json["instagram"]),
        twitter: stringV(json["twitter"]),
        snapchat: stringV(json["snapchat"]),
        youtube: stringV(json["youtube"]),
        defaultLongitude: numV(json["defaultLongitude"]),
        defaultLatitude: numV(json["defaultLatitude"]),
        websiteUrl: stringV(json["websiteUrl"]),
        logoUrl: stringV(json["logoUrl"]),
        logoWithNameUrl: stringV(json["logoWithNameUrl"]),
        primaryColor: stringV(json["primaryColor"]),
        secondaryColor: stringV(json["secondaryColor"]),
        secondaryAccentColor: stringV(json["secondaryAccentColor"]),
        successColor: stringV(json["successColor"]),
      );
}

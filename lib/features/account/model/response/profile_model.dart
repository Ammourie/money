import '../../../../core/common/type_validators.dart';
import '../../../../core/constants/enums/gender_enum.dart';
import '../../../../core/models/base_model.dart';

class ProfileModel extends BaseModel {
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String emailAddress;
  final bool isNotificationOn;
  final int? unSeenNotification;
  final DateTime? dateOfBirth;
  final GenderEnum gender;
  final String genderText;

  ProfileModel({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.emailAddress,
    required this.isNotificationOn,
    required this.unSeenNotification,
    required this.dateOfBirth,
    required this.gender,
    required this.genderText,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        firstName: stringV(json["firstName"]),
        lastName: stringV(json["lastName"]),
        phoneNumber: stringV(json["phoneNumber"]),
        emailAddress: stringV(json["emailAddress"]),
        isNotificationOn: boolV(json["isNotificationOn"]),
        unSeenNotification: numV(json["unSeenNotification"]),
        dateOfBirth: dateTimeV(json["dateOfBirth"]),
        gender: GenderEnum.mapToType(json["gender"]),
        genderText: stringV(json["genderText"]),
      );

  ProfileModel copyWith({
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? emailAddress,
    bool? isNotificationOn,
    int? unSeenNotification,
    DateTime? dateOfBirth,
    GenderEnum? gender,
    String? genderText,
  }) {
    return ProfileModel(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      emailAddress: emailAddress ?? this.emailAddress,
      isNotificationOn: isNotificationOn ?? this.isNotificationOn,
      unSeenNotification: unSeenNotification != null
          ? unSeenNotification
          : this.unSeenNotification,
      dateOfBirth: dateOfBirth != null ? dateOfBirth : this.dateOfBirth,
      gender: gender ?? this.gender,
      genderText: genderText ?? this.genderText,
    );
  }
}

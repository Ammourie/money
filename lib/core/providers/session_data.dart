import 'package:flutter/foundation.dart';

import '../../features/account/model/response/profile_model.dart';
import '../../features/account/model/response/user_model.dart';
import '../../features/home/model/response/home_init_model.dart';
import '../constants/enums/gender_enum.dart';

class SessionData extends ChangeNotifier {
  ProfileModel? profile;
  HomeInitModel? homeInit;
  UserModel? user;
  void updateProfile({
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
    profile = profile?.copyWith(
      firstName: firstName,
      lastName: lastName,
      phoneNumber: phoneNumber,
      emailAddress: emailAddress,
      isNotificationOn: isNotificationOn,
      unSeenNotification: unSeenNotification,
      dateOfBirth: dateOfBirth,
      gender: gender,
      genderText: genderText,
    );
  }
}

import '../../../../core/constants/enums/gender_enum.dart';
import '../../../../core/params/base_params.dart';

class UpdateProfileParam extends BaseParams {
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final String? emailAddress;
  final DateTime? dateOfBirth;
  final GenderEnum? gender;

  UpdateProfileParam({
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.emailAddress,
    this.dateOfBirth,
    this.gender,
  });

  @override
  Map<String, dynamic> toMap() => {
        if (firstName != null) "firstName": firstName,
        if (lastName != null) "lastName": lastName,
        if (phoneNumber != null) "phoneNumber": phoneNumber,
        if (dateOfBirth != null) "dateOfBirth": dateOfBirth!.toIso8601String(),
        if (emailAddress != null && emailAddress!.isNotEmpty)
          "emailAddress": emailAddress,
        if (gender != null) "gender": gender!.value,
      };
}

import '../../../../core/constants/enums/gender_enum.dart';
import '../../../../core/params/base_params.dart';

class RegisterParam extends BaseParams {
  RegisterParam({
    super.cancelToken,
    required this.emailAddress,
    required this.name,
    required this.phoneNumber,
    required this.surname,
    required this.dateOfBirth,
    required this.gender,
  });

  final String? emailAddress;
  final String name;
  final String surname;
  final String phoneNumber;
  final DateTime? dateOfBirth;
  final GenderEnum? gender;

  Map<String, dynamic> toMap() => {
        "name": name,
        "surname": surname,
        "phoneNumber": phoneNumber,
        if (emailAddress != null) "emailAddress": emailAddress,
        if (dateOfBirth != null) "dateOfBirth": dateOfBirth!.toIso8601String(),
        if (gender != null) "gender": gender!.value,
      };
}

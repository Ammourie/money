import '../../../../../../../core/constants/enums/system_type.dart';
import '../../../../../../../core/params/base_params.dart';

class AddOrUpdateFirebaseTokenParam extends BaseParams {
  final String deviceId;
  final SystemType deviceType;
  final String? newToken;
  final String? oldToken;

  AddOrUpdateFirebaseTokenParam({
    required this.deviceId,
    required this.deviceType,
    required this.newToken,
    required this.oldToken,
  });

  @override
  Map<String, dynamic> toMap() => {
        "deviceId": deviceId,
        "deviceType": deviceType.index + 1,
        "newToken": newToken,
        "oldToken": oldToken,
        "timeDifferance": DateTime.now().toLocal().timeZoneOffset.inHours,
      };
}

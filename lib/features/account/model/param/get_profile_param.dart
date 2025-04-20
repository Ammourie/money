import '../../../../core/params/base_params.dart';

class GetProfileParam extends BaseParams {
  final String? deviceId;

  GetProfileParam({super.cancelToken, required this.deviceId});

  @override
  Map<String, dynamic> toMap() => {
        if (deviceId != null) "deviceId": deviceId,
      };
}

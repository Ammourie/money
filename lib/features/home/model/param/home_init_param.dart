import '../../../../core/params/base_params.dart';

class HomeInitParam extends BaseParams {
  final String? deviceId;

  HomeInitParam({super.cancelToken, required this.deviceId});

  @override
  Map<String, dynamic> toMap() => {if (deviceId != null) 'deviceId': deviceId};
}

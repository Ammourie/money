import '../../../../../core/params/base_params.dart';

class ChangeNotificationStatusParam extends BaseParams {
  final bool status;

  ChangeNotificationStatusParam({
    required this.status,
  });

  @override
  Map<String, dynamic> toMap() => {"status": status};
}

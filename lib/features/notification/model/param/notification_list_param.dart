import '../../../../core/params/base_params.dart';
import '../../../../core/params/page_param.dart';

class NotificationListParam extends BaseParams {
  NotificationListParam({super.cancelToken, required this.pageParam});
  final PageParam pageParam;

  @override
  Map<String, dynamic> toMap() => pageParam.toMap()..addAll({});
}

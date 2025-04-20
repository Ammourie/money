import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../../core/common/view_model/base_view_model.dart';
import '../../../core/errors/app_errors.dart';
import '../../../core/params/page_param.dart';
import '../../../core/results/result.dart';
import '../../../di/service_locator.dart';
import '../../../services/api.dart';
import '../../../services/api_cubit/api_cubit.dart';
import '../model/param/notification_list_param.dart';
import '../model/response/notification_list_model.dart';
import '../view/notification_list_view.dart';

class NotificationListViewModel
    extends BaseViewModel<NotificationListViewParam> {
  NotificationListViewModel(super.param);

  final notificationsCubit = ApiCubit();
  final refreshController = RefreshController();
  late List<NotificationModel> _notifications;

  // set, get
  List<NotificationModel> get notifications => _notifications;
  set notifications(List<NotificationModel> v) {
    _notifications = v;
    if (hasListeners) notifyListeners();
  }

  // methods
  void getNotifications() {
    notificationsCubit.getNotificationList(
      NotificationListParam(
        pageParam: PageParam(page: 0),
      ),
    );
  }

  Future<Result<AppErrors, List<NotificationModel>>> getItems(int page) async {
    final result = await getIt<Api>().getNotifications(
      NotificationListParam(
        pageParam: PageParam(page: page),
      ),
    );
    return Result(data: result.data?.items, error: result.error);
  }

  void onNotificationTap(int index) {}

  @override
  void closeModel() {
    notificationsCubit.close();
    refreshController.dispose();
    this.dispose();
  }
}

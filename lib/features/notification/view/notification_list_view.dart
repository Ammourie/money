import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../core/ui/error_ui/errors_screens/error_widget.dart';
import '../../../core/ui/screens/base_view.dart';
import '../../../core/ui/screens/empty_screen_wiget.dart';
import '../../../core/ui/widgets/custom_scaffold.dart';
import '../../../core/ui/widgets/pagination_widget.dart';
import '../../../core/ui/widgets/waiting_widget.dart';
import '../../../generated/l10n.dart';
import '../../../services/api_cubit/api_cubit.dart';
import '../view_model/notification_list_view_model.dart';

class NotificationListViewParam {}

class NotificationListView extends BaseView<NotificationListViewParam> {
  const NotificationListView({super.key, required super.param});

  static const String routeName = "/NotificationListView";

  @override
  State<NotificationListView> createState() => _NotificationListViewState();
}

class _NotificationListViewState extends State<NotificationListView> {
  late NotificationListViewModel vm;
  @override
  void initState() {
    super.initState();
    vm = NotificationListViewModel(widget.param);
    vm.getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: vm,
      child: CustomScaffold(
        appBar: AppBar(title: Text(S.current.notifications)),
        body: BlocConsumer<ApiCubit, ApiState>(
          bloc: vm.notificationsCubit,
          listener: (context, state) {
            state.maybeWhen(
              notificationListLoaded: (data) {
                vm.notifications = [...data.items];
              },
              orElse: () {},
            );
          },
          builder: (context, state) {
            return state.maybeWhen(
              initial: () => const WaitingWidget(),
              loading: () => const WaitingWidget(),
              error: (error, callback) =>
                  ErrorScreenWidget(error: error, callback: callback),
              notificationListLoaded: (_) => _buildContent(),
              orElse: () => const ScreenNotImplementedErrorWidget(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (vm.notifications.isEmpty) return const EmptyScreenWidget();

    return Builder(
      builder: (context) {
        context.watch<NotificationListViewModel>();

        return PaginationWidget(
          refreshController: vm.refreshController,
          initialItems: vm.notifications,
          getItems: vm.getItems,
          onDataFetched: (items, _) {
            vm.notifications = items;
          },
          child: ListView.separated(
            itemCount: vm.notifications.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () => vm.onNotificationTap(index),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(vm.notifications[index].title),
                      30.verticalSpace,
                      Text(vm.notifications[index].message),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (_, __) => Divider(
              height: 0,
              color: Colors.grey.shade200,
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    vm.closeModel();
    super.dispose();
  }
}

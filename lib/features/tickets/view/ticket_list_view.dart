import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app/app_constants.dart';
import '../../../core/params/page_param.dart';
import '../../../core/results/result.dart';
import '../../../core/ui/error_ui/errors_screens/error_widget.dart';
import '../../../core/ui/screens/base_view.dart';
import '../../../core/ui/screens/empty_screen_wiget.dart';
import '../../../core/ui/widgets/custom_scaffold.dart';
import '../../../core/ui/widgets/pagination_widget.dart';
import '../../../core/ui/widgets/waiting_widget.dart';
import '../../../di/service_locator.dart';
import '../../../generated/l10n.dart';
import '../../../services/api.dart';
import '../../../services/api_cubit/api_cubit.dart';
import '../view_model/ticket_list_view_model.dart';
import 'widgets/ticket_card.dart';

class TicketListViewParam {}

class TicketListView extends BaseView<TicketListViewParam> {
  const TicketListView({super.key, required super.param});

  static const String routeName = "/TicketListView";

  @override
  State<TicketListView> createState() => _TicketListViewState();
}

class _TicketListViewState extends State<TicketListView> {
  late TicketListViewModel vm;
  @override
  void initState() {
    super.initState();
    vm = TicketListViewModel(widget.param);
    vm.getTickets();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: vm,
      child: CustomScaffold(
        appBar: AppBar(
          title: Text(S.current.myTickets),
          actions: [
            IconButton(
              onPressed: vm.onAddTicketTap,
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: BlocConsumer<ApiCubit, ApiState>(
          bloc: vm.ticketsCubit,
          listener: (context, state) {
            state.maybeWhen(
              ticketsLoaded: (data) {
                vm.tickets = [...data.items];
              },
              orElse: () {},
            );
          },
          builder: (context, state) {
            return state.maybeWhen(
              initial: () => const WaitingWidget(),
              loading: () => const WaitingWidget(),
              error: (error, callback) {
                return ErrorScreenWidget(error: error, callback: callback);
              },
              ticketsLoaded: (_) => _buildContent(),
              orElse: () => const ScreenNotImplementedErrorWidget(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (vm.tickets.isEmpty) return const EmptyScreenWidget();

    return Builder(
      builder: (context) {
        context.watch<TicketListViewModel>();

        return PaginationWidget(
          refreshController: vm.refreshController,
          initialItems: vm.tickets,
          getItems: (page) async {
            final result = await getIt<Api>().getTickets(PageParam(page: page));
            return Result(data: result.data?.items, error: result.error);
          },
          onDataFetched: (items, _) {
            vm.tickets = items;
          },
          child: ListView.separated(
            padding: EdgeInsets.symmetric(
              horizontal: AppConstants.screenPadding,
            ),
            itemCount: vm.tickets.length,
            itemBuilder: (context, index) => TicketCard(
              ticket: vm.tickets[index],
              onTap: () => vm.onTicketTap(index),
            ),
            separatorBuilder: (context, index) => 16.verticalSpace,
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

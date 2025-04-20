import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../../core/common/view_model/base_view_model.dart';
import '../../../core/navigation/nav.dart';
import '../../../core/params/page_param.dart';
import '../../../services/api_cubit/api_cubit.dart';
import '../model/response/ticket_model.dart';
import '../view/ticket_details_view.dart';
import '../view/ticket_list_view.dart';
import '../view/widgets/add_ticket_dialog.dart';

class TicketListViewModel extends BaseViewModel<TicketListViewParam> {
  TicketListViewModel(super.param);

  final ticketsCubit = ApiCubit();
  final refreshController = RefreshController();
  late List<TicketModel> _tickets;

  // set, get
  List<TicketModel> get tickets => _tickets;
  set tickets(List<TicketModel> v) {
    _tickets = v;
    if (hasListeners) notifyListeners();
  }

  // methods
  void getTickets() {
    ticketsCubit.getTickets(PageParam(page: 0));
  }

  void onTicketTap(int index) {
    if (tickets[index].id != null) {
      Nav.to(
        TicketDetailsView.routeName,
        arguments: TicketDetailsViewParam(id: tickets[index].id!),
      );
    }
  }

  void onAddTicketTap() {
    showAddTicketDialog(onDone: getTickets);
  }

  @override
  void closeModel() {
    ticketsCubit.close();
    refreshController.dispose();
    this.dispose();
  }
}

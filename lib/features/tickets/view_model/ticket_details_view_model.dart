import '../../../core/common/view_model/base_view_model.dart';
import '../../../core/params/id_param.dart';
import '../../../services/api_cubit/api_cubit.dart';
import '../model/response/ticket_model.dart';
import '../view/ticket_details_view.dart';

class TicketDetailsViewModel extends BaseViewModel<TicketDetailsViewParam> {
  TicketDetailsViewModel(super.param);

  final ticketDetailsCubit = ApiCubit();
  late final TicketModel ticketDetails;

  // methods
  void getTicketDetails() {
    ticketDetailsCubit.ticketDetails(IdParam(param.id));
  }

  @override
  void closeModel() {
    ticketDetailsCubit.close();
    this.dispose();
  }
}

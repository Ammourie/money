import '../../../../core/common/type_validators.dart';
import '../../../../core/models/base_model.dart';
import 'ticket_model.dart';

class TicketListModel extends BaseModel {
  final List<TicketModel> items;
  final int? totalCount;

  TicketListModel({
    required this.items,
    required this.totalCount,
  });

  factory TicketListModel.fromMap(Map<String, dynamic> json) {
    return TicketListModel(
      items: json["items"] == null
          ? []
          : List.from(json["items"].map((x) => TicketModel.fromMap(x))),
      totalCount: numV(json["totalCount"]),
    );
  }
}

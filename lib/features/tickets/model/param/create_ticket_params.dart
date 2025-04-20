import '../../../../../core/constants/enums/ticket_type.dart';
import '../../../../../core/params/base_params.dart';

class CreateTicketParams extends BaseParams {
  final TicketType type;
  final String message;

  CreateTicketParams({
    super.cancelToken,
    required this.type,
    required this.message,
  });

  @override
  Map<String, dynamic> toMap() => {"type": type.value, "message": message};
}

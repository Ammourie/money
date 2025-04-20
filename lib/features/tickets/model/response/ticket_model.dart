import '../../../../../core/common/type_validators.dart';
import '../../../../../core/models/base_model.dart';
import '../../../../core/constants/enums/ticket_type.dart';
import '../../../../core/models/name_model.dart';

class TicketModel extends BaseModel {
  final DateTime? creationTime;
  final int? id;
  final bool isActive;
  final NameModel? creatorUser;
  final String message;
  final bool isResolved;
  final String creationTimeText;
  final String typeText;
  final String answer;
  final TicketType type;
  final String replyTimeText;
  final DateTime? replyTime;

  TicketModel({
    required this.creationTime,
    required this.answer,
    required this.replyTime,
    required this.replyTimeText,
    required this.id,
    required this.isActive,
    required this.creatorUser,
    required this.message,
    required this.isResolved,
    required this.creationTimeText,
    required this.typeText,
    required this.type,
  });

  factory TicketModel.fromMap(Map<String, dynamic> map) {
    return TicketModel(
      creationTime: dateTimeV(map['creationTime']),
      replyTime: dateTimeV(map['replyTime']),
      id: numV(map['id']),
      isActive: boolV(map['isActive']),
      creatorUser: map['creatorUser'] != null
          ? NameModel.fromMap(map['creatorUser'])
          : null,
      message: stringV(map['message']),
      replyTimeText: stringV(map['replyTimeText']),
      answer: stringV(map['answer']),
      isResolved: boolV(map['isResolved']),
      creationTimeText: stringV(map['creationTimeText']),
      typeText: stringV(map['typeText']),
      type: TicketType.mapToType(numV(map['type'])),
    );
  }
}

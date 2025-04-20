import '../../../../core/common/type_validators.dart';
import '../../../../core/constants/enums/link_to_enum.dart';
import '../../../../core/constants/enums/notification_type.dart';
import '../../../../core/models/base_model.dart';

class NotificationListModel extends BaseModel {
  final List<NotificationModel> items;
  final int? totalCount;
  final int? unSeenCount;

  NotificationListModel({
    required this.items,
    required this.totalCount,
    required this.unSeenCount,
  });

  factory NotificationListModel.fromMap(Map<String, dynamic> json) {
    return NotificationListModel(
      items: json["items"] == null
          ? []
          : List.from(json["items"].map((x) => NotificationModel.fromMap(x))),
      totalCount: numV(json["totalCount"]),
      unSeenCount: numV(json["unSeenCount"]),
    );
  }
}

class NotificationModel extends BaseModel {
  final String title;
  final String message;
  final NotificationType notificationType;
  final String notificationTypeText;
  final DateTime? creationTime;
  final String creationTimeText;
  final String id;
  final int? entityId;
  final bool isSeen;
  final LinkToEnum linkTo;
  final String linkToText;
  final String entityName;

  NotificationModel({
    required this.notificationType,
    required this.notificationTypeText,
    required this.creationTime,
    required this.creationTimeText,
    required this.id,
    required this.entityId,
    required this.isSeen,
    required this.linkTo,
    required this.linkToText,
    required this.entityName,
    required this.title,
    required this.message,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> json) =>
      NotificationModel(
        notificationType:
            NotificationType.mapToType(numV(json["notificationType"])),
        notificationTypeText: stringV(json["notificationTypeText"]),
        creationTime: dateTimeV(json["creationTime"]),
        creationTimeText: stringV(json["creationTimeText"]),
        id: stringV(json["id"]),
        title: stringV(json["currentTranslation"]?["title"]),
        message: stringV(json["currentTranslation"]?["message"]),
        entityId: numV(json["entityId"]),
        isSeen: boolV(json["isSeen"]),
        linkTo: LinkToEnum.mapToType(numV(json["linkTo"])),
        linkToText: stringV(json["linkToText"]),
        entityName: stringV(json["entityName"]),
      );
}

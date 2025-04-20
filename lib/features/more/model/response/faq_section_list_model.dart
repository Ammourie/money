import '../../../../../core/common/type_validators.dart';
import '../../../../../core/models/base_model.dart';

class FaqSectionListModel extends BaseModel {
  final List<FaqSectionModel> items;
  final int? totalCount;

  FaqSectionListModel({
    required this.items,
    required this.totalCount,
  });

  factory FaqSectionListModel.fromJson(Map<String, dynamic> json) =>
      FaqSectionListModel(
        items: List<FaqSectionModel>.from(
            listV(json["items"]).map((x) => FaqSectionModel.fromJson(x))),
        totalCount: numV(json["totalCount"]),
      );
}

class FaqSectionModel extends BaseModel {
  final String name;
  final List<FaqModel> faQs;
  final DateTime? creationTime;
  final String creationTimeText;
  final int? id;
  final bool isActive;

  FaqSectionModel({
    required this.name,
    required this.faQs,
    required this.creationTime,
    required this.creationTimeText,
    required this.id,
    required this.isActive,
  });
  factory FaqSectionModel.fromJson(Map<String, dynamic> json) =>
      FaqSectionModel(
        name: stringV(json["currentTranslation"]?["name"]),
        faQs: List<FaqModel>.from(
            listV(json["faQs"]).map((x) => FaqModel.fromMap(x))),
        creationTime: dateTimeV(json["creationTime"]),
        creationTimeText: stringV(json["creationTimeText"]),
        id: numV(json["id"]),
        isActive: boolV(json["isActive"]),
      );
}

class FaqModel extends BaseModel {
  final String question;
  final String answer;

  FaqModel({
    required this.question,
    required this.answer,
  });

  factory FaqModel.fromMap(Map<String, dynamic> json) => FaqModel(
        question: stringV(json['currentTranslation']?["question"]),
        answer: stringV(json['currentTranslation']?["answer"]),
      );
}

import '../../../../core/common/type_validators.dart';
import '../../../../core/constants/enums/blog_type.dart';
import '../../../../core/models/base_model.dart';

class BlogModel extends BaseModel {
  final int? id;
  final String title;
  final String shortDescription;
  final String longDescription;
  final List<String> tags;
  final String image;
  final BlogType type;
  final String typeText;

  BlogModel({
    required this.id,
    required this.title,
    required this.shortDescription,
    required this.longDescription,
    required this.tags,
    required this.image,
    required this.type,
    required this.typeText,
  });

  factory BlogModel.fromJson(Map<String, dynamic> json) => BlogModel(
        id: numV(json["id"]),
        title: stringV(json['currentTranslation']?["title"]),
        shortDescription:
            stringV(json['currentTranslation']?["shortDescription"]),
        longDescription:
            stringV(json['currentTranslation']?["longDescription"]),
        tags: List<String>.from(
            listV(json['currentTranslation']?["tags"]).map((x) => x)),
        image: stringV(json["image"]),
        type: BlogType.mapToType(numV(json["type"])),
        typeText: stringV(json["typeText"]),
      );
}

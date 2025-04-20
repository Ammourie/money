import '../../../../core/common/type_validators.dart';
import '../../../../core/models/base_model.dart';

class CategorySectionModel extends BaseModel {
  final int? id;
  final int? parentId;
  final String name;
  final String title;
  final String description;
  final String slug;
  final String backgroundColor;
  final String backgroundImage;
  final String icon;
  final bool isRoot;

  CategorySectionModel({
    required this.id,
    required this.parentId,
    required this.name,
    required this.title,
    required this.description,
    required this.slug,
    required this.backgroundColor,
    required this.backgroundImage,
    required this.icon,
    required this.isRoot,
  });

  factory CategorySectionModel.fromJson(Map<String, dynamic> json) =>
      CategorySectionModel(
        id: numV(json["id"]),
        parentId: numV(json["parentId"]),
        name: stringV(json["currentTranslation"]?["name"]),
        title: stringV(json["currentTranslation"]?["title"]),
        description: stringV(json["currentTranslation"]?["description"]),
        slug: stringV(json["slug"]),
        backgroundColor: stringV(json["backgroundColor"]),
        backgroundImage: stringV(json["backgroundImage"]),
        icon: stringV(json["icon"]),
        isRoot: boolV(json["isRoot"]),
      );
}

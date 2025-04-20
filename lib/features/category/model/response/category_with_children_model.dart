import '../../../../core/common/type_validators.dart';
import '../../../../core/models/base_model.dart';

class CategoryWithChildrenModel extends BaseModel {
  final int? id;
  final String name;
  final String title;
  final String description;
  final String slug;
  final List<CategoryWithChildrenModel> childrenCategories;

  CategoryWithChildrenModel({
    required this.id,
    required this.name,
    required this.title,
    required this.description,
    required this.slug,
    required this.childrenCategories,
  });

  factory CategoryWithChildrenModel.fromJson(Map<String, dynamic> json) =>
      CategoryWithChildrenModel(
        id: numV(json["id"]),
        name: stringV(json["currentTranslation"]?["name"]),
        title: stringV(json["currentTranslation"]?["title"]),
        description: stringV(json["currentTranslation"]?["description"]),
        slug: stringV(json["slug"]),
        childrenCategories: json["childrenCategories"] == null
            ? []
            : List<CategoryWithChildrenModel>.from(json["childrenCategories"]
                .map((x) => CategoryWithChildrenModel.fromJson(x))),
      );
}

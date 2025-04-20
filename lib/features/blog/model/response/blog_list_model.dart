import '../../../../core/common/type_validators.dart';
import '../../../../core/models/base_model.dart';
import 'blog_model.dart';

class BlogListModel extends BaseModel {
  final List<BlogModel> items;
  final int? totalCount;

  BlogListModel({
    required this.items,
    required this.totalCount,
  });

  factory BlogListModel.fromJson(Map<String, dynamic> json) => BlogListModel(
        items: List<BlogModel>.from(
            listV(json["items"]).map((x) => BlogModel.fromJson(x))),
        totalCount: numV(json["totalCount"]),
      );
}

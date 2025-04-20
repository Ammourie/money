import '../common/type_validators.dart';
import 'base_model.dart';

class FileModel extends BaseModel {
  final int? id;
  final String url;

  FileModel({
    required this.id,
    required this.url,
  });

  factory FileModel.fromJson(Map<String, dynamic> json) => FileModel(
        id: numV(json["id"]),
        url: stringV(json["url"]),
      );
}

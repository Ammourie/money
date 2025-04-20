import '../common/type_validators.dart';
import 'base_model.dart';

class NameModel extends BaseModel {
  NameModel({required this.id, required this.name});

  final int? id;
  final String name;

  factory NameModel.fromMap(Map<String, dynamic> json) => NameModel(
        id: numV(json["id"]),
        name: stringV(json["name"]),
      );
}

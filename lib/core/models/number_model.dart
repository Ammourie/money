import 'dart:convert';

import '../common/type_validators.dart';
import 'base_model.dart';

class NumberModel extends BaseModel {
  NumberModel({
    required this.value,
  });

  final int? value;

  factory NumberModel.fromJson(String str) =>
      NumberModel.fromMap(json.decode(str));

  factory NumberModel.fromMap(Map<String, dynamic> json) => NumberModel(
        value: numV(json["result"]),
      );
}

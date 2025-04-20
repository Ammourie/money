import 'dart:convert';

import '../../../../core/common/type_validators.dart';
import '../../../../core/models/base_model.dart';

class ConfirmCodeModel extends BaseModel {
  final String accessToken;

  ConfirmCodeModel({
    required this.accessToken,
  });

  factory ConfirmCodeModel.fromJson(String str) =>
      ConfirmCodeModel.fromMap(json.decode(str));

  factory ConfirmCodeModel.fromMap(Map<String, dynamic> json) =>
      ConfirmCodeModel(accessToken: stringV(json["accessToken"]));
}

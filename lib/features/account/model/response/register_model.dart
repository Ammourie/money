import 'dart:convert';

import '../../../../core/Common/type_validators.dart';
import '../../../../core/models/base_model.dart';

class RegisterModel extends BaseModel {
  RegisterModel({
    required this.userId,
  });

  final int? userId;

  factory RegisterModel.fromJson(String str) =>
      RegisterModel.fromMap(json.decode(str));

  factory RegisterModel.fromMap(Map<String, dynamic> json) =>
      RegisterModel(userId: numV(json["userId"]));
}

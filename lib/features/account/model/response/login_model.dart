import 'dart:convert';

import '../../../../core/common/type_validators.dart';
import '../../../../core/models/base_model.dart';

class LoginModel extends BaseModel {
  final String? token;
  final bool isUserExist;

  LoginModel({
    required this.token,
    required this.isUserExist,
  });

  factory LoginModel.fromJson(String str) =>
      LoginModel.fromMap(json.decode(str));

  factory LoginModel.fromMap(Map<String, dynamic> json) => LoginModel(
      token: stringV(json["token"]), isUserExist: boolV(json["isUserExist"]));
}

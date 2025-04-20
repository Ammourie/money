import 'package:dio/dio.dart';
import '../../../../../../../core/params/base_params.dart';

class LoginParam extends BaseParams {
  LoginParam({
    required this.phoneNumber,
    CancelToken? cancelToken,
  }) : super(cancelToken: cancelToken!);

  final String phoneNumber;

  Map<String, dynamic> toMap() => {"phoneNumber": phoneNumber};
}

import '../../../../core/params/base_params.dart';

class ConfirmCodeParam extends BaseParams {
  final String phoneNumber;
  final String code;

  ConfirmCodeParam({
    super.cancelToken,
    required this.phoneNumber,
    required this.code,
  });

  @override
  Map<String, dynamic> toMap() => {'phoneNumber': phoneNumber, 'code': code};
}

import '../../../../core/params/base_params.dart';

class ConfirmNewPhoneNumberParam extends BaseParams {
  final String confirmationCode;

  ConfirmNewPhoneNumberParam({
    super.cancelToken,
    required this.confirmationCode,
  });

  @override
  Map<String, dynamic> toMap() => {'confirmationCode': confirmationCode};
}

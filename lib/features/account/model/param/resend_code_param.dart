import '../../../../core/params/base_params.dart';

class ResendCodeParam extends BaseParams {
  final String phoneNumber;

  ResendCodeParam({super.cancelToken, required this.phoneNumber});

  @override
  Map<String, dynamic> toMap() => {'phoneNumber': phoneNumber};
}

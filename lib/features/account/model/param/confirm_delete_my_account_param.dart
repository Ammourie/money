import '../../../../core/params/base_params.dart';

class ConfirmDeleteMyAccountParam extends BaseParams {
  final String deletionCode;

  ConfirmDeleteMyAccountParam({
    super.cancelToken,
    required this.deletionCode,
  });

  @override
  Map<String, dynamic> toMap() => {'deletionCode': deletionCode};
}

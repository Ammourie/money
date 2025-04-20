import '../../../../../core/params/base_params.dart';

class ReportProblemParam extends BaseParams {
  final String errorMessage;

  ReportProblemParam({required this.errorMessage});
  @override
  Map<String, dynamic> toMap() => {"errorMessage": errorMessage};
}

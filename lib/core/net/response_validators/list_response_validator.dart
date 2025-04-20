import '../../../generated/l10n.dart';
import '../../errors/app_errors.dart';
import 'response_validator.dart';

class ListResponseValidator extends ResponseValidator {
  @override
  void processData(dynamic data) {
    if (!(data["result"] is List)) {
      error = AppErrors.customError(message: S.current.notValidResponse);
      errorMessage = S.current.notValidResponse;
    }
  }
}

import '../../../generated/l10n.dart';
import '../../errors/app_errors.dart';
import 'response_validator.dart';

class valueResponseValidator<T> extends ResponseValidator {
  @override
  void processData(dynamic data) {
    if (!(data is T)) {
      error = AppErrors.customError(message: S.current.notValidResponse);
      errorMessage = S.current.notValidResponse;
    }
  }
}

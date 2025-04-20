import '../../errors/app_errors.dart';
import 'response_validator.dart';

class DefaultResponseValidator extends ResponseValidator {
  @override
  void processData(dynamic data) {
    if (!(data["success"] ?? false)) {
      error = AppErrors.customError(message: data["error"]?["message"] ?? "");
      errorMessage = data["error"]?["message"] ?? "";
    }
  }
}

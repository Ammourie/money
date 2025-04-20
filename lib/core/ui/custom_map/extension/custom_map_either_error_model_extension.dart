import 'package:dartz/dartz.dart';

import '../../../errors/app_errors.dart';
import '../../../models/base_model.dart';
import '../api/datasource/map_result.dart';

extension customMapEitherErrorModel<Error extends AppErrors,
    Model extends BaseModel> on Either<Error, Model> {
  MapResult<Error, Model> get result {
    if (this.isRight()) {
      return MapResult(data: (this as Right<Error, Model>).value);
    } else
      return MapResult(error: (this as Left<Error, Model>).value);
  }
}

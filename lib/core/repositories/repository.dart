import 'package:dartz/dartz.dart';
import '../errors/app_errors.dart';
import '../results/result.dart';

abstract class Repository {
  Result<AppErrors, T> execute<T>({
    required Either<AppErrors, T> remoteResult,
  }) {
    if (remoteResult.isRight()) {
      return Result(
        data: (remoteResult as Right<AppErrors, T>).value,
      );
    } else {
      return Result(error: (remoteResult as Left<AppErrors, T>).value);
    }
  }

  Result<AppErrors, Object> executeForNoData({
    required Either<AppErrors, Object> remoteResult,
  }) {
    if (remoteResult.isRight()) {
      return Result(data: (remoteResult as Right<AppErrors, Object>).value);
    } else {
      return Result(error: (remoteResult as Left<AppErrors, Object>).value);
    }
  }
}

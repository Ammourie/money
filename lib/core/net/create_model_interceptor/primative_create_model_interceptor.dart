import 'create_model.interceptor.dart';

class PrimativeCreateModelInterceptor extends CreateModelInterceptor {
  const PrimativeCreateModelInterceptor();
  @override
  T getModel<T>(Function(dynamic p1) modelCreator, json) {
    return modelCreator(json);
  }
}

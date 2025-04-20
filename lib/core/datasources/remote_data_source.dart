import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

import '../../di/service_locator.dart';
import '../common/extensions/logger_extension.dart';
import '../errors/app_errors.dart';
import '../models/base_model.dart';
import '../net/create_model_interceptor/create_model.interceptor.dart';
import '../net/create_model_interceptor/default_create_model_inteceptor.dart';
import '../net/create_model_interceptor/primative_create_model_interceptor.dart';
import '../net/models_factory.dart';
import '../net/net.dart';
import '../net/response_validators/default_response_validator.dart';
import '../net/response_validators/list_response_validator.dart';
import '../net/response_validators/response_validator.dart';
import '../results/result.dart';

class RemoteDataSource {
  Future<Result<AppErrors, T>> requestUploadFile<T extends BaseModel>({
    required T Function(dynamic json) converter,
    required String url,
    required String fileKey,
    required String filePath,
    MediaType? mediaType,
    Map<String, dynamic>? data,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
    ResponseValidator? responseValidator,
    Map<String, String>? headers,
    Map<String, String>? queryParameters,
    String? baseUrl,
    CreateModelInterceptor createModelInterceptor =
        const DefaultCreateModelInterceptor(),
  }) async {
    // Register the response.
    ModelsFactory()
      ..registerModel(
        T.toString(),
        converter,
        createModelInterceptor.toString(),
        createModelInterceptor,
        false,
      );

    /// Send the request.
    final response = await getIt<HttpClient>().upload<T>(
      url: url,
      fileKey: fileKey,
      filePath: filePath,
      fileName: filePath.substring(filePath.lastIndexOf('/') + 1),
      mediaType: mediaType,
      data: data,
      headers: headers,
      queryParameters: queryParameters,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
      cancelToken: cancelToken,
      responseValidator: responseValidator ?? DefaultResponseValidator(),
      baseUrl: baseUrl,
    );

    /// convert jsonResponse to model and return it
    if (response.isLeft()) {
      return Result(error: (response as Left<AppErrors, T>).value);
    } else if (response.isRight()) {
      try {
        final resValue = (response as Right<AppErrors, T>).value;
        return Result(data: resValue);
      } catch (e) {
        e.toString().logE;
        return Result(
            error: const CustomError(
                message: "Catch error in remote data source"));
      }
    } else
      return Result(error: const UnknownError());
  }

  Future<Result<AppErrors, T>> request<T extends BaseModel>({
    required T Function(dynamic json) converter,
    required HttpMethod method,
    required String url,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? body,
    CancelToken? cancelToken,
    ResponseValidator? responseValidator,
    Map<String, String>? headers,
    String? baseUrl,
    bool isFormData = false,
    CreateModelInterceptor createModelInterceptor =
        const DefaultCreateModelInterceptor(),
  }) async {
    // Register the response.
    ModelsFactory()
      ..registerModel(
        T.toString(),
        converter,
        createModelInterceptor.toString(),
        createModelInterceptor,
        false,
      );

    /// Send the request.
    final response = await getIt<HttpClient>().sendRequest<T>(
      method: method,
      url: url,
      headers: headers,
      queryParameters: queryParameters ?? {},
      body: body,
      cancelToken: cancelToken,
      responseValidator: responseValidator ?? DefaultResponseValidator(),
      baseUrl: baseUrl,
      isFormData: isFormData,
    );

    /// convert jsonResponse to model and return it
    if (response.isLeft()) {
      return Result(error: (response as Left<AppErrors, T>).value);
    } else if (response.isRight()) {
      try {
        final resValue = (response as Right<AppErrors, T>).value;
        return Result(data: resValue);
      } catch (e) {
        e.toString().logE;
        return Result(
          error: const CustomError(
            message: "Catch error in remote data source",
          ),
        );
      }
    } else
      return Result(error: const UnknownError());
  }

  Future<Result<AppErrors, List<T>>> listRequest<T extends BaseModel>({
    required T Function(dynamic json) converter,
    required HttpMethod method,
    required String url,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? body,
    CancelToken? cancelToken,
    ResponseValidator? responseValidator,
    Map<String, String>? headers,
    String? baseUrl,
    bool isFormData = false,
    CreateModelInterceptor createModelInterceptor =
        const PrimativeCreateModelInterceptor(),
  }) async {
    // Register the response.
    ModelsFactory()
      ..registerModel(
        T.toString(),
        converter,
        createModelInterceptor.toString(),
        createModelInterceptor,
        true,
      );

    /// Send the request.
    final response = await getIt<HttpClient>().sendListRequest<T>(
      method: method,
      url: url,
      headers: headers,
      queryParameters: queryParameters ?? {},
      body: body,
      cancelToken: cancelToken,
      responseValidator: responseValidator ?? ListResponseValidator(),
      baseUrl: baseUrl,
      isFormData: isFormData,
    );

    /// convert jsonResponse to model and return it
    if (response.isLeft()) {
      return Result(error: (response as Left<AppErrors, List<T>>).value);
    } else if (response.isRight()) {
      try {
        final resValue = (response as Right<AppErrors, List<T>>).value;
        return Result(data: resValue);
      } catch (e) {
        e.toString().logE;
        return Result(
          error: const CustomError(
            message: "Catch error in remote data source",
          ),
        );
      }
    } else
      return Result(error: const UnknownError());
  }
}

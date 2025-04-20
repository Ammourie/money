import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../generated/l10n.dart';
import '../../services/api_cubit/api_cubit.dart';
import '../common/extensions/extensions.dart';
import '../constants/app/app_settings.dart';
import '../constants/enums/error_code_type.dart';
import '../constants/enums/http_method.dart';
import '../errors/app_errors.dart';
import '../models/base_model.dart';
import 'api_url.dart';
import 'interceptor.dart';
import 'models_factory.dart';
import 'response_validators/response_validator.dart';

@lazySingleton
class HttpClient {
  late Dio _client;

  Dio get instance => _client;

  HttpClient() {
    BaseOptions _options = BaseOptions(
      connectTimeout: const Duration(minutes: 2),
      receiveTimeout: const Duration(minutes: 2),
      sendTimeout: const Duration(minutes: 2),
      responseType: ResponseType.json,
      baseUrl: APIUrls.BASE_URL,
    );
    _client = Dio(_options);

    /// for alice inspector
    // _client.interceptors
    //     .add(getIt<AliceHttpInspector>().alice.getDioInterceptor());

    /// For logger
    if (AppSettings.enableDioPrinting) {
      _client.interceptors.add(
        PrettyDioLogger(
          requestBody: true,
          maxWidth: 270,
        ),
      );
    }

    /// For add Authentication into header
    /// [authorization] [os] [appversion] [session]
    _client.interceptors.add(AuthInterceptor());
  }

  Future<Either<AppErrors, T>> sendRequest<T extends BaseModel>({
    required HttpMethod method,
    required String url,
    required ResponseValidator responseValidator,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? body,
    CancelToken? cancelToken,
    String? baseUrl,
    bool isFormData = false,
  }) async {
    if (baseUrl != null) {
      _client.options.baseUrl = baseUrl;
    } else {
      _client.options.baseUrl = APIUrls.BASE_URL;
    }

    // Get the response from the server
    Response response;
    try {
      switch (method) {
        case HttpMethod.GET:
          response = await _client.get(
            url,
            queryParameters: queryParameters,
            options: Options(headers: headers),
            cancelToken: cancelToken,
          );
          break;
        case HttpMethod.POST:
          response = await _client.post(
            url,
            data: isFormData && body != null ? FormData.fromMap(body) : body,
            queryParameters: queryParameters,
            options: Options(headers: headers),
            cancelToken: cancelToken,
          );
          break;
        case HttpMethod.PUT:
          response = await _client.put(
            url,
            data: isFormData && body != null ? FormData.fromMap(body) : body,
            queryParameters: queryParameters,
            options: Options(headers: headers),
            cancelToken: cancelToken,
          );
          break;
        case HttpMethod.DELETE:
          response = await _client.delete(
            url,
            data: isFormData && body != null ? FormData.fromMap(body) : body,
            queryParameters: queryParameters,
            options: Options(headers: headers),
            cancelToken: cancelToken,
          );
          break;
        case HttpMethod.PATCH:
          response = await _client.patch(
            url,
            data: isFormData && body != null ? FormData.fromMap(body) : body,
            queryParameters: queryParameters,
            options: Options(headers: headers),
            cancelToken: cancelToken,
          );
          break;
      }
      // Get the decoded json
      /// json response like this
      /// {"data":"our data",
      /// "succeed":true of false,
      /// "message":"message if there is error"}
      /// response.data["succeed"] return true if request
      /// succeed and false if not so if was true we don't need
      /// return this value to model we just need the data
      var model;
      responseValidator.processData(response.data);

      if (responseValidator.isValid) {
        /// Here we send the data from response to Models factory
        /// to assign data as model
        try {
          model = ModelsFactory().createModel<T>(response.data, false);
        } catch (e, stacktrace) {
          stacktrace.toString().logE;
          return Left(CustomError(message: e.toString()));
        }
        return Right(model);
      } else if (responseValidator.hasError) {
        return Left(CustomError(message: responseValidator.errorMessage!));
      } else
        return Left(
          CustomError(
            message: S.current.generalErrorMessage,
          ),
        );
    }

    /// Handling errors
    on DioException catch (e, stacktrace) {
      stacktrace.toString().logE;
      return Left(_handleDioError(e));
    }

    /// Couldn't reach out the server
    on SocketException catch (e, stacktrace) {
      stacktrace.toString().logE;
      return const Left(SocketError());
    }
  }

  Future<Either<AppErrors, List<T>>> sendListRequest<T extends BaseModel>({
    required HttpMethod method,
    required String url,
    required ResponseValidator responseValidator,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? body,
    CancelToken? cancelToken,
    String? baseUrl,
    bool isFormData = false,
  }) async {
    if (baseUrl != null) {
      _client.options.baseUrl = baseUrl;
    } else {
      _client.options.baseUrl = APIUrls.BASE_URL;
    }

    // Get the response from the server
    Response response;
    try {
      switch (method) {
        case HttpMethod.GET:
          response = await _client.get(
            url,
            queryParameters: queryParameters,
            options: Options(headers: headers),
            cancelToken: cancelToken,
          );
          break;
        case HttpMethod.POST:
          response = await _client.post(
            url,
            data: isFormData && body != null ? FormData.fromMap(body) : body,
            queryParameters: queryParameters,
            options: Options(headers: headers),
            cancelToken: cancelToken,
          );
          break;
        case HttpMethod.PUT:
          response = await _client.put(
            url,
            data: isFormData && body != null ? FormData.fromMap(body) : body,
            queryParameters: queryParameters,
            options: Options(headers: headers),
            cancelToken: cancelToken,
          );
          break;
        case HttpMethod.DELETE:
          response = await _client.delete(
            url,
            data: isFormData && body != null ? FormData.fromMap(body) : body,
            queryParameters: queryParameters,
            options: Options(headers: headers),
            cancelToken: cancelToken,
          );
          break;
        case HttpMethod.PATCH:
          response = await _client.patch(
            url,
            data: isFormData && body != null ? FormData.fromMap(body) : body,
            queryParameters: queryParameters,
            options: Options(headers: headers),
            cancelToken: cancelToken,
          );
          break;
      }
      // Get the decoded json
      /// json response like this
      /// {"data":"our data",
      /// "succeed":true of false,
      /// "message":"message if there is error"}
      /// response.data["succeed"] return true if request
      /// succeed and false if not so if was true we don't need
      /// return this value to model we just need the data
      var model;
      responseValidator.processData(response.data);

      if (responseValidator.isValid) {
        /// Here we send the data from response to Models factory
        /// to assign data as model
        try {
          model = (response.data['result'] as List)
              .map((e) => ModelsFactory().createModel<T>(e, true))
              .toList();
        } catch (e, stacktrace) {
          stacktrace.toString().logE;
          return Left(CustomError(message: e.toString()));
        }
        return Right(model);
      } else if (responseValidator.hasError) {
        return Left(CustomError(message: responseValidator.errorMessage!));
      } else
        return Left(
          CustomError(
            message: S.current.generalErrorMessage,
          ),
        );
    }

    /// Handling errors
    on DioException catch (e, stacktrace) {
      stacktrace.toString().logE;
      return Left(_handleDioError(e));
    }

    /// Couldn't reach out the server
    on SocketException catch (e, stacktrace) {
      stacktrace.toString().logE;
      return const Left(SocketError());
    }
  }

  Future<Either<AppErrors, T>> upload<T extends BaseModel>({
    required String url,
    required String fileKey,
    required String filePath,
    required String fileName,
    required ResponseValidator responseValidator,
    MediaType? mediaType,
    CancelToken? cancelToken,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    String? baseUrl,
  }) async {
    if (baseUrl != null) {
      _client.options.baseUrl = baseUrl;
    } else {
      _client.options.baseUrl = APIUrls.BASE_URL;
    }

    Map<String, dynamic> dataMap = {};
    if (data != null) {
      dataMap.addAll(data);
    }
    dataMap.addAll({
      fileKey: await MultipartFile.fromFile(
        filePath,
        filename: fileName,
        contentType: mediaType,
      )
    });
    try {
      final response = await _client.post(
        url,
        data: FormData.fromMap(dataMap),
        queryParameters: queryParameters,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
        options: Options(headers: headers),
        cancelToken: cancelToken,
      );

      // Get the decoded json
      /// json response like this
      /// {"data":"our data",
      /// "succeed":true of false,
      /// "message":"message if there is error"}
      /// response.data["succeed"] return true if request
      /// succeed and false if not so if was true we don't need
      /// return this value to model we just need the data
      var model;
      responseValidator.processData(response.data);

      if (responseValidator.isValid) {
        /// Here we send the data from response to Models factory
        /// to assign data as model
        try {
          model = ModelsFactory().createModel<T>(response.data, false);
        } catch (e, stacktrace) {
          stacktrace.toString().logE;
          return Left(CustomError(message: e.toString()));
        }
        return Right(model);
      } else if (responseValidator.hasError) {
        return Left(CustomError(message: responseValidator.errorMessage!));
      } else
        return const Left(UnknownError());
    }
    // Handling errors
    on DioException catch (e, stacktrace) {
      stacktrace.toString().logE;
      return Left(_handleDioError(e));
    }

    // Couldn't reach out the server
    on SocketException catch (e, stacktrace) {
      stacktrace.toString().logE;
      return const Left(SocketError());
    }
  }

  AppErrors _handleDioError<E>(DioException error) {
    if (error.type == DioExceptionType.unknown ||
        error.type == DioExceptionType.badResponse) {
      if (error.error is SocketException) return const SocketError();
      if (error.type == DioExceptionType.badResponse) {
        switch (error.response!.statusCode) {
          case 400:
            return BadRequestError(
                message:
                    error.response?.data['result']?['error']?['message'] ?? "");
          case 401:
            ApiCubit().logout();
            return const UnauthorizedError();
          case 403:
            ApiCubit().logout();
            return const ForbiddenError();
          case 404:
            return NotFoundError(error.requestOptions.path);
          case 409:
            return const ConflictError();
          case 422:
            return const BadRequestError();
          case 500:
            if (error.response?.data is Map) {
              if (error.response!.data?['error']?["message"] != null ||
                  error.response!.data?["error"]?["code"] != null) {
                final errorCode = int.tryParse(
                        error.response!.data?["error"]?['code']?.toString() ??
                            "") ??
                    500;
                return InternalServerWithDataError(
                  errorCode,
                  message: error.response?.data?['error']?["message"],
                  type: ErrorCodeType.mapToType(errorCode),
                );
              }
            }
            return const InternalServerError();
          default:
            return const UnknownError();
        }
      }
      return const UnknownError();
    } else {
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.sendTimeout ||
          error.type == DioExceptionType.receiveTimeout) {
        return const TimeoutError();
      } else if (error.type == DioExceptionType.cancel) {
        return CancelError(
          S.current.cancelErrorMessage,
        );
      } else
        return const UnknownError();
    }
  }
}

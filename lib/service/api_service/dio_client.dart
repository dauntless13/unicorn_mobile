import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart' hide Response;
import 'package:logger/logger.dart';

import '../../routes/app_routs.dart';
import '../session/session_helper.dart';
import 'api_constant.dart';

////*================================================================ DIO LIB USE TO dio: ^5.1.2 and above =================================================================////

class DioClient with ApiConstant {
  DioClient()
      : _dio = Dio(
          BaseOptions(
            baseUrl: ApiConstant.baseUrl,
            connectTimeout: const Duration(seconds: 180),
            receiveTimeout: const Duration(seconds: 180),
            responseType: ResponseType.json,
          ),
        )..interceptors.addAll([
            AuthorizationInterceptor(),
            LoggerInterceptor(),
          ]);

  late final Dio _dio;

  Dio getdio() {
    return _dio;
  }

  // HTTP request methods will go here

  Future<Response> postbycustom<T>(
    context,
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.post(path,
          data: data,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress);
      return response;
    } on DioException catch (err) {
      final errorMessage =
          DioExceptionHandler.fromDioError(err, context).toString();
      print('Error: 2  $errorMessage');
      print('Error: 2  ${err.response?.statusCode}');
      // if (errorMessage.toString().contains("Unauthenticated") ||
      //     err.response?.statusCode == 401) {
      //   await _handleUnauthorizedRedirect();
      // }
      return Future.error(errorMessage);
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<Response> putbycustom<T>(
    context,
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.put(path,
          data: data,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress);
      return response;
    } on DioException catch (err) {
      print('error:: $err');
      final errorMessage =
          DioExceptionHandler.fromDioError(err, context).toString();
      // if (errorMessage.toString().contains("Unauthenticated") ||
      //     err.response?.statusCode == 401) {
      //   await _handleUnauthorizedRedirect();
      // }
      return Future.error(errorMessage);
    } catch (e) {
      print('error:11 $e');
      return Future.error(e);
    }
  }

  Future<Response> getbycustom<T>(
    context,
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.get(path,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onReceiveProgress: onReceiveProgress);

      print('Response: $response');
      return response;
    } on DioException catch (err) {
      print('Error: 1  $err');
      final errorMessage =
          DioExceptionHandler.fromDioError(err, context).toString();
      print('Error: 2  $errorMessage');
      // if (errorMessage.toString().contains("Unauthenticated") ||
      //     err.response?.statusCode == 401) {
      //   await _handleUnauthorizedRedirect();
      // }
      throw errorMessage;
    } catch (e) {
      print('Error: 3 $e');
      throw e.toString();
    }
  }

  Future<Response> deletebycustom<T>(
    context,
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    data,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        data: data,
      );
      print('Response: $response');
      return response;
    } on DioException catch (err) {
      print('Error: 1  $err');
      final errorMessage =
          DioExceptionHandler.fromDioError(err, context).toString();
      print('Error: 2  $errorMessage');
      // if (errorMessage.toString().contains("Unauthenticated") ||
      //     err.response?.statusCode == 401) {
      //   await _handleUnauthorizedRedirect();
      // }
      throw errorMessage;
    } catch (e) {
      print('Error: 3 $e');
      throw e.toString();
    }
  }
}

bool _isHandlingUnauthorized = false;

Future<void> _handleUnauthorizedRedirect() async {
  if (_isHandlingUnauthorized) return;
  _isHandlingUnauthorized = true;

  try {
    await SessionHelper().clearLoginSession();
    void navigateToLogin() {
      if (Get.currentRoute != Routes.LOGINSCREEN) {
        Get.offAllNamed(Routes.LOGINSCREEN);
      }
    }

    final schedulerPhase = SchedulerBinding.instance.schedulerPhase;
    if (schedulerPhase == SchedulerPhase.persistentCallbacks ||
        schedulerPhase == SchedulerPhase.postFrameCallbacks) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        navigateToLogin();
      });
    } else {
      navigateToLogin();
    }
  } finally {
    Future.delayed(const Duration(milliseconds: 300), () {
      _isHandlingUnauthorized = false;
    });
  }
}

class DioExceptionHandler implements Exception {
  late String errorMessage;
  late String type;

  DioExceptionHandler.fromDioError(DioException dioError, context) {
    Logger()
        .wtf('Error::::::::: ${dioError.type}, Message: ${dioError.message}');
    switch (dioError.type) {
      case DioExceptionType.cancel:
        errorMessage =
            dioError.response?.data['message'] ?? 'Request was cancelled';
        // NkCommonFunction.showError('Error', errorMessage, context);
        break;
      case DioExceptionType.connectionTimeout:
        errorMessage = dioError.message ?? 'Connection timeout';
        // NkCommonFunction.showError('Error', errorMessage, context);
        break;
      case DioExceptionType.receiveTimeout:
        errorMessage = dioError.response?.data['message'] ?? 'Receive timeout';
        // NkCommonFunction.showError('Error', errorMessage, context);
        break;
      case DioExceptionType.sendTimeout:
        errorMessage = dioError.response?.data['message'] ?? 'Send timeout';
        // NkCommonFunction.showError('Error', errorMessage, context);
        break;
      case DioExceptionType.badResponse:
        errorMessage = dioError.response?.data['message'] ??
            'Bad response (Status: ${dioError.response?.statusCode})';
        Get.back();
        // NkCommonFunction.showError('Error', errorMessage, context);
        break;
      case DioExceptionType.badCertificate:
        errorMessage =
            dioError.response?.data['message'] ?? 'Invalid certificate';
        // NkCommonFunction.showError('Error', errorMessage, context);
        break;
      case DioExceptionType.connectionError:
        errorMessage = dioError.message ?? 'Connection error';
        // NkCommonFunction.showError('Error', errorMessage, context);
        break;
      default:
        errorMessage = dioError.message ?? 'An unexpected error occurred';
        // NkCommonFunction.showError('Error', errorMessage, context);
        break;
    }
    print('Error:122 $errorMessage');
  }

  @override
  String toString() => errorMessage;
}

class AuthorizationInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (_needAuthorizationHeader(options)) {}
    // continue with the request
    super.onRequest(options, handler);
  }

  bool _needAuthorizationHeader(RequestOptions options) {
    if (options.method == 'GET') {
      return false;
    } else {
      return true;
    }
  }
}

class LoggerInterceptor extends Interceptor {
  Logger logger = Logger(
    // Customize the printer
    printer: PrettyPrinter(
      methodCount: 0,
      colors: true,
      printEmojis: true,
      printTime: false,
    ),
  );

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final options = err.requestOptions;
    final requestPath = '${options.baseUrl}${options.path}';
    logger.e('${options.method} request => $requestPath'); // Debug log
    logger.d('Error: ${err.error}, Message: ${err.message}'); // Error log
    if (err.response?.statusCode == 401) {
      await _handleUnauthorizedRedirect();
    }
    return super.onError(err, handler);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final requestPath = '${options.baseUrl}${options.path}';
    logger.i('${options.method} request => $requestPath'); // Info log
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    logger.d(
        'StatusCode: ${response.statusCode}, Data: ${response.data}'); // Debug log
    return super.onResponse(response, handler);
  }
}

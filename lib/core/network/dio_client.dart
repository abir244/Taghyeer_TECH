import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import '../constants/api_endpoints.dart';
import '../utils/storage_service.dart';

class DioClient {
  static Dio? _dio;

  static Dio get instance {
    _dio ??= _createDio();
    return _dio!;
  }

  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 15),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    dio.interceptors.addAll([
      _AuthInterceptor(),
      _LogInterceptor(),
    ]);

    return dio;
  }

  static void reset() => _dio = null;
}

class _AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = StorageService.getToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      StorageService.clearAll();
      Get.offAllNamed('/login');
    }
    handler.next(err);
  }
}

class _LogInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('→ [${options.method}] ${options.uri}');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('← [${response.statusCode}] ${response.requestOptions.uri}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print('✗ [ERROR] ${err.requestOptions.uri} → ${err.message}');
    handler.next(err);
  }
}

// Centralized error handler
String handleDioError(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return 'Connection timed out. Please check your internet.';
    case DioExceptionType.connectionError:
      return 'No internet connection. Please try again.';
    case DioExceptionType.badResponse:
      final status = e.response?.statusCode;
      if (status == 400) return 'Invalid request. Please check your input.';
      if (status == 401) return 'Unauthorized. Please login again.';
      if (status == 403) return 'Access denied.';
      if (status == 404) return 'Resource not found.';
      if (status == 500) return 'Server error. Please try again later.';
      return 'Something went wrong (Error $status).';
    case DioExceptionType.cancel:
      return 'Request was cancelled.';
    default:
      return 'Unexpected error. Please try again.';
  }
}

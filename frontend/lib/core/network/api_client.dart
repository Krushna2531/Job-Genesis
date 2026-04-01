import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'api_endpoints.dart';
import 'secure_storage.dart';

class ApiClient {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  )..interceptors.add(_AuthInterceptor())
   ..interceptors.add(LogInterceptor(
     requestBody: kDebugMode,
     responseBody: kDebugMode,
     logPrint: (obj) => debugPrint(obj.toString()),
   ));

  static Dio get instance => _dio;
}

class _AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await SecureStorage.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // If we receive a 401 Unauthorized, we could trigger a logout event here
    if (err.response?.statusCode == 401) {
      SecureStorage.deleteAll();
      // NOTE: Might want to notify the UI to redirect to login
    }
    super.onError(err, handler);
  }
}

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  factory ApiException.fromDioException(DioException err) {
    if (err.type == DioExceptionType.connectionTimeout || 
        err.type == DioExceptionType.receiveTimeout) {
      return ApiException('Connection timed out. Please check your internet.', statusCode: 408);
    }
    if (err.type == DioExceptionType.badResponse) {
      final data = err.response?.data;
      final msg = data is Map<String, dynamic> ? data['message'] ?? 'An error occurred' : 'Server error';
      return ApiException(msg.toString(), statusCode: err.response?.statusCode);
    }
    return ApiException('Network error occurred. Please try again.');
  }

  @override
  String toString() => message;
}

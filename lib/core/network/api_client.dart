import 'package:dio/dio.dart';

class ApiClient {
  ApiClient({required String baseUrl, String? token})
      : dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 20),
            headers: token == null ? null : {'Authorization': 'Bearer $token'},
          ),
        );

  final Dio dio;

  String friendlyError(Object error) {
    if (error is DioException) {
      final data = error.response?.data;
      if (data is Map && data['message'] is String) return data['message'] as String;
      if (error.type == DioExceptionType.connectionTimeout) return 'SafeZone command server timed out.';
      if (error.type == DioExceptionType.connectionError) return 'Cannot reach SafeZone command server.';
    }
    return 'Something went wrong. Please try again.';
  }
}


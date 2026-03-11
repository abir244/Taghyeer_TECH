import 'package:dio/dio.dart';
import '../../core/network/dio_client.dart';
import '../../core/constants/api_endpoints.dart';

class AuthProvider {
  final Dio _dio = DioClient.instance;

  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.login,
      data: {
        'username': username,
        'password': password,
        'expiresInMins': 30,
      },
    );
    return response.data as Map<String, dynamic>;
  }
}

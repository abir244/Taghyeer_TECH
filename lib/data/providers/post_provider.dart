import 'package:dio/dio.dart';
import '../../core/network/dio_client.dart';
import '../../core/constants/api_endpoints.dart';
import '../../core/constants/app_constants.dart';

class PostProvider {
  final Dio _dio = DioClient.instance;

  Future<Map<String, dynamic>> getPosts({int skip = 0}) async {
    final response = await _dio.get(
      ApiEndpoints.posts,
      queryParameters: {
        'limit': AppConstants.pageLimit,
        'skip': skip,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getPostById(int id) async {
    final response = await _dio.get('${ApiEndpoints.posts}/$id');
    return response.data as Map<String, dynamic>;
  }
}

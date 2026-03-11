import 'package:dio/dio.dart';
import '../../core/network/dio_client.dart';
import '../../core/constants/api_endpoints.dart';
import '../../core/constants/app_constants.dart';

class ProductProvider {
  final Dio _dio = DioClient.instance;

  Future<Map<String, dynamic>> getProducts({int skip = 0}) async {
    final response = await _dio.get(
      ApiEndpoints.products,
      queryParameters: {
        'limit': AppConstants.pageLimit,
        'skip': skip,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getProductById(int id) async {
    final response = await _dio.get('${ApiEndpoints.products}/$id');
    return response.data as Map<String, dynamic>;
  }
}

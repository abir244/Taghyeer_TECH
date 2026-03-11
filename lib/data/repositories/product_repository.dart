import 'package:dio/dio.dart';
import '../models/product_model.dart';
import '../providers/product_provider.dart';
import '../../core/network/dio_client.dart';

class ProductRepository {
  final ProductProvider _provider = ProductProvider();

  Future<Map<String, dynamic>> getProducts({int skip = 0}) async {
    try {
      final data = await _provider.getProducts(skip: skip);
      final products = (data['products'] as List)
          .map((e) => ProductModel.fromJson(e))
          .toList();
      return {
        'products': products,
        'total': data['total'] ?? 0,
      };
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  Future<ProductModel> getProductById(int id) async {
    try {
      final data = await _provider.getProductById(id);
      return ProductModel.fromJson(data);
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }
}

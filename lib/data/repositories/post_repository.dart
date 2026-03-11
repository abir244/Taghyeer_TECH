import 'package:dio/dio.dart';
import '../models/post_model.dart';
import '../providers/post_provider.dart';
import '../../core/network/dio_client.dart';

class PostRepository {
  final PostProvider _provider = PostProvider();

  Future<Map<String, dynamic>> getPosts({int skip = 0}) async {
    try {
      final data = await _provider.getPosts(skip: skip);
      final posts = (data['posts'] as List)
          .map((e) => PostModel.fromJson(e))
          .toList();
      return {
        'posts': posts,
        'total': data['total'] ?? 0,
      };
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  Future<PostModel> getPostById(int id) async {
    try {
      final data = await _provider.getPostById(id);
      return PostModel.fromJson(data);
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }
}

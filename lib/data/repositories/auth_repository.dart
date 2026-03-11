import 'package:dio/dio.dart';
import '../models/user_model.dart';
import '../providers/auth_provider.dart';
import '../../core/network/dio_client.dart';
import '../../core/utils/storage_service.dart';

class AuthRepository {
  final AuthProvider _provider = AuthProvider();

  Future<UserModel> login({
    required String username,
    required String password,
  }) async {
    try {
      final data = await _provider.login(username: username, password: password);
      final user = UserModel.fromJson(data);

      // Cache user and token
      await StorageService.saveToken(user.accessToken);
      await StorageService.saveUser(user.toJson());

      return user;
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  Future<void> logout() async {
    await StorageService.clearAll();
  }

  UserModel? getCachedUser() {
    final data = StorageService.getUser();
    if (data == null) return null;
    return UserModel.fromJson(data);
  }
}

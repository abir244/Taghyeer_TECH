import 'package:get/get.dart';
import '../../../core/utils/storage_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/auth_repository.dart';

class SettingsController extends GetxController {
  final AuthRepository _authRepo = AuthRepository();

  final isDarkMode = false.obs;
  final Rx<UserModel?> user = Rx<UserModel?>(null);

  @override
  void onInit() {
    super.onInit();
    _loadUser();
    _loadTheme();
  }

  void _loadUser() {
    user.value = _authRepo.getCachedUser();
  }

  void _loadTheme() {
    isDarkMode.value = StorageService.getThemeMode();
  }

  Future<void> toggleTheme(bool value) async {
    isDarkMode.value = value;
    await StorageService.saveThemeMode(value);
    Get.changeTheme(value ? AppTheme.darkTheme : AppTheme.lightTheme);
  }

  Future<void> logout() async {
    await _authRepo.logout();
    Get.offAllNamed('/login');
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/storage_service.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();
  runApp(const TaghyeerApp());
}

class TaghyeerApp extends StatelessWidget {
  const TaghyeerApp({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = StorageService.getThemeMode();
    final isLoggedIn = StorageService.isLoggedIn;

    return GetMaterialApp(
      title: 'Taghyeer Shop',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      initialRoute: isLoggedIn ? AppRoutes.home : AppRoutes.login,
      getPages: AppPages.routes,
      defaultTransition: Transition.fadeIn,
    );
  }
}

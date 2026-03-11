import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../../products/controllers/product_controller.dart';
import '../../posts/controllers/post_controller.dart';
import '../../settings/controllers/settings_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<ProductController>(() => ProductController());
    Get.lazyPut<PostController>(() => PostController());
    Get.lazyPut<SettingsController>(() => SettingsController());
  }
}

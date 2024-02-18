import 'package:animal/app/Controllers/LocationController.dart';
import 'package:animal/app/Controllers/PostController.dart';
import 'package:animal/app/Controllers/ProfileController.dart';
import 'package:get/get.dart';
import '../Controllers/ChatController.dart';
import '../Controllers/SharedPrifrence.dart';
import '../Controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
    Get.lazyPut<ProfileController>(
            ()=> ProfileController());
    Get.lazyPut<SharedPrefController>(
            ()=> SharedPrefController());
    Get.lazyPut<PostController>(
            ()=> PostController());
  }
}

// Image.network(
//   recordUrl,
//   width: double.infinity,
//   height: 150.0,
//   fit: BoxFit.cover,
// ),
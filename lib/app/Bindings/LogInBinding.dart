import 'package:animal/app/Controllers/Login_Controller.dart';
import 'package:animal/app/Controllers/SharedPrifrence.dart';
import 'package:get/get.dart';
class LogInBinding extends Bindings{
  @override
  void dependencies() {
   Get.lazyPut<LogInController>(() => LogInController());
   Get.lazyPut(() => SharedPrefController());
  }
}
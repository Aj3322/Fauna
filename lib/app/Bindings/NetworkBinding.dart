import 'package:animal/app/Controllers/SharedPrifrence.dart';
import 'package:get/get.dart';
class NetworkBinging extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<SharedPrefController>(() => SharedPrefController());
  }

}
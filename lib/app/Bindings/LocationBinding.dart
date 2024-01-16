import 'package:animal/app/Controllers/LocationController.dart';
import 'package:get/get.dart';

class ProfileBinding extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<LocationController>(
            ()=> LocationController());
  }

}
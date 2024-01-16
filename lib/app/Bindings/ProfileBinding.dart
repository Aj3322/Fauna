import 'package:animal/app/Controllers/ProfileController.dart';
import 'package:get/get.dart';
class ProfileBinding extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<ProfileController>(
            ()=> ProfileController());
  }

}
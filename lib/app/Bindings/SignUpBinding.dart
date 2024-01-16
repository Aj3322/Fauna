import 'package:animal/app/Controllers/SharedPrifrence.dart';
import 'package:animal/app/Controllers/SignUp_Controller.dart';
import 'package:get/get.dart';

class SignUpBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<SignUpController>(
        ()=> SignUpController());
    Get.lazyPut<SharedPrefController>(
            ()=> SharedPrefController());
  }

}
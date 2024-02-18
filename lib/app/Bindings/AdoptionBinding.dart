import 'package:animal/app/Controllers/AdoptController.dart';
import 'package:get/get.dart';
class AdoptionBinding extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() => AdoptedController());
  }
}
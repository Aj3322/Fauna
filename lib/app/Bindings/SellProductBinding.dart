import 'package:animal/app/Controllers/SellProductController.dart';
import 'package:get/get.dart';

class SellProductBinding extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<SellProductController>(
          () => SellProductController(),
    );
  }
}
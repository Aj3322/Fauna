import 'package:animal/app/Controllers/ChatController.dart';
import 'package:get/get.dart';
class ChatBindings extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() => ChatController());
  }
}
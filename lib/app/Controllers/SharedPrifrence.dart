import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
class SharedPrefController extends GetxController {
  RxBool isLoggedIn = false.obs;
  RxString uid = ''.obs;
  static const String _keyIsLoggedIn = 'isLoggedIn';
  static const String _keyUid = 'uid';
  final box = GetStorage();


  Future<void> setLoginData(String uid) async {
    saveAuthDataToStorage(uid);
    isLoggedIn.value = true;
    this.uid.value = uid;
  }

  Future<void> clearLoginData() async {
    await box.erase();
    // Update values in the controller
    isLoggedIn.value = false;
    uid.value = '';
  }

  Future<void> saveAuthDataToStorage(String uid) async {
    await box.write(_keyIsLoggedIn, true);
    await box.write(_keyUid, uid);
  }
}

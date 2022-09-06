import 'package:get/get.dart';
import 'local_storage.dart';

class GlobalBinding {
  static Future<void> init() async {
    print("GlobalBinding.init()");
    await Get.putAsync(() async {
      print("GlobalBinding.async");

      return LocalStorageService().init();
    });
  }
}

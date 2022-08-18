import 'package:get/get.dart';
import 'package:nine_rings/app/modules/home/home_controller.dart';

import 'main_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainController>(
      () => MainController(),
    );
    Get.lazyPut<HomeController>(
          () => HomeController(),
    );
  }
}

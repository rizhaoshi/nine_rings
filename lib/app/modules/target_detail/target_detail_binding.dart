import 'package:get/get.dart';

import 'target_detail_controller.dart';

class Tags{
  static int tag = 0;
}

class TargetDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TargetDetailController>(
      () => TargetDetailController(),
    );
  }
}

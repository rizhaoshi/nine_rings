import 'package:get/get.dart';
import '../target_detail/target_detail_controller.dart';
import 'target_controller.dart';

class TargetBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TargetController>(
      () => TargetController(),
    );
    Get.lazyPut<TargetDetailController>(
          () => TargetDetailController(),
    );
  }
}

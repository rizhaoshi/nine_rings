import 'package:get/get.dart';
import 'package:nine_rings/common/config.dart';
import 'package:nine_rings/app/bean/target_bean.dart';

class TargetController extends GetxController {
  List<TargetBean> targets = List.from(defaultTargets);

  final count = 0.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}

import 'package:nine_rings/app/modules/splash/illustration.dart';
import 'package:nine_rings/common/conflg.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  //TODO: Implement SplashController
  List<Illustration> list = List.from(splashImages);

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

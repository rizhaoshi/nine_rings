import 'package:get/get.dart';
import '../../modules/exercise/exercise_controller.dart';
import '../../modules/home/home_controller.dart';
import '../target/target_controller.dart';
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
    Get.lazyPut<ExerciseController>(
      () => ExerciseController(),
    );
    Get.lazyPut<TargetController>(
          () => TargetController(),
    );
  }
}

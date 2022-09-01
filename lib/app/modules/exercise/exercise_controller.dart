import 'package:get/get.dart';
import 'package:nine_rings/common/config.dart';
import '../../bean/exercise_bean.dart';

class ExerciseController extends GetxController {
  List<Exercise> exerciseList = List.from(exercises);

  String? from;

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments != null) {
      from = Get.arguments["from"];
      print(from);
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}

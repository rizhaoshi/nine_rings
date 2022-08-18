import 'dart:math';
import 'package:get/get.dart';
import 'package:nine_rings/app/bean/target_bean.dart';
import 'package:nine_rings/app/modules/main/main_controller.dart';
import 'package:nine_rings/common/config.dart';
import 'package:nine_rings/app/bean/exercise_bean.dart';
import 'package:nine_rings/core/data_dao/providers/target_table_provider.dart';

class HomeController extends GetxController {
  List<Exercise> exerciseLists = [];
  List<TargetBean> savedTargets = [];
  TargetTableProvider targetTableProvider = TargetTableProvider();

  @override
  void onInit() {
    super.onInit();
    this.generateExercisesLotties();

    querySavedTargets(FilterType.all);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void generateExercisesLotties() async {
    List<Exercise> exerciseList = List.from(exercises);
    List<int> indexs = [];
    while (indexs.length != 3) {
      int random = Random().nextInt(exerciseList.length);
      if (!indexs.contains(random)) {
        indexs.add(random);
      }
    }
    for (int i = 0; i < indexs.length; i++) {
      int index = indexs[i];
      exerciseLists.add(exerciseList[index]);
    }
  }

  Future<void> querySavedTargets(FilterType filterType) async {
    savedTargets.clear();
    //查询本地数据库
    savedTargets = await targetTableProvider.queryTarget(filterType: filterType);
    print('=======${exerciseLists.length}=======');
    update(["list_view"]);
  }

  void jumpSelectTargetPage() async {
    MainController controller = Get.find<MainController>();
    controller.onPushTargetSettingPageAction();
  }

  void refreshTargets() {
    querySavedTargets(FilterType.all);
  }
}

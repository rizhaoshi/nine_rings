import 'dart:math';
import 'package:get/get.dart';
import 'package:nine_rings/app/bean/target_bean.dart';
import 'package:nine_rings/app/modules/main/main_controller.dart';
import 'package:nine_rings/common/config.dart';
import 'package:nine_rings/app/bean/exercise_bean.dart';
import 'package:nine_rings/core/data_dao/providers/target_table_provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../routes/app_routes.dart';
import '../target_detail/target_detail_binding.dart';

class HomeController extends GetxController {
  List<Exercise> exerciseLists = [];
  List<TargetBean> savedTargets = [];
  TargetTableProvider targetTableProvider = TargetTableProvider();

  //下拉刷新
  RefreshController refreshController = RefreshController();
  late MainController mainController;
  FilterType filterType = FilterType.all;

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
    List<TargetBean> queryTargets = await targetTableProvider.queryTarget(filterType: filterType);
    if (filterType == FilterType.all || filterType == FilterType.giveUp) {
      queryTargets.forEach((element) {
        savedTargets.add(element);
      });
    } else if (filterType == FilterType.processing) {
      //进行中
      queryTargets.forEach((element) {
        TargetBean target = element;
        if (target.targetStatus == TargetStatus.processing) {
          savedTargets.add(target);
        }
      });
    } else if (filterType == FilterType.completed) {
      //已完成
      queryTargets.forEach((element) {
        TargetBean target = element;
        if (target.targetStatus == TargetStatus.completed) {
          savedTargets.add(target);
        }
      });
    }
    update(["list_view"]);
  }

  void jumpSelectTargetPage() async {
    MainController controller = Get.find<MainController>();
    controller.onPushTargetSettingPageAction();
  }

  void refreshTargets() {
    querySavedTargets(FilterType.all);
  }

  //下拉刷新
  void refreshList() async {
    await querySavedTargets(FilterType.all);
    refreshController.refreshCompleted();
  }

  //过滤
  void showFilterView() {
    mainController = Get.find<MainController>();
    mainController.showFilterView();
  }

  String getFilterTitle() {
    String title = "";

    switch (filterType) {
      case FilterType.all:
        title = 'all'.tr;
        break;
      case FilterType.processing:
        title = 'processing'.tr;
        break;
      case FilterType.completed:
        title = 'completed'.tr;
        break;
      case FilterType.giveUp:
        title = 'giveup'.tr;
        break;
    }
    return title;
  }

  void updateFilterType(FilterType type) {
    if (type == filterType) return;
    filterType = type;
    update(["filter_button"]);
    querySavedTargets(filterType);
  }

  void switchPageToExercise() {
    mainController = Get.find<MainController>();
    mainController.switchPageToExercise();
  }

  void pushToTaskDetailPage(TargetBean target) {
    Get.toNamed(Routes.TARGET_DETAIL, arguments: target.clone(), parameters: {"tag": "${++Tags.tag}"});
  }

  void updateData() {
    print("====成功====");
    // savedTargets.clear();
    querySavedTargets(filterType);
  }
}

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:nine_rings/app/modules/exercise/exercise_page.dart';
import 'package:nine_rings/app/modules/home/home_page.dart';
import 'package:nine_rings/core/data_dao/providers/target_table_provider.dart';
import 'package:nine_rings/routes/app_routes.dart';
import '../../widgets/keep_alive_widget.dart';
import '../home/home_controller.dart';

class MainController extends GetxController {
  var pageController = PageController(initialPage: 0);
  HomeController homeController = Get.find<HomeController>();
  late List<Widget> pageViews;
  bool isShowFilterView = false;

  @override
  void onInit() {
    super.onInit();
    pageViews = [
      KeepAliveWidget(HomePage()),
      KeepAliveWidget(ExercisePage())
    ];
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void onPushTargetSettingPageAction() {
    Get.toNamed(Routes.TARGET);
  }

  void refreshTargets() {
    homeController.refreshTargets();
  }

  //过滤
  void showFilterView() {
    isShowFilterView = true;
    update(["filter_view"]);
  }

  void hideFilterView() {
    isShowFilterView = false;
    update(["filter_view"]);
  }

  void updateFilterType(FilterType type) {
    homeController.updateFilterType(type);
  }
}

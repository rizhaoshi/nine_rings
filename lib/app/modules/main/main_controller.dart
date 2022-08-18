import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:nine_rings/app/modules/home/home_page.dart';
import 'package:nine_rings/common/widgets/keep_alive_widget.dart';
import 'package:nine_rings/routes/app_routes.dart';

import '../home/home_controller.dart';

class MainController extends GetxController {
  //TODO: Implement MainController
  var pageController = PageController(initialPage: 0);
  HomeController homeController = Get.find<HomeController>();
  late List<Widget> pageViews;

  @override
  void onInit() {
    super.onInit();
    pageViews = [
      KeepAliveWidget(HomePage()),
      KeepAliveWidget(Container(
        color: Colors.red,
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.center,
        child: Text('运动瀑布页'),
      ))
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
}

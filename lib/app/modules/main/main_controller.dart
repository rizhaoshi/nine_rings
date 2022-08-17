import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:nine_rings/app/modules/home/home_page.dart';
import 'package:nine_rings/common/widgets/keep_alive_widget.dart';

class MainController extends GetxController {
  //TODO: Implement MainController
  var pageController = PageController(initialPage: 0);

  late List<Widget> pageViews;

  final count = 0.obs;

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

  void increment() => count.value++;
}

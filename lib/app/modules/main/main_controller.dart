import 'package:get/get.dart';
import 'package:flutter/material.dart';

class MainController extends GetxController {
  //TODO: Implement MainController
  var pageController = PageController(initialPage: 0);

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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nine_rings/app/modules/home/home_view.dart';

import 'main_controller.dart';

class MainPage extends GetView<MainController> {
  const MainPage({Key? key}) : super(key: key);
  final double bottomTabViewHeight = 60.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              child: PageView(
                physics: NeverScrollableScrollPhysics(),
                controller: controller.pageController,
                children: [
                  HomeView(),
                  Container(
                    color: Colors.red,
                    width: double.infinity,
                    height: double.infinity,
                    alignment: Alignment.center,
                    child: Text('运动瀑布页'),
                  )
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: bottomTabViewHeight,
                width: double.infinity,
                color: Colors.orange,
              ),
            )
          ],
        ),
      ),
    );
  }
}

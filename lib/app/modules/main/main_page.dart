import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:nine_rings/app/modules/home/home_view.dart';
import 'package:nine_rings/common/widgets/main_page_tabview.dart';
import 'main_controller.dart';
import 'package:nine_rings/common/config.dart';

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
                  HomePage(),
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
                child: MainPageTabView(
                  tabIcons: const [
                    'assets/icons/common/menu.svg',
                    'assets/icons/common/exercise.svg'
                  ],
                  selectedIndex: 0,
                  bgColor: Colors.white,
                  activeColor: commonGreenColor,
                  onPress: (index) {
                    controller.pageController.animateToPage(index,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.ease);
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

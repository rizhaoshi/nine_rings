import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../widgets/filter_view.dart';
import '../../widgets/main_page_tabview.dart';
import 'main_controller.dart';
import 'package:nine_rings/common/config.dart';

class MainPage extends GetView<MainController> {
  const MainPage({Key? key}) : super(key: key);
  final double bottomTabViewHeight = 60.0;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          top: false,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                bottom: bottomTabViewHeight,
                child: PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: controller.pageController,
                  children: controller.pageViews,
                ),
              ),
              Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                      height: bottomTabViewHeight,
                      width: double.infinity,
                      child: GetBuilder<MainController>(
                        builder: (ctr) {
                          return MainPageTabView(
                            tabIcons: const ['assets/icons/common/menu.svg', 'assets/icons/common/exercise.svg'],
                            selectedIndex: controller.selectedIndex,
                            bgColor: Colors.white,
                            activeColor: commonGreenColor,
                            onPress: (index) {
                              if (index != controller.selectedIndex) {
                                controller.pageController.animateToPage(index, duration: const Duration(milliseconds: 200), curve: Curves.ease);
                                controller.selectedIndex = index;
                              }
                            },
                          );
                        },
                      ))),
              GetBuilder<MainController>(
                  id: "filter_view",
                  builder: (controller) {
                    if (!controller.isShowFilterView) return Container();
                    return FilterView(
                        mainController: controller,
                        callBack: (selectedType) {
                          // controller.hideFilterView();
                          controller.updateFilterType(selectedType);
                        });
                  })
            ],
          ),
        ),
      ),
    );
  }
}

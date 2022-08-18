import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';
import 'package:nine_rings/app/bean/exercise_bean.dart';
import 'package:nine_rings/app/bean/target_bean.dart';
import 'package:nine_rings/common/utils/date_time_util.dart';
import 'package:nine_rings/common/config.dart';
import '../../../common/utils/color_util.dart';
import 'home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget _renderLottieWidget(int index) {
      return Lottie.asset(controller.exerciseLists[index].asset);
    }

    double _caculateWidth(TargetBean target) {
      double fillWidth = Get.width - 40 - 20;
      int total = Duration(days: target.targetDays!).inSeconds;
      int duration = DateTime.now().difference(target.createTime!).inSeconds;
      double process = duration / total;
      return fillWidth * process;
    }

    int? _caculateProcessingDays(TargetBean target) {
      DateTime? createTime = target.createTime;
      if (createTime == null) return null;
      return diffDaysBetweenTwoDate(createTime, DateTime.now());
    }

    Widget _renderTargetItem(HomeController homeController, int index, BuildContext context) {
      TargetBean target = homeController.savedTargets[index];
      String icon = target.targetStatus == TargetStatus.completed
          ? "assets/icons/common/beaming_face_with_smiling_eyes.svg"
          : "assets/icons/common/disappointed_face.svg";
      return GestureDetector(
        onTap: () {},
        child: Container(
          height: 80,
          margin: EdgeInsets.only(left: 20, right: 20, top: index == 0 ? 20 : 10, bottom: index == homeController.exerciseLists.length - 1 ? 20 : 10),
          decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(10)), color: lightenColor(target.targetColor!, 55)),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Stack(
            fit: StackFit.expand,
            children: [
              //进行中的目标上方的进度浮层
              target.targetStatus == TargetStatus.processing
                  ? Positioned(
                      top: 0,
                      left: 0,
                      bottom: 0,
                      child: Container(
                        width: _caculateWidth(target),
                        decoration: BoxDecoration(color: target.targetColor),
                      ))
                  : Container(),
              Row(
                children: [
                  Container(
                      margin: const EdgeInsets.only(left: 20),
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text("${target.name}", style: TextStyle(color: textBlackColor, fontWeight: FontWeight.w400, fontSize: 10)),
                        Container(
                            margin: const EdgeInsets.only(top: 4),
                            child: Text("${'start_ta'.tr} ${formatTime(formatter: formatter_b, dateTime: target.createTime)}",
                                style: TextStyle(color: textBlackColor.withOpacity(0.6), fontWeight: FontWeight.w400, fontSize: 14)))
                      ])),
                  Expanded(
                      child: target.targetStatus == TargetStatus.processing
                          ? Container(
                              margin: const EdgeInsets.only(right: 20),
                              child: Text("${_caculateProcessingDays(target) ?? ''}/${target.targetDays}",
                                  textAlign: TextAlign.right, style: TextStyle(color: textBlackColor, fontWeight: FontWeight.w400, fontSize: 20)),
                            )
                          : Container(
                              margin: const EdgeInsets.only(right: 15),
                              alignment: Alignment.centerRight,
                              child: SvgPicture.asset(icon, width: 35, height: 35))),
                ],
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
        body: Builder(
      builder: (context) => AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark,
          child: CupertinoPageScaffold(
            child: Scaffold(
              backgroundColor: const Color.fromRGBO(244, 245, 246, 1),
              body: SafeArea(
                top: false,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: double.infinity,
                          height: 220,
                          decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), color: Colors.white),
                          margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 10, left: 10, right: 10),
                          child: controller.exerciseLists.isEmpty
                              ? Container()
                              : CarouselSlider.builder(
                                  itemCount: controller.exerciseLists.length,
                                  itemBuilder: (BuildContext context, int index, int realIndex) {
                                    Exercise exercise = controller.exerciseLists[index];
                                    return Stack(
                                      children: [
                                        Container(width: double.infinity, height: 220, alignment: Alignment.center, child: _renderLottieWidget(index)),
                                        Positioned(
                                            right: 10,
                                            bottom: 10,
                                            child: Text(exercise.copyright ?? "",
                                                textAlign: TextAlign.right, style: TextStyle(color: textGreyColor, fontWeight: FontWeight.w400, fontSize: 14)))
                                      ],
                                    );
                                  },
                                  options:
                                      CarouselOptions(disableCenter: true, viewportFraction: 1, autoPlay: true, autoPlayInterval: const Duration(seconds: 4))),
                        ),
                      ),
                      Expanded(
                          child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), color: Colors.white),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                                onTap: () {},
                                child: Container(
                                    margin: const EdgeInsets.only(top: 15, left: 20, bottom: 2),
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(10)), color: commonGreenColor),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "筛选",
                                          style: TextStyle(color: textBlackColor, fontSize: 16, fontWeight: FontWeight.w400),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(left: 4),
                                          child: SvgPicture.asset(
                                            'assets/icons/common/filters.svg',
                                            width: 18,
                                            height: 18,
                                            color: textBlackColor,
                                          ),
                                        ),
                                      ],
                                    ))),
                            Expanded(
                                child: Stack(
                              fit: StackFit.expand,
                              children: [
                                GetBuilder<HomeController>(
                                    id: "list_view",
                                    builder: (controller) {
                                      return ListView.builder(
                                        padding: EdgeInsets.zero,
                                        itemBuilder: (context, index) {
                                          return _renderTargetItem(controller, index, context);
                                        },
                                        itemCount: controller.savedTargets.length,
                                      );
                                    }),
                                Positioned(
                                    right: 20,
                                    bottom: 20,
                                    child: GestureDetector(
                                      onTap: () {
                                        controller.jumpSelectTargetPage();
                                      },
                                      child: Container(
                                          child: SvgPicture.asset(
                                        "assets/icons/common/add_target.svg",
                                        color: Colors.blue,
                                        width: 50,
                                        height: 50,
                                      )),
                                    ))
                              ],
                            ))
                          ],
                        ),
                      ))
                    ],
                  ),
                ),
              ),
            ),
          )),
    ));
  }
}

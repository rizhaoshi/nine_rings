import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nine_rings/app/widgets/exercise_item_view.dart';
import 'package:nine_rings/common/config.dart';
import 'package:nine_rings/common/utils/object_util.dart';
import '../../../routes/app_routes.dart';
import '../../widgets/navigator_bar.dart';
import 'exercise_controller.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'exercise_detail_page.dart';

class ExercisePage extends GetView<ExerciseController> {
  const ExercisePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoScaffold(
        body: Builder(
      builder: (ct) => AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark,
          child: CupertinoPageScaffold(
            child: Scaffold(
              backgroundColor: const Color.fromRGBO(242, 243, 244, 1),
              appBar: ObjectUtil.isEmptyString(controller.from)
                  ? null
                  : NavigatorBar(
                      title: "",
                      closeType: NavigatorBarCloseType.back,
                      closeCallBack: () {
                        Get.back();
                      },
                    ),
              body: _body(),
            ),
          )),
    ));
  }

  Widget _body() {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _head(),
          _grid_view(),
        ],
      ),
    );
  }

  Widget _head() {
    return Container(
      width: double.infinity,
      height: 40,
      margin: const EdgeInsets.only(top: 30, left: 20, right: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: Text('exercises'.tr, style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600, color: textBlackColor))),
          GestureDetector(
              onTap: () {
                Get.toNamed(Routes.HELP);
              },
              child: Container(
                  width: 80,
                  height: 40,
                  alignment: Alignment.centerRight,
                  child: SvgPicture.asset(
                    'assets/icons/common/more.svg',
                    width: 30,
                    height: 30,
                  ))),
        ],
      ),
    );
  }

  Widget _grid_view() {
    return Expanded(
        child: Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: GridView.builder(
          itemCount: controller.exerciseList.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 0.6),
          itemBuilder: (context, index) {
            return ExerciseItemView(
                exercise: controller.exerciseList[index],
                onPress: () {
                  CupertinoScaffold.showCupertinoModalBottomSheet(
                      context: context,
                      builder: (ct) => ExerciseDetailPage(exercise: controller.exerciseList[index]),
                      enableDrag: true,
                      expand: true,
                      backgroundColor: Colors.transparent);
                });
          }),
    ));
  }
}

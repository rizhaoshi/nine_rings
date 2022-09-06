import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nine_rings/app/bean/target_bean.dart';
import 'package:nine_rings/app/modules/target/target_edit.dart';
import '../../widgets/navigator_bar.dart';
import 'target_controller.dart';
import 'package:auto_animated/auto_animated.dart';
import 'package:nine_rings/common/config.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class TargetPage extends GetView<TargetController> {
  const TargetPage({Key? key}) : super(key: key);

  Widget _renderTargetItem(TargetBean? target, int index, BuildContext context) {
    if (target == null) return const SizedBox.shrink();

    return InkWell(
      onTap: () {
        CupertinoScaffold.showCupertinoModalBottomSheet(
          context: context,
          builder: (context) => TaskEditPage(target),
          enableDrag: true,
          expand: true,
          backgroundColor: Colors.transparent,
        );
      },
      child: Container(
        margin: EdgeInsets.only(top: index == 0 ? 30 : 10, left: 30, right: 30, bottom: index == controller.targets.length - 1 ? 30 : 10),
        height: 80,
        clipBehavior: Clip.none,
        decoration: BoxDecoration(
          color: target.targetColor,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Text(target.name ?? "",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w400,
                          color: textBlackColor,
                        )),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    child: Text(target.description ?? "",
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                        )),
                  ),
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoScaffold(
      body: CupertinoPageScaffold(
          child: Scaffold(
        appBar: NavigatorBar(
          title: "挑战目标",
          closeType: NavigatorBarCloseType.close,
          bgColor: Colors.red,
          closeCallBack: () {
            Get.back();
          },
        ),
        body: SafeArea(
          child: LiveList(
            showItemDuration: const Duration(milliseconds: 200),
            showItemInterval: const Duration(milliseconds: 200),
            visibleFraction: 0.05,
            reAnimateOnVisibility: false,
            itemCount: controller.targets.length,
            itemBuilder: ((context, index, animation) {
              return FadeTransition(
                opacity: Tween<double>(begin: 0, end: 1).animate(animation),
                child: SlideTransition(
                    position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(animation),
                    child: _renderTargetItem(controller.targets[index], index, context)),
              );
            }),
          ),
        ),
      )),
    );
  }
}

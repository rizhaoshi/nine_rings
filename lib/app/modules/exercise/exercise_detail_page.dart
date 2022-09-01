import 'package:flutter/material.dart';
import 'package:nine_rings/common/utils/object_util.dart';
import '../../../common/config.dart';
import '../../bean/exercise_bean.dart';
import 'package:lottie/lottie.dart';
import "package:get/get.dart";

class ExerciseDetailPage extends StatelessWidget {
  final Exercise exercise;

  const ExerciseDetailPage({Key? key, required this.exercise}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: Lottie.asset(exercise.asset, width: 280, height: 280),
            ),
            Container(
                width: double.infinity,
                margin: const EdgeInsets.only(right: 20),
                child: Text(
                  exercise.copyright ?? "",
                  textAlign: TextAlign.right,
                  style: TextStyle(color: textGreyColor, fontWeight: FontWeight.w400, fontSize: 14),
                )),
            Container(
                width: double.infinity,
                margin: const EdgeInsets.only(right: 20),
                child: Text(
                  exercise.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Color.fromRGBO(69, 80, 97, 1), fontWeight: FontWeight.w500, fontSize: 22),
                )),
            Expanded(
                child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _renderWidget('exercise_steps'.tr, exercise.actions),
                    _renderWidget('exercise_breath'.tr, exercise.breaths),
                    _renderWidget('常见错误', exercise.errors),
                    _renderWidget('exercise_goal'.tr, exercise.targets),
                  ],
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }

  Widget _subtitle(String subtitle) {
    return Container(
      height: 38,
      alignment: Alignment.centerLeft,
      child: Text(
        subtitle,
        style: const TextStyle(color: Color.fromRGBO(69, 80, 97, 1), fontWeight: FontWeight.w500, fontSize: 17),
      ),
    );
  }

  Widget _point() {
    return Container(
      width: 6,
      height: 6,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(3)),
    );
  }

  Widget _renderWidget(String subtitle, List<String>? contents) {
    if (ObjectUtil.isEmptyList(contents)) return const SizedBox.shrink();
    List<Widget> actionWidgets = contents!
        .map<Widget>((content) => Container(
              margin: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _point(),
                  Expanded(
                      child: Text(
                    content,
                    style: const TextStyle(color: Color.fromRGBO(106, 115, 129, 1), fontWeight: FontWeight.w300, fontSize: 15),
                  ))
                ],
              ),
            ))
        .toList();

    actionWidgets.insert(0, _subtitle(subtitle));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: actionWidgets,
    );
  }
}

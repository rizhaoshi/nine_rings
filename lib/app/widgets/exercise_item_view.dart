import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nine_rings/app/bean/exercise_bean.dart';
import 'package:get/get.dart';
import 'package:nine_rings/common/config.dart';

class ExerciseItemView extends StatelessWidget {
  final Exercise exercise;
  final Function()? onPress;

  const ExerciseItemView({Key? key, required this.exercise, this.onPress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final boxSize = (Get.width - 40 - 20 - 10) / 2 - 20;
    return GestureDetector(
      onTap: onPress,
      child: Container(
        decoration: BoxDecoration(color: const Color.fromRGBO(250, 250, 250, 1), borderRadius: BorderRadius.circular(0)),
        padding: const EdgeInsets.only(top: 8, right: 5, left: 5, bottom: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.center,
              child: Lottie.asset(exercise.asset, width: boxSize, height: boxSize),
            ),
            Container(
                width: double.infinity,
                margin: const EdgeInsets.only(left: 5, top: 5),
                child: Text(
                  exercise.name,
                  textAlign: TextAlign.left,
                  style: TextStyle(color: textBlackColor, fontSize: 18, fontWeight: FontWeight.w400),
                )),
            Container(
                margin: const EdgeInsets.only(top: 1, left: 5),
                width: double.infinity,
                child: Text(
                  exercise.effect ?? "",
                  textAlign: TextAlign.left,
                  style: TextStyle(color: textGreyColor, fontSize: 16, fontWeight: FontWeight.w300),
                ))
          ],
        ),
      ),
    );
  }
}

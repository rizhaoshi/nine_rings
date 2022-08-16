import 'package:flutter/material.dart';
import 'package:nine_rings/app/bean/target_bean.dart';
import 'package:nine_rings/app/modules/splash/illustration.dart';
import 'package:nine_rings/app/bean/sound_bean.dart';
import 'package:get/get.dart';

final Color textGreyColor = Color.fromRGBO(151, 158, 168, 1);
final Color textBlackColor = Color.fromRGBO(69, 80, 97, 1);
final Color commonGreenColor = Color.fromRGBO(195, 221, 83, 1);
final List<Illustration> splashImages = [
  Illustration("assets/illustrations/splash/junk_food.svg",
      "BSGStudio on all-free download.com"),
  Illustration("assets/illustrations/splash/mental_well_being.svg",
      "Iconscout Store on iconscout.com"),
];

final List<TargetBean> defaultTargets = [
  TargetBean()
    ..name = 'quit_milktea'.tr
    ..description = 'start_healthy_lifestyle'.tr
    ..targetDays = 7
    ..targetColor = Color.fromRGBO(240, 199, 73, 1)
    ..notificationTimes = [
      TimeOfDay(hour: 10, minute: 00),
      TimeOfDay(hour: 15, minute: 00),
      TimeOfDay(hour: 20, minute: 00),
    ],
  TargetBean()
    ..name = "quit_smoking".tr
    ..description = 'start_healthy_lifestyle'.tr
    ..targetDays = 7
    ..targetColor = Color.fromRGBO(237, 135, 52, 1)
    ..notificationTimes = [
      TimeOfDay(hour: 8, minute: 00),
      TimeOfDay(hour: 10, minute: 00),
      TimeOfDay(hour: 15, minute: 00),
      TimeOfDay(hour: 19, minute: 00),
    ],
  TargetBean()
    ..name = "quit_soap_opera".tr
    ..description = 'start_healthy_lifestyle'.tr
    ..targetDays = 7
    ..targetColor = Color.fromRGBO(211, 88, 70, 1)
    ..notificationTimes = [
      TimeOfDay(hour: 15, minute: 00),
      TimeOfDay(hour: 19, minute: 00),
      TimeOfDay(hour: 20, minute: 00),
      TimeOfDay(hour: 22, minute: 00),
    ],
  TargetBean()
    ..name = "quit_friedchicken".tr
    ..description = 'start_healthy_lifestyle'.tr
    ..targetDays = 7
    ..targetColor = Color.fromRGBO(229, 108, 104, 1)
    ..notificationTimes = [
      TimeOfDay(hour: 11, minute: 00),
      TimeOfDay(hour: 15, minute: 00),
      TimeOfDay(hour: 20, minute: 00),
    ],
  TargetBean()
    ..name = "quit_cola".tr
    ..description = 'start_healthy_lifestyle'.tr
    ..targetDays = 7
    ..targetColor = Color.fromRGBO(71, 150, 206, 1)
    ..notificationTimes = [
      TimeOfDay(hour: 8, minute: 00),
      TimeOfDay(hour: 11, minute: 00),
      TimeOfDay(hour: 15, minute: 00),
      TimeOfDay(hour: 20, minute: 00),
    ],
  TargetBean()
    ..name = "quit_drinking".tr
    ..description = 'start_healthy_lifestyle'.tr
    ..targetDays = 7
    ..targetColor = Color.fromRGBO(196, 225, 104, 1)
    ..notificationTimes = [
      TimeOfDay(hour: 12, minute: 00),
      TimeOfDay(hour: 18, minute: 00),
      TimeOfDay(hour: 20, minute: 00),
    ],
  TargetBean()
    ..name = "quit_chips".tr
    ..description = 'start_healthy_lifestyle'.tr
    ..targetDays = 7
    ..targetColor = Color.fromRGBO(200, 141, 215, 1)
    ..notificationTimes = [
      TimeOfDay(hour: 11, minute: 00),
      TimeOfDay(hour: 15, minute: 00),
      TimeOfDay(hour: 20, minute: 00),
    ],
  TargetBean()
    ..name = "quit_hamburger".tr
    ..description = 'start_healthy_lifestyle'.tr
    ..targetDays = 7
    ..targetColor = Color.fromRGBO(89, 184, 167, 1)
    ..notificationTimes = [
      TimeOfDay(hour: 11, minute: 00),
      TimeOfDay(hour: 15, minute: 00),
      TimeOfDay(hour: 20, minute: 00),
    ],
  TargetBean()
    ..name = "quit_snacks".tr
    ..description = 'start_healthy_lifestyle'.tr
    ..targetDays = 7
    ..targetColor = Color.fromRGBO(108, 131, 182, 1)
    ..notificationTimes = [
      TimeOfDay(hour: 15, minute: 00),
      TimeOfDay(hour: 20, minute: 00),
      TimeOfDay(hour: 22, minute: 00),
    ],
  TargetBean()
    ..name = "quit_icecream".tr
    ..description = 'start_healthy_lifestyle'.tr
    ..targetDays = 7
    ..targetColor = Color.fromRGBO(208, 162, 140, 1)
    ..notificationTimes = [
      TimeOfDay(hour: 10, minute: 00),
      TimeOfDay(hour: 15, minute: 00),
      TimeOfDay(hour: 20, minute: 00),
    ],
  TargetBean()
    ..name = "quit_spicy".tr
    ..description = 'start_healthy_lifestyle'.tr
    ..targetDays = 7
    ..targetColor = Color.fromRGBO(85, 170, 105, 1)
    ..notificationTimes = [
      TimeOfDay(hour: 18, minute: 00),
      TimeOfDay(hour: 20, minute: 00),
      TimeOfDay(hour: 22, minute: 00),
    ],
  TargetBean()
    ..name = "quit_crayfish".tr
    ..description = 'start_healthy_lifestyle'.tr
    ..targetDays = 7
    ..targetColor = Color.fromRGBO(211, 88, 70, 1)
    ..notificationTimes = [
      TimeOfDay(hour: 18, minute: 00),
      TimeOfDay(hour: 20, minute: 00),
      TimeOfDay(hour: 22, minute: 00),
    ],
  TargetBean()
    ..name = "quit_friedseries".tr
    ..description = 'start_healthy_lifestyle'.tr
    ..targetDays = 7
    ..targetColor = Color.fromRGBO(71, 97, 142, 1)
    ..notificationTimes = [
      TimeOfDay(hour: 18, minute: 00),
      TimeOfDay(hour: 20, minute: 00),
      TimeOfDay(hour: 22, minute: 00),
    ],
  TargetBean()
    ..name = "quit_barbecue".tr
    ..description = 'start_healthy_lifestyle'.tr
    ..targetDays = 7
    ..targetColor = Color.fromRGBO(133, 206, 188, 1)
    ..notificationTimes = [
      TimeOfDay(hour: 18, minute: 00),
      TimeOfDay(hour: 20, minute: 00),
      TimeOfDay(hour: 22, minute: 00),
    ],
  TargetBean()
    ..name = "quit_masturbation".tr
    ..description = 'start_healthy_lifestyle'.tr
    ..targetDays = 7
    ..targetColor = Color.fromRGBO(112, 206, 233, 1)
    ..notificationTimes = [
      TimeOfDay(hour: 20, minute: 00),
      TimeOfDay(hour: 22, minute: 00),
      TimeOfDay(hour: 23, minute: 00),
    ],
  TargetBean()
    ..name = "quit_sugar".tr
    ..description = 'start_healthy_lifestyle'.tr
    ..targetDays = 7
    ..targetColor = Color.fromRGBO(171, 222, 76, 1)
    ..notificationTimes = [
      TimeOfDay(hour: 9, minute: 30),
      TimeOfDay(hour: 11, minute: 30),
      TimeOfDay(hour: 17, minute: 30),
    ],
  TargetBean()
    ..name = "quit_carbohydrate".tr
    ..description = 'start_healthy_lifestyle'.tr
    ..targetDays = 7
    ..targetColor = Color.fromRGBO(207, 87, 155, 1)
    ..notificationTimes = [
      TimeOfDay(hour: 7, minute: 30),
      TimeOfDay(hour: 11, minute: 30),
      TimeOfDay(hour: 17, minute: 30),
    ],
  TargetBean()
    ..name = "quit_coffee".tr
    ..description = 'start_healthy_lifestyle'.tr
    ..targetDays = 7
    ..targetColor = Color.fromRGBO(240, 199, 73, 1)
    ..notificationTimes = [
      TimeOfDay(hour: 8, minute: 00),
      TimeOfDay(hour: 10, minute: 00),
      TimeOfDay(hour: 13, minute: 00),
      TimeOfDay(hour: 15, minute: 00),
    ],
  TargetBean()
    ..name = "quit_sex".tr
    ..description = 'start_healthy_lifestyle'.tr
    ..targetDays = 7
    ..targetColor = Color.fromRGBO(237, 135, 52, 1)
    ..notificationTimes = [
      TimeOfDay(hour: 20, minute: 30),
      TimeOfDay(hour: 22, minute: 30),
      TimeOfDay(hour: 23, minute: 30),
    ],
];

final List<int> defaultTargetDays = [7, 15, 30, 60, 100];

final List<Color> colors = [
  Color.fromRGBO(240, 199, 73, 1),
  Color.fromRGBO(237, 135, 52, 1),
  Color.fromRGBO(229, 108, 104, 1),
  Color.fromRGBO(71, 150, 206, 1),
  Color.fromRGBO(196, 225, 104, 1),
  Color.fromRGBO(200, 141, 215, 1),
  Color.fromRGBO(89, 184, 167, 1),
  Color.fromRGBO(108, 131, 182, 1),
  Color.fromRGBO(208, 162, 140, 1),
  Color.fromRGBO(85, 170, 105, 1),
  Color.fromRGBO(211, 88, 70, 1),
  Color.fromRGBO(71, 97, 142, 1),
  Color.fromRGBO(133, 206, 188, 1),
  Color.fromRGBO(112, 206, 233, 1),
  Color.fromRGBO(171, 222, 76, 1),
  Color.fromRGBO(207, 87, 155, 1),
];

List<Sound> notificationSounds = [
  Sound(
      soundKey: 'lg',
      soundName: 'sound_lg'.tr,
      soundPath: 'sounds/lg.m4a'),
  Sound(
      soundKey: 'pikachu',
      soundName: 'sound_pikachu'.tr,
      soundPath: 'sounds/pikachu.m4a'),
  Sound(
      soundKey: 'ringtones',
      soundName: 'sound_ringtones'.tr,
      soundPath: 'sounds/ringtones.m4a'),
  Sound(
      soundKey: 'samsung',
      soundName: 'sound_samsung'.tr,
      soundPath: 'sounds/samsung.m4a'),
  Sound(
      soundKey: 'slow_spring_board',
      soundName: 'sound_spring'.tr,
      soundPath: 'sounds/slow_spring_board.m4a'),
];

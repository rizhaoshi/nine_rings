import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/bean/target_bean.dart';

class NotificationManager {
  static void init() async {
    bool initialized = await AwesomeNotifications().initialize(
        'resource://drawable/res_power_ranger_thunder',
        [
          NotificationChannel(
            channelKey: 'lg-notifications',
            channelName: "lg Notifications",
            defaultColor: const Color(0xFF9D50DD),
            ledColor: Colors.white,
            playSound: true,
            importance: NotificationImportance.High,
            soundSource: 'resource://raw/lg',
            channelDescription: "",
          ),
          NotificationChannel(
            channelKey: 'pikachu-notifications',
            channelName: "pikachu Notifications",
            defaultColor: const Color(0xFF9D50DD),
            ledColor: Colors.white,
            playSound: true,
            importance: NotificationImportance.High,
            soundSource: 'resource://raw/pikachu',
            channelDescription: "",
          ),
          NotificationChannel(
            channelKey: 'ringtones-notifications',
            channelName: "ringtones Notifications",
            defaultColor: const Color(0xFF9D50DD),
            ledColor: Colors.white,
            playSound: true,
            importance: NotificationImportance.High,
            soundSource: 'resource://raw/ringtones',
            channelDescription: "",
          ),
          NotificationChannel(
            channelKey: 'samsung-notifications',
            channelName: "samsung Notifications",
            defaultColor: const Color(0xFF9D50DD),
            ledColor: Colors.white,
            playSound: true,
            importance: NotificationImportance.High,
            soundSource: 'resource://raw/samsung',
            channelDescription: "",
          ),
          NotificationChannel(
            channelKey: 'slow_spring_board-notifications',
            channelName: "slow_spring_board Notifications",
            defaultColor: const Color(0xFF9D50DD),
            ledColor: Colors.white,
            playSound: true,
            importance: NotificationImportance.High,
            soundSource: 'resource://raw/slow_spring_board',
            channelDescription: "",
          ),
        ],
        debug: false);
  }

  static Future<void> createTargetNotification(TargetBean? target) async {
    if (target != null && target.id != null) {
      List<TimeOfDay> notificationTimes = target.notificationTimes!;
      int? targetDays = target.targetDays;
      DateTime currentDate = DateTime.now();
      DateTime completedTime = target.createTime!.add(Duration(days: target.targetDays!));
      if (targetDays != null) {
        for (int i = 0; i <= targetDays; i++) {
          notificationTimes.forEach((element) async {
            int hour = element.hour;
            int minute = element.minute;

            String idStr = "${target.id}$hour$minute$i";
            DateTime nextDate = currentDate.add(Duration(days: i));
            DateTime scheduleTime = DateTime(nextDate.year, nextDate.month, nextDate.day, hour, minute);
            if (scheduleTime.isBefore(completedTime)) {
              await AwesomeNotifications().createNotification(
                  content: NotificationContent(
                    id: int.parse(idStr),
                    channelKey: '${target.soundKey}-notifications',
                    title: target.name!,
                    body: i == 0 ? "push_text_1".tr : '${'push_text_2'.tr}$i${'push_text_3'.tr}',
                  ),
                  schedule: NotificationCalendar.fromDate(date: scheduleTime));
            }
          });
        }
        String completedIdStr = '${target.id}10000';
        await AwesomeNotifications().createNotification(
            content: NotificationContent(
              id: int.parse('completedIdStr'),
              channelKey: '${target.soundKey}-notifications',
              title: target.name!,
              body: 'push_text_4'.tr,
            ),
            schedule: NotificationCalendar.fromDate(date: completedTime));
      }
    }
  }

  static Future<void> modifyTargetNotification(TargetBean target) async {
    if (target != null) {
      //取消当前目标的全部推送
      await createTargetNotification(target);

      //重新设置该目标的推送
      await createTargetNotification(target);
    }
  }

  static Future<void> cancelTargetNotification(TargetBean target) async {
    if (target != null) {
      int targetId = target.id!;
      //获取所有通知
      List<NotificationModel> activeSchedules = await AwesomeNotifications().listScheduledNotifications();
      //首先取消之前的设置的该目标推送
      activeSchedules.forEach((element) {
        int? id = element.content?.id;
        if (id != null) {
          String idStr = id.toString();
          if (idStr.startsWith(("$targetId"))) {
            AwesomeNotifications().cancel(id);
          }
        }
      });
    }
  }
}

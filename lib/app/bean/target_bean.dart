import 'package:flutter/material.dart';
import '../../common/utils/object_util.dart';
import '../../common/utils/date_time_util.dart';

enum TargetStatus {
  processing, //进行中
  completed, //已完成
  giveUp, //放弃
}

class TargetBean {
  int? id;
  String? name;
  String? description;

  int? targetDays;
  Color? targetColor;

  String? soundKey;
  List<TimeOfDay>? notificationTimes;
  DateTime? createTime;
  DateTime? giveUpTime;

  TargetStatus? targetStatus;

  TargetBean clone() {
    return TargetBean()
      ..id = id
      ..name = name
      ..description = description
      ..targetDays = targetDays
      ..targetColor = targetColor
      ..soundKey = soundKey
      ..notificationTimes = notificationTimes
      ..createTime = createTime
      ..giveUpTime = giveUpTime
      ..targetStatus = targetStatus;
  }

  static TargetBean? targetBeanFromMap(Map<String, dynamic> map) {
    if (ObjectUtil.isEmptyMap(map)) return null;

    Color? color;
    String? colorStr = map['t_colors'];
    if (!ObjectUtil.isEmptyString(colorStr)) {
      List<String> items = colorStr!.split('|');
      if (!ObjectUtil.isEmptyList(items) && items.length == 3) {
        try {
          color = Color.fromRGBO(int.parse(items[0]), int.parse(items[1]), int.parse(items[2]), 1);
        } catch (e) {
          print(e);
        }
      }
    }

    //目标推送时间
    List<TimeOfDay>? times;
    String? notificationTimesStr = map['t_notification_times'];

    if (!ObjectUtil.isEmptyString(notificationTimesStr)) {
      List<String> items = notificationTimesStr!.split('|');
      if (!ObjectUtil.isEmptyList(items)) {
        times = [];
        items.forEach((element) {
          TimeOfDay? timeOdDay = strToTimeOfDay(element);
          if (timeOdDay != null) {
            times?.add(timeOdDay);
          }
        });
      }
    }

    //创建时间解析
    String crateTimeStr = map['t_create_time'];
    DateTime? crateTime = strToDateTime(crateTimeStr);

    //判断目标状态
    TargetStatus? targetStatus;
    DateTime? giveUpTime;
    String? timeStr = map['t_give_up_time'];
    if (!ObjectUtil.isEmptyString(timeStr)) {
      //已放弃
      targetStatus = TargetStatus.giveUp;
      giveUpTime = strToDateTime(timeStr!);
    } else {
      //获取目标完成时间
      DateTime completeTime = crateTime!.add(Duration(days: map['t_days'] as int));
      if (DateTime.now().isBefore(completeTime)) {
        targetStatus = TargetStatus.processing;
      } else {
        //已完成
        targetStatus = TargetStatus.completed;
      }
    }

    return TargetBean()
      ..id = map['id'] as int
      ..name = map['t_name'] as String
      ..targetDays = map['t_days'] as int
      ..targetColor = color
      ..soundKey = map['t_sound_key']
      ..notificationTimes = times
      ..createTime = crateTime
      ..giveUpTime = giveUpTime
      ..targetStatus = targetStatus;
  }

  static TargetBean generateTargetCurrentStatus(TargetBean target) {
    if (target.targetStatus == null || target.targetStatus == TargetStatus.processing) {
      TargetStatus? targetStatus;
      //判断目标是否完成
      DateTime? completedTime = target.createTime?.add(Duration(days: target.targetDays!));
      if (DateTime.now().isBefore(completedTime!)) {
        targetStatus = TargetStatus.processing;
      } else {
        targetStatus = TargetStatus.completed;
      }
      TargetBean newTarget = target.clone();
      newTarget.targetStatus = targetStatus;
      return newTarget;
    }
    return target.clone();
  }
}

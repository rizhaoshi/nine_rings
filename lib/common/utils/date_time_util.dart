import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'object_util.dart';

String formatter_a = 'yyyy.MM.dd HH:mm:ss';
String formatter_b = 'yyyy.MM.dd HH:mm';
//字符串转TimeOfDay
TimeOfDay? strToTimeOfDay(String? str) {
  if (ObjectUtil.isEmptyString(str)) return null;
  List<String> items = str!.split(':');
  if (ObjectUtil.isEmptyList(items)) return null;
  if (items.length != 2) return null;
  TimeOfDay? timeOfDay;
  try {
    timeOfDay = TimeOfDay(hour: int.parse(items[0]), minute: int.parse(items[1]));
  } catch (e) {
    timeOfDay = null;
    print(e);
  }
  return timeOfDay;
}

//字符串转DateTime
DateTime? strToDateTime(String dateStr) {
  String formattedStr = dateStr.replaceAll('.', '-');
  DateTime? dateTime;
  try {
    dateTime = DateTime.parse(formattedStr);
  } catch (e) {
    dateTime = null;
    print(e);
  }
  return dateTime;
}

//TimeOfDay转字符串
String? timeOfDayToStr(TimeOfDay timeOfDay) {
  String? hourStr;
  String? minuteStr;
  if (timeOfDay.hour < 10) {
    hourStr = "0${timeOfDay.hour}";
  } else {
    hourStr = "${timeOfDay.hour}";
  }

  if (timeOfDay.minute < 10) {
    minuteStr = "0${timeOfDay.minute}";
  } else {
    minuteStr = "${timeOfDay.minute}";
  }

  return '$hourStr:$minuteStr';
}

//DateTime转字符串
String? formatTime({String? formatter, DateTime? dateTime}) {
  if (dateTime == null) return '';
  String? formatterStr = ObjectUtil.isEmptyString(formatter) ? formatter_a : formatter;
  var dateFormatter = DateFormat(formatterStr);
  String? dateTimeStr;
  try {
    dateTimeStr = dateFormatter.format(dateTime);
  } catch (e) {
    dateTimeStr = '';
    print(e);
  }
  return dateTimeStr;
}

//计算两个日期 相隔多少天
int diffDaysBetweenTwoDate(DateTime startTime, DateTime endTime) {
  return endTime.difference(startTime).inDays;
}

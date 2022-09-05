import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:permission_handler/permission_handler.dart';

Locale getCurrentLocale() {
  //获取当前locale 手机设置里面设置的 语言和地区
  Locale currentLocale = ui.window.locale;

  if (currentLocale.languageCode == 'zh') {
    //中文，不管是简体、繁体、香港、澳门、台湾等，都使用简体中文
    return Locale('zh', 'CN');
  } else {
    //其他全部使用英文
    return Locale('en', 'US');
  }
}

String? getFontFamilyByLanguage() {
  //获取当前locale 手机设置里面设置的 语言和地区
  Locale currentLocale = ui.window.locale;

  if (currentLocale.languageCode == 'zh') {
    //中文，不管是简体、繁体、香港、澳门、台湾等，都使用简体中文
    return null; //中文使用系统默认字体
  } else {
    //其他全部使用英文
    return 'AverageSans';
  }
}

Future<bool?> requestPhotosPermission() async {
  if (Platform.isAndroid) {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();

    return (statuses[Permission.storage] == PermissionStatus.granted);
  } else if (Platform.isIOS) {
//查看README podfile里有一些特殊的设置
    PermissionStatus status = await Permission.photos.request();

    return status == PermissionStatus.granted;
  }
}

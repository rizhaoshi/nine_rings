import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nine_rings/routes/app_routes.dart';
import './common/utils/common_util.dart';

Widget createApp() {
  return GetMaterialApp(
    initialRoute: Routes.SPLASH,
    getPages: AppPages.pages,
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primaryColor: Colors.white,
      fontFamily: getFontFamilyByLanguage(),
    ),
  );
}

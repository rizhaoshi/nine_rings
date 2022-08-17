import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nine_rings/routes/app_routes.dart';

Widget createApp() {
  return GetMaterialApp(
    initialRoute: Routes.MAIN,
    getPages: AppPages.pages,
  );
}

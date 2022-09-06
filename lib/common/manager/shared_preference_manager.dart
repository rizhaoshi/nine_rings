import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info/package_info.dart';
import 'package:get/get.dart';

class SharedPreferenceManager {
  static const String policyCacheKey = "Policy";

  static Future<bool> userHasAgreePolicy() async {
    var prefs = Get.find<SharedPreferences>();
    if (prefs.get(policyCacheKey) == null) {
      Map map = {};
      prefs.setString(policyCacheKey, json.encode(map));
    }
    //当前版本号
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String buildNumber = packageInfo.buildNumber;
    String? mapStr = prefs.getString(policyCacheKey);

    if (mapStr == null) {
      return false;
    }

    Map map = json.decode(mapStr);
    return map[buildNumber] ?? false;
  }

  static void saveUserPolicyCache() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String buildNumber = packageInfo.buildNumber;
    var prefs = Get.find<SharedPreferences>();
    String? mapStr = prefs.getString(policyCacheKey);
    if (mapStr != null) {
      Map map = json.decode(mapStr);
      map.putIfAbsent(buildNumber, () => true);
      prefs.setString(policyCacheKey, json.encode(map));
    }
  }
}

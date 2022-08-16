import 'package:nine_rings/app/modules/splash/splash_page.dart';
import 'package:nine_rings/app/modules/splash/splash_binding.dart';
import 'package:nine_rings/app/modules/main/main_page.dart';
import 'package:nine_rings/app/modules/main/main_binding.dart';
import 'package:nine_rings/app/modules/home/home_view.dart';
import 'package:nine_rings/app/modules/home/home_binding.dart';
import 'package:nine_rings/app/modules/target/target_page.dart';
import 'package:nine_rings/app/modules/target/target_binding.dart';
import 'package:get/get.dart';

abstract class AppPages {
  static final pages = [
    GetPage(
        name: Routes.SPLASH,
        page: () => SplashPage(),
        binding: SplashBinding()),
    GetPage(name: Routes.MAIN, page: () => MainPage(), binding: MainBinding()),
    GetPage(name: Routes.HOME, page: () => HomePage(), binding: HomeBinding()),
    GetPage(
        name: Routes.TARGET,
        page: () => TargetPage(),
        binding: TargetBinding()),
  ];
}

//命名路由名称
abstract class Routes {
  static const INITIAL = "/";

  //启动页
  static const SPLASH = "/splash";

  //主页
  static const MAIN = "/main";

  //首页
  static const HOME = "/home";

  //挑战目标页
  static const TARGET = "/target";
}

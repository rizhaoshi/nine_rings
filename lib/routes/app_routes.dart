import 'package:nine_rings/app/modules/splash/splash_page.dart';
import 'package:nine_rings/app/modules/splash/splash_binding.dart';
import 'package:nine_rings/app/modules/main/main_page.dart';
import 'package:nine_rings/app/modules/main/main_binding.dart';
import 'package:nine_rings/app/modules/home/home_view.dart';
import 'package:nine_rings/app/modules/home/home_binding.dart';
import 'package:get/get.dart';

abstract class AppPages {
  static final pages = [
    GetPage(
        name: Routes.SPLASH,
        page: () => SplashPage(),
        binding: SplashBinding()),
    GetPage(name: Routes.MAIN, page: () => MainPage(), binding: MainBinding()),
    GetPage(name: Routes.HOME, page: () => HomeView(), binding: HomeBinding()),
  ];
}

//命名路由名称
abstract class Routes {
  static const INITIAL = "/";
  static const SPLASH = "/splash";
  static const MAIN = "/main";
  static const HOME = "/home";
}

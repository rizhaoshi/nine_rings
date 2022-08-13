import 'package:nine_rings/app/modules/splash/splash_page.dart';
import 'package:nine_rings/app/modules/splash/splash_binding.dart';
import 'package:get/get.dart';

abstract class AppPages {
  static final pages = [
    GetPage(
        name: Routes.SPLASH,
        page: () => SplashPage(),
        binding: SplashBinding()),
  ];
}

//命名路由名称
abstract class Routes {
  static const INITIAL = "/";
  static const SPLASH = "/splash";
}

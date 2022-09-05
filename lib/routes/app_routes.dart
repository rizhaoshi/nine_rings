import 'package:nine_rings/app/modules/splash/splash_page.dart';
import 'package:nine_rings/app/modules/splash/splash_binding.dart';
import 'package:nine_rings/app/modules/main/main_page.dart';
import 'package:nine_rings/app/modules/main/main_binding.dart';
import 'package:nine_rings/app/modules/home/home_page.dart';
import 'package:nine_rings/app/modules/home/home_binding.dart';
import 'package:nine_rings/app/modules/target/target_page.dart';
import 'package:nine_rings/app/modules/target/target_binding.dart';
import 'package:get/get.dart';

import '../app/modules/exercise/exercise_binding.dart';
import '../app/modules/exercise/exercise_page.dart';
import '../app/modules/help/help_binding.dart';
import '../app/modules/help/help_page.dart';
import '../app/modules/target_detail/target_detail_binding.dart';
import '../app/modules/target_detail/target_detail_page.dart';

abstract class AppPages {
  static final pages = [
    GetPage(name: Routes.SPLASH, page: () => SplashPage(), binding: SplashBinding()),
    GetPage(name: Routes.MAIN, page: () => MainPage(), binding: MainBinding()),
    GetPage(name: Routes.HOME, page: () => HomePage(), binding: HomeBinding()),
    GetPage(name: Routes.TARGET, page: () => TargetPage(), binding: TargetBinding()),
    GetPage(name: Routes.TARGET_DETAIL, page: () => TargetDetailPage(), binding: TargetDetailBinding()),
    GetPage(name: Routes.EXERCISE, page: () => ExercisePage(), binding: ExerciseBinding()),
    GetPage(name: Routes.HELP, page: () => HelpPage(), binding: HelpBinding(), fullscreenDialog: true),
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

  static const EXERCISE = "/exercise";

  static const HELP = "/help";

  //挑战详情
  static const TARGET_DETAIL = "/target_detail";
}

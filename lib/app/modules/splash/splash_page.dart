import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nine_rings/app/modules/splash/splash_controller.dart';
import 'package:nine_rings/app/modules/splash/illustration.dart';
import 'package:nine_rings/common/config.dart';
import 'package:nine_rings/routes/app_routes.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: SplashPageView(),
    );
  }
}

class SplashPageView extends StatefulWidget {
  const SplashPageView({Key? key}) : super(key: key);

  @override
  State<SplashPageView> createState() => _SplashPageViewState();
}

class _SplashPageViewState extends State<SplashPageView> {
  SplashController splashController = Get.find<SplashController>();

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        PageView.builder(
            onPageChanged: (intex) {
              setState(() {
                _currentIndex = intex;
              });
            },
            itemCount: 2,
            itemBuilder: (BuildContext context, int index) {
              Illustration tration = splashController.list[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                        top: Get.height / 2 - (Get.width - 40) / 2 - 50),
                    child: SvgPicture.asset(
                      tration.asset!,
                      height: Get.width                                                                          ,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10, right: 20),
                    width: double.infinity,
                    child: Text(
                      tration.copyright ?? "",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        color: textGreyColor,
                      ),
                    ),
                  ),
                  index == splashController.list.length - 1
                      ? Container(
                          width: 260,
                          height: 50,
                          margin: const EdgeInsets.only(top: 30),
                          child: TextButton(
                            onPressed: () {
                              Get.toNamed(Routes.MAIN);
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith(
                                      (states) => commonGreenColor),
                              textStyle:
                                  MaterialStateProperty.all(const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.5,
                              )),
                              foregroundColor:
                                  MaterialStateProperty.all(textBlackColor),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(14.0))),
                            ),
                            child: Text('开启健康生活'),
                          ),
                        )
                      : Container(
                          margin: EdgeInsets.only(top: 30),
                          width: 220,
                          height: 50,
                          alignment: Alignment.center,
                          child: Text(
                            '远离不良生活习惯',
                            style: TextStyle(
                                color: textBlackColor,
                                fontSize: 22,
                                fontWeight: FontWeight.w400),
                          ),
                        )
                ],
              );
            }),
        Positioned(
          left: 0,
          right: 0,
          bottom: MediaQuery.of(context).padding.bottom + 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 8.0,
                height: 8.0,
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentIndex == 1
                      ? Colors.grey
                      : Colors.grey.withOpacity(0.7),
                ),
              ),
              Container(
                width: 8.0,
                height: 8.0,
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentIndex == 0
                        ? Colors.grey
                        : Colors.grey.withOpacity(0.7)),
              )
            ],
          ),
        )
      ],
    );
  }
}

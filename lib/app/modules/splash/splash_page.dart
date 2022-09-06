import 'dart:io';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nine_rings/app/modules/splash/splash_controller.dart';
import 'package:nine_rings/app/modules/splash/illustration.dart';
import 'package:nine_rings/common/config.dart';
import 'package:nine_rings/routes/app_routes.dart';
import '../../../common/manager/shared_preference_manager.dart';

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
  late bool needShowPolicyDialog;

  @override
  void initState() {
    super.initState();
    print("====initState====");
    Future.delayed(Duration.zero, () {
      return SharedPreferenceManager.userHasAgreePolicy().then((value) {
        if (!value) {
          _showPolicyDialog();
          print("====_showPolicyDialog====");
        }
      });
    });
  }

  _showPolicyDialog() {
    showDialog(
        context: Get.overlayContext!,
        barrierDismissible: false,
        builder: (context) {
          return WillPopScope(
              child: Material(
                type: MaterialType.transparency,
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 30),
                    padding: const EdgeInsets.only(top: 20, bottom: 20, left: 30, right: 20),
                    height: 340,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          child: Text('policy'.tr, style: TextStyle(fontSize: 18, color: textBlackColor, fontWeight: FontWeight.w500)),
                        ),
                        Expanded(
                            child: Scrollbar(
                          isAlwaysShown: true,
                          child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: Container(
                                width: double.infinity,
                                margin: const EdgeInsets.only(right: 12),
                                child: Text('policy_text'.tr,
                                    textAlign: TextAlign.left, style: TextStyle(fontSize: 14, color: textBlackColor, fontWeight: FontWeight.w400)),
                              )),
                        )),
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          height: 36,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  exit(0);
                                },
                                child: Container(
                                  width: 90,
                                  decoration: BoxDecoration(color: const Color.fromRGBO(242, 243, 244, 1), borderRadius: BorderRadius.circular(10)),
                                  alignment: Alignment.center,
                                  child: Text('quit'.tr,
                                      textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: textGreyColor, fontWeight: FontWeight.w400)),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                  SharedPreferenceManager.saveUserPolicyCache();
                                },
                                child: Container(
                                  width: 100,
                                  decoration: BoxDecoration(color: commonGreenColor, borderRadius: BorderRadius.circular(10)),
                                  alignment: Alignment.center,
                                  child: Text('agree'.tr,
                                      textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600)),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              onWillPop: () async {
                return false;
              });
        });
  }

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
                    margin: EdgeInsets.only(top: Get.height / 2 - (Get.width - 40) / 2 - 50),
                    child: SvgPicture.asset(
                      tration.asset!,
                      height: Get.width,
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
                              Get.offNamed(Routes.MAIN);
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.resolveWith((states) => commonGreenColor),
                              textStyle: MaterialStateProperty.all(const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.5,
                              )),
                              foregroundColor: MaterialStateProperty.all(textBlackColor),
                              shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0))),
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
                            style: TextStyle(color: textBlackColor, fontSize: 22, fontWeight: FontWeight.w400),
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
                  color: _currentIndex == 1 ? Colors.grey : Colors.grey.withOpacity(0.7),
                ),
              ),
              Container(
                width: 8.0,
                height: 8.0,
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(shape: BoxShape.circle, color: _currentIndex == 0 ? Colors.grey : Colors.grey.withOpacity(0.7)),
              )
            ],
          ),
        )
      ],
    );
  }
}

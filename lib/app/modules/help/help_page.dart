import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nine_rings/app/widgets/navigator_bar.dart';
import '../../../common/config.dart';
import 'package:launch_review/launch_review.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(244, 245, 246, 1),
        appBar: NavigatorBar(
            closeType: NavigatorBarCloseType.close,
            title: 'help'.tr,
            bgColor: Colors.transparent,
            closeCallBack: () {
              Get.back();
            }),
        body: SafeArea(
          child: Container(
            margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _praise(),
                _line(),
                _feedback(context),
                _line(),
                _policy(),
              ],
            ),
          ),
        ));
  }

  Widget _line() {
    return Container(height: 1, margin: const EdgeInsets.only(left: 15), width: double.infinity, color: const Color.fromRGBO(234, 238, 239, 1));
  }

  Widget _praise() {
    return GestureDetector(
      onTap: () {
        LaunchReview.launch(androidAppId: "com.xinle.asceticism", iOSAppId: "todo");
      },
      child: _content('praise'.tr),
    );
  }

  Widget _content(String content) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      height: 70,
      margin: const EdgeInsets.only(left: 15),
      alignment: Alignment.centerLeft,
      child: Text(content, style: TextStyle(color: textBlackColor, fontSize: 17, fontWeight: FontWeight.w500)),
    );
  }

  Widget _feedback(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showModalBottomSheet(context);
      },
      child: _content('feedback'.tr),
    );
  }

  Widget _policy() {
    return GestureDetector(
      onTap: () {
        //跳转系统浏览器
        //获取当前locale 手机设置里面设置的 语言和地区
        Locale currentLocale = ui.window.locale;
        if (currentLocale.languageCode == 'zh') {
          launch("https://shimo.im/docs/pvTHxYrvqkxPXjwG/");
        } else {
          launch("https://shimo.im/docs/VkGYJYDvWpddHTpG/");
        }
      },
      child: _content('policy'.tr),
    );
  }

  _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        enableDrag: true,
        builder: (ctx) {
          return Stack(
            fit: StackFit.expand,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(ctx).pop();
                },
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.transparent,
                ),
              ),
              Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: Container(
                    height: 200,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)), color: Colors.white),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            margin: const EdgeInsets.only(top: 20),
                            child: Text('contact me'.tr,
                                textAlign: TextAlign.left, style: TextStyle(color: textBlackColor, fontSize: 22, fontWeight: FontWeight.w600))),
                        _icon_content("assets/icons/common/email.svg", "l964882305@qq.com", 30.0),
                        _icon_content("assets/icons/common/wechat.svg", "li964882305", 25.0),
                      ],
                    ),
                  ))
            ],
          );
        });
  }

  Widget _icon_content(String icon, String content, double size) {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              margin: const EdgeInsets.only(right: 5),
              child: SvgPicture.asset(
                icon,
                width: size,
                height: size,
              )),
          Text(content, textAlign: TextAlign.left, style: TextStyle(color: textBlackColor, fontSize: 20, fontWeight: FontWeight.w500))
        ],
      ),
    );
  }
}

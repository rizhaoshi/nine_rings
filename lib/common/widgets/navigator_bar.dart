import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum NavigatorBarCloseType { close, back }

class NavigatorBar extends StatelessWidget implements PreferredSizeWidget {
  final NavigatorBarCloseType? closeType;
  final double? height;
  final Color? bgColor;
  final Color? baseColor;
  final String? title;
  final Function? closeCallBack;

  NavigatorBar(
      {Key? key,
      this.closeType = NavigatorBarCloseType.back,
      this.height = 55.0,
      this.bgColor = Colors.white,
      this.baseColor = Colors.blue,
      this.title,
      this.closeCallBack})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bgColor,
      padding: EdgeInsets.only(top: Get.context!.mediaQueryPadding.top),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            child: Align(
              alignment: Alignment.center,
              child: Text(
                title ?? "",
                style: TextStyle(
                    fontSize: 20,
                    color: baseColor,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 10,
            bottom: 0,
            child: Container(
              width: height,
              alignment: Alignment.center,
              child: TextButton(
                onPressed: () {
                  closeCallBack?.call();
                  Get.back();
                },
                style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.zero)),
                child: closeType == NavigatorBarCloseType.close
                    ? SvgPicture.asset(
                        "assets/icons/common/close.svg",
                        width: 30,
                        height: 30,
                        color: baseColor,
                      )
                    : SvgPicture.asset(
                        "assets/icons/common/chevron_left.svg",
                        width: 35,
                        height: 35,
                        color: baseColor,
                      ),
              ),
            ),
          ),
          // Positioned(child: child)
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height!);
}

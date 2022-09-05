import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nine_rings/common/config.dart';
import 'package:nine_rings/common/utils/object_util.dart';
import 'package:nine_rings/common/utils/common_util.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:get/get.dart';
import '../../widgets/show_custom_toast.dart';
import 'package:permission_handler/permission_handler.dart';

class SharePage extends StatefulWidget {
  final List<Widget>? originalWidgets;
  final Color baseColor;

  const SharePage({Key? key, this.originalWidgets, this.baseColor = Colors.blue}) : super(key: key);

  @override
  State<SharePage> createState() => _SharePageState();
}

class _SharePageState extends State<SharePage> {
  final GlobalKey repaintWidgetKey = GlobalKey();
  bool _shareButtonVisible = false;

  @override
  void initState() {
    super.initState();
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..indicatorType = EasyLoadingIndicatorType.ring
      ..loadingStyle = EasyLoadingStyle.light
      ..indicatorSize = 45.0
      ..radius = 10.0
      ..progressColor = Colors.yellow
      ..backgroundColor = Colors.white.withOpacity(0.9)
      ..boxShadow = [] //这么设置，backgroundColor设置透明度才有效
      ..indicatorColor = widget.baseColor
      ..textColor = Colors.yellow
      ..maskColor = Colors.black45
      ..userInteractions = false
      ..dismissOnTap = false;

    EasyLoading.instance.loadingStyle = EasyLoadingStyle.custom;
    EasyLoading.instance.maskType = EasyLoadingMaskType.custom;
    EasyLoading.show();

    Future.delayed(const Duration(milliseconds: 2500), () {
      EasyLoading.dismiss();
      setState(() {
        _shareButtonVisible = true;
      });
    });
  }

  List<Widget> _renderWidgets() {
    List<Widget> widgets = [];
    widgets.add(Container(
      child: Stack(
        children: [
          Container(
              margin: const EdgeInsets.only(top: 30, bottom: 30),
              width: double.infinity,
              height: 200,
              child: Lottie.asset('assets/animations/77378-sunset.json')),
          Positioned(
              right: 10,
              bottom: 5,
              child: Text("Dzeaze on lottiefiles.com",
                  textAlign: TextAlign.right, style: TextStyle(color: textGreyColor, fontSize: 14, fontWeight: FontWeight.w400)))
        ],
      ),
    ));
    if (!ObjectUtil.isEmptyList(widget.originalWidgets)) {
      widgets.addAll(widget.originalWidgets!);
    }

    return widgets;
  }

  void _saveImageToDisk(BuildContext ctx) async {
    try {
      bool? galleryCanUse = await requestPhotosPermission();
      if (galleryCanUse == null || galleryCanUse == false) {
        _showSettingsDialog(ctx);
      }
    } catch (e) {}

    BuildContext? buildContext = repaintWidgetKey.currentContext;
    if (buildContext != null) {
      RenderRepaintBoundary boundary = buildContext.findRenderObject()! as RenderRepaintBoundary;
      double dpr = ui.window.devicePixelRatio;
      ui.Image image = await boundary.toImage(pixelRatio: dpr);
      ByteData? byteDate = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteDate != null) {
        Map? result;
        try {
          result = await ImageGallerySaver.saveImage(byteDate.buffer.asUint8List());
        } catch (e) {
          print(e);
        }
        if (!ObjectUtil.isEmptyMap(result)) {
          bool? isSuccess = result!["isSuccess"];
          if (isSuccess != null && isSuccess == true) {
            //保存成功
            showCustomToast('save success'.tr);
            return;
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Scaffold(
        body: SafeArea(
          child: Container(
            color: const Color.fromRGBO(244, 245, 246, 1),
            child: Stack(
              children: [
                Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    child: Container(
                      height: 60,
                      child: _shareButtonVisible
                          ? Stack(
                              children: [
                                Positioned(
                                    bottom: 10,
                                    right: 15,
                                    top: 10,
                                    child: Container(
                                      width: 40,
                                      alignment: Alignment.center,
                                      child: TextButton(
                                        onPressed: () {
                                          _saveImageToDisk(context);
                                        },
                                        style: ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.zero)),
                                        child: SvgPicture.asset(
                                          "assets/icons/common/download.svg",
                                          width: 28,
                                          height: 28,
                                          color: widget.baseColor,
                                        ),
                                      ),
                                    )),
                              ],
                            )
                          : Container(),
                    )),
                Positioned(
                    left: 0,
                    right: 0,
                    top: 60,
                    bottom: 0,
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: RepaintBoundary(
                        key: repaintWidgetKey,
                        child: Container(
                          color: const Color.fromRGBO(244, 245, 246, 1),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: _renderWidgets(),
                          ),
                        ),
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  _showSettingsDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) {
          return WillPopScope(
              child: Material(
                type: MaterialType.transparency,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin: const EdgeInsets.only(top: 200, left: 40, right: 40),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          width: double.infinity,
                          child: Text('go to setting'.tr,
                              textAlign: TextAlign.center, style: TextStyle(color: textBlackColor, fontSize: 22, fontWeight: FontWeight.w600)),
                        ),
                        Container(
                            margin: const EdgeInsets.only(top: 15, left: 30, right: 30),
                            child: Text('album permission'.tr,
                                textAlign: TextAlign.center, style: TextStyle(color: textBlackColor, fontSize: 16, fontWeight: FontWeight.w400))),
                        Container(
                          margin: const EdgeInsets.only(top: 30),
                          height: 50,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Container(
                                  height: double.infinity,
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          top: BorderSide(width: 1.0, color: Color.fromRGBO(239, 240, 241, 1)),
                                          right: BorderSide(width: 1.0, color: Color.fromRGBO(239, 240, 241, 1)))),
                                  child: Center(
                                    child: Text('cancel'.tr, style: TextStyle(color: textBlackColor, fontSize: 18, fontWeight: FontWeight.w500)),
                                  ),
                                ),
                              )),
                              Expanded(
                                  child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                  Future.delayed(const Duration(milliseconds: 300), () {
                                    openAppSettings();
                                  });
                                },
                                child: Container(
                                  height: double.infinity,
                                  decoration: const BoxDecoration(border: Border(top: BorderSide(width: 1.0, color: Color.fromRGBO(239, 240, 241, 1)))),
                                  child: Center(
                                    child: Text('go to'.tr, style: TextStyle(color: textBlackColor, fontSize: 18, fontWeight: FontWeight.w500)),
                                  ),
                                ),
                              ))
                            ],
                          ),
                        ),
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
}

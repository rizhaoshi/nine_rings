import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nine_rings/app/bean/jounery.dart';
import 'package:nine_rings/app/bean/target_bean.dart';
import 'package:nine_rings/app/modules/target/target_edit.dart';
import 'package:nine_rings/app/modules/target_detail/share_page.dart';
import 'package:nine_rings/app/widgets/circular_progress_indicator.dart';
import '../../../common/config.dart';
import '../../../common/utils/date_time_util.dart';
import '../../../common/utils/object_util.dart';
import '../../widgets/count_down_view.dart';
import '../../widgets/jounery_item_view.dart';
import '../home/home_controller.dart';
import 'target_detail_controller.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class TargetDetailPage extends GetView<TargetDetailController> {
  const TargetDetailPage({Key? key}) : super(key: key);

  double _caculateProcess() {
    int total = Duration(days: controller.target.targetDays!).inSeconds;
    int duration = DateTime
        .now()
        .difference(controller.target.createTime!)
        .inSeconds;
    return duration / total;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoScaffold(
      body: Builder(
        builder: (context) =>
            AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.dark,
              child: CupertinoPageScaffold(
                child: Scaffold(
                  backgroundColor: const Color.fromRGBO(244, 245, 246, 1),
                  resizeToAvoidBottomInset: false,
                  appBar: PreferredSize(preferredSize: const Size.fromHeight(55.0), child: _createAppBar(context)),
                  body: SafeArea(
                    child: GetBuilder<TargetDetailController>(
                      id: "all",
                      builder: (ctr) =>
                          Container(
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _topTitle(),
                                  _countDown(),
                                  _renderNotes(context),
                                  _giveUp(),
                                ],
                              ),
                            ),
                          ),
                    ),
                  ),
                ),
              ),
            ),
      ),
    );
  }

  Widget _createAppBar(BuildContext context) {
    return Container(
      color: const Color.fromRGBO(244, 245, 246, 1),
      padding: EdgeInsets.only(top: Get.context!.mediaQueryPadding.top),
      child: Stack(
        children: [
          const Align(
            alignment: Alignment.center,
            child: Text(''),
          ),
          Positioned(
              top: 0,
              left: 10,
              bottom: 0,
              child: Container(
                width: 55.0,
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () {
                    HomeController homeController = Get.find<HomeController>();
                    homeController.updateData();
                    Get.back();
                  },
                  style: ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.zero)),
                  child: GetBuilder<TargetDetailController>(
                    id: "appbar",
                    builder: (ctr) =>
                        SvgPicture.asset(
                          "assets/icons/common/chevron_left.svg",
                          width: 38,
                          height: 38,
                          color: controller.target.targetColor,
                        ),
                  ),
                ),
              )),
          Positioned(
              top: 0,
              right: 15,
              bottom: 0,
              child: Container(
                width: 55,
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () {
                    //分享页面
                    CupertinoScaffold.showCupertinoModalBottomSheet(
                        context: context,
                        enableDrag: true,
                        expand: true,
                        backgroundColor: Colors.transparent,
                        builder: (ctx) =>
                            SharePage(
                              originalWidgets: [
                                _topTitle(),
                                _countDown(),
                                _renderNotes(context, buttonVisible: false),
                              ],
                              baseColor: controller.target.targetColor!,
                            ));
                  },
                  style: ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.zero)),
                  child: GetBuilder<TargetDetailController>(
                    id: "appbar",
                    builder: (ctr) => SvgPicture.asset('assets/icons/common/share_ios.svg', width: 35, height: 35, color: controller.target.targetColor),
                  ),
                ),
              )),
          GetBuilder<TargetDetailController>(
              id: "appbar",
              builder: (ctr) {
                return controller.target.targetStatus == TargetStatus.processing
                    ? Positioned(
                    top: 0,
                    right: 15 + 55,
                    bottom: 0,
                    child: Container(
                      width: 55,
                      alignment: Alignment.center,
                      child: TextButton(
                        onPressed: () {
                          //编辑目标
                          if (controller.isProcessing()) {
                            CupertinoScaffold.showCupertinoModalBottomSheet(
                                context: context,
                                builder: (context) => TaskEditPage(controller.target, enterType: TaskEditPageEnterType.Enter_Type_Edit),
                                enableDrag: true,
                                expand: true,
                                backgroundColor: Colors.transparent);
                          } else {
                            controller.updateTarget(controller.target);
                          }
                        },
                        style: ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.zero)),
                        child: SvgPicture.asset(
                          "assets/icons/common/edit.svg",
                          width: 35,
                          height: 35,
                          color: controller.target.targetColor,
                        ),
                      ),
                    ))
                    : const SizedBox.shrink();
              }),
        ],
      ),
    );
  }

  Widget _topTitle() {
    return Container(
      margin: const EdgeInsets.only(top: 40, left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              child: Text(
                controller.target.name ?? "",
                textAlign: TextAlign.left,
                style: TextStyle(color: controller.target.targetColor, fontWeight: FontWeight.w500, fontSize: 20.0),
              )),
          Container(
              margin: const EdgeInsets.only(top: 5),
              child: Text(
                "${'start_at'.tr} ${formatTime(formatter: formatter_b, dateTime: controller.target.createTime) ?? ""}",
                style: TextStyle(color: textGreyColor, fontSize: 16.0, fontWeight: FontWeight.w400),
              ))
        ],
      ),
    );
  }

  Widget _countDown() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 30, bottom: 30),
      margin: const EdgeInsets.only(top: 30, left: 20, right: 20),
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(10.0))),
      child: controller.target.targetStatus == TargetStatus.processing
          ? Stack(
        alignment: Alignment.center,
        children: [
          Container(
              alignment: Alignment.center,
              child: CircularProgressRoute(
                process: _caculateProcess(),
                circulColor: controller.target.targetColor!,
              )),
          Container(
              alignment: Alignment.center,
              child: CountDownView(
                beginTime: controller.target.createTime!,
                targetDays: controller.target.targetDays!,
                color: controller.target.targetColor!,
              ))
        ],
      )
          : (controller.target.targetStatus == TargetStatus.completed
          ? Stack(alignment: Alignment.center, children: [
        Container(child: Lottie.asset('assets/animations/lf30_editor_d9mlluqg.json', width: 300, height: 300, fit: BoxFit.fill, repeat: false)),
        Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: Container(
              child: Text('congraulations'.tr,
                  textAlign: TextAlign.center, style: TextStyle(color: controller.target.targetColor, fontSize: 30, fontWeight: FontWeight.w600)),
            )),
        Positioned(
            right: 20,
            bottom: 10,
            child: Text("Oleg Petrunchak-Fesenko on lottiefiles.com",
                textAlign: TextAlign.right, style: TextStyle(color: textGreyColor, fontSize: 14, fontWeight: FontWeight.w400)))
      ])
          : Stack(alignment: Alignment.bottomCenter, children: [
        Container(
          // color: Colors.orange,
            height: 300,
            child: Lottie.asset('assets/animations/76025-failed-location-verification.json',
                width: 170, height: 170, fit: BoxFit.contain, repeat: false)),
        Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: Container(
              child: Text('regret'.tr,
                  textAlign: TextAlign.center, style: TextStyle(color: controller.target.targetColor, fontSize: 30, fontWeight: FontWeight.w600)),
            )),
        Positioned(
            right: 20,
            bottom: 0,
            child: Text("Nguyễn Như Lân on lottiefiles.com",
                textAlign: TextAlign.right, style: TextStyle(color: textGreyColor, fontSize: 14, fontWeight: FontWeight.w400)))
      ])),
    );
  }

  Widget _renderNotes(BuildContext context, {bool buttonVisible = true}) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 30, bottom: controller.target.targetStatus == TargetStatus.processing ? 0 : 40),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.only(top: 20, left: 20, right: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('journey'.tr, style: TextStyle(color: textBlackColor, fontSize: 18, fontWeight: FontWeight.w500)),
              buttonVisible
                  ? (controller.target.targetStatus == TargetStatus.processing
                  ? InkWell(
                onTap: () {
                  _showShareDialog(context);
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 8),
                  width: 35,
                  height: 35,
                  alignment: Alignment.center,
                  child: SvgPicture.asset('assets/icons/common/edit_1.svg', width: 30, height: 30, color: controller.target.targetColor!),
                ),
              )
                  : Container())
                  : Container(),
            ],
          ),
          _jouneries()
        ],
      ),
    );
  }

  Widget _jouneries() {
    if (ObjectUtil.isEmptyList(controller.jouneries)) return Container();

    List<Widget> widgets = [];

    for (int i = 0; i < controller.jouneries.length; i++) {
      Jounery jounery = controller.jouneries[i];
      widgets.add(JouneryItemView(
        jounery: jounery,
        isFirstItem: i == 0,
        isLastItem: i == controller.jouneries.length - 1,
        baseColor: controller.target.targetColor!,
      ));
    }

    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widgets,
      ),
    );
  }

  void _showShareDialog(BuildContext context) {
    TextEditingController textEditingController = TextEditingController();
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) =>
            WillPopScope(
                child: Material(
                  type: MaterialType.transparency,
                  child: Scaffold(
                    resizeToAvoidBottomInset: true,
                    backgroundColor: Colors.transparent,
                    body: Stack(
                      fit: StackFit.expand,
                      children: [
                        GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              color: Colors.transparent,
                            )),
                        Center(
                          child: Container(
                            margin: const EdgeInsets.only(left: 40, right: 40),
                            width: double.infinity,
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 20),
                                  child: Text('journey'.tr, style: TextStyle(color: textBlackColor, fontSize: 24, fontWeight: FontWeight.w700)),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 20, left: 40, right: 40),
                                  width: double.infinity,
                                  height: 120,
                                  decoration: BoxDecoration(color: const Color.fromRGBO(239, 240, 241, 1), borderRadius: BorderRadius.circular(10)),
                                  child: TextField(
                                    controller: textEditingController,
                                    style: TextStyle(color: controller.target.targetColor!),
                                    maxLength: 200,
                                    maxLines: null,
                                    cursorColor: controller.target.targetColor!,
                                    decoration: InputDecoration(
                                        helperText: '${'record'.tr} ${controller.target.name!} ${'journey_lower'.tr}',
                                        hintStyle: TextStyle(color: textGreyColor, fontSize: 14),
                                        border: InputBorder.none,
                                        isCollapsed: true,
                                        counterStyle: TextStyle(color: textGreyColor, fontSize: 12),
                                        contentPadding: const EdgeInsets.all(10)),
                                    autofocus: true,
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 20),
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
                                                child: Text('cancel'.tr, style: TextStyle(color: textGreyColor, fontSize: 18, fontWeight: FontWeight.w500)),
                                              ),
                                            ),
                                          )),
                                      Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              //去除头尾空格
                                              String text = textEditingController.text.trim();
                                              if (ObjectUtil.isEmptyString(text)) return;
                                              controller.saveNote(text);
                                              Navigator.of(context).pop();
                                            },
                                            child: Container(
                                              height: double.infinity,
                                              decoration: const BoxDecoration(
                                                  border: Border(top: BorderSide(width: 1.0, color: Color.fromRGBO(239, 240, 241, 1)))),
                                              child: Center(
                                                child: Text('save'.tr, style: TextStyle(color: textGreyColor, fontSize: 18, fontWeight: FontWeight.w500)),
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
                      ],
                    ),
                  ),
                ),
                onWillPop: () async {
                  return true;
                }));
  }

  Widget _giveUp() {
    if (controller.target.targetStatus == TargetStatus.processing) {
      return Container(
        margin: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 40),
        alignment: Alignment.topRight,
        child: Container(
          height: 40,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
          child: TextButton(
            onPressed: () {
              _showGiveUpDialog();
            },
            style: ButtonStyle(shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)))),
            child: Text(
              'giveup_challenge'.tr,
              style: const TextStyle(color: Color.fromRGBO(220, 220, 220, 1), fontSize: 12),
            ),
          ),
        ),
      );
    }
    return Container();
  }

  _showGiveUpDialog() {
    if (controller.isProcessing()) {
      showDialog(
          context: Get.context!,
          builder: (ctx) {
            return WillPopScope(
                child: Material(
                  type: MaterialType.transparency,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Center(
                        child: Container(
                          margin: const EdgeInsets.only(left: 40, right: 40),
                          width: double.infinity,
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                                child: RichText(
                                  text: TextSpan(
                                      text: '${'give_up_promote'.tr}  ',
                                      style: TextStyle(fontSize: 20, color: textBlackColor, fontWeight: FontWeight.w400),
                                      children: [
                                        TextSpan(
                                            text: 'try_exercise'.tr,
                                            style: TextStyle(color: controller.target.targetColor!, fontSize: 24, fontWeight: FontWeight.w600),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                Navigator.of(Get.context!).pop();
                                                controller.pushExercisePage();
                                              }),
                                      ]),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 20),
                                height: 50,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.of(Get.context!).pop();
                                          },
                                          child: Container(
                                              height: double.infinity,
                                              decoration: const BoxDecoration(
                                                  border: Border(
                                                      top: BorderSide(width: 1.0, color: Color.fromRGBO(239, 240, 241, 1)),
                                                      right: BorderSide(width: 1.0, color: Color.fromRGBO(239, 240, 241, 1)))),
                                              child: Center(
                                                child: Text('cancel'.tr, style: TextStyle(color: textBlackColor, fontSize: 18, fontWeight: FontWeight.w500)),
                                              )),
                                        )),
                                    Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            controller.giveupTarget();
                                            Navigator.of(Get.context!).pop();
                                          },
                                          child: Container(
                                              height: double.infinity,
                                              decoration: const BoxDecoration(
                                                  border: Border(top: BorderSide(width: 1.0, color: Color.fromRGBO(239, 240, 241, 1)))),
                                              child: Center(
                                                child: Text('giveup'.tr,
                                                    style: const TextStyle(color: Color.fromRGBO(220, 220, 220, 1), fontSize: 12, fontWeight: FontWeight.w500)),
                                              )),
                                        )),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                onWillPop: () async {
                  return true;
                });
          });
    } else {
      controller.updateTarget(controller.target);
    }
  }
}

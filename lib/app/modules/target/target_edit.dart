import 'dart:ui';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:nine_rings/common/config.dart';
import 'package:nine_rings/app/bean/target_bean.dart';
import 'package:nine_rings/app/bean/sound_bean.dart';
import 'package:nine_rings/common/utils/object_util.dart';
import 'package:nine_rings/common/utils/date_time_util.dart';
import 'package:nine_rings/core/data_dao/providers/target_table_provider.dart';
import '../../../common/manager/notification_manager.dart';
import '../../../routes/app_routes.dart';
import '../../widgets/custom_dialog.dart';
import '../main/main_controller.dart';
import '../target_detail/target_detail_controller.dart';

enum TaskEditPageEnterType {
  Enter_Type_New,
  Enter_Type_Edit,
}

class TaskEditPage extends StatefulWidget {
  final TargetBean target;
  final TaskEditPageEnterType enterType;

  TaskEditPage(this.target, {this.enterType = TaskEditPageEnterType.Enter_Type_New});

  @override
  State<TaskEditPage> createState() => _TaskEditPageState();
}

class _TaskEditPageState extends State<TaskEditPage> {
  int? targetDays;
  Color? targetColor;
  TextEditingController textEditingController = TextEditingController()..addListener(() {});
  FocusNode focusNode = FocusNode();
  String? soundKey;
  List<TimeOfDay>? targetNotificationTimes;

  bool isDeleteMode = false;
  final _notificationTimesMaxLimit = 4;

  MainController mainController = Get.find<MainController>();
  late TargetDetailController targetDetailController;

  @override
  void initState() {
    super.initState();
    if (widget.enterType == TaskEditPageEnterType.Enter_Type_Edit) {
      targetDetailController = Get.find<TargetDetailController>();
    }

    targetDays = widget.target.targetDays;
    targetColor = widget.target.targetColor;
    if (ObjectUtil.isEmptyString(widget.target.soundKey)) {
      //新增时soundKey为null, 默认为第一个
      soundKey = notificationSounds[0].soundKey;
    } else {
      soundKey = widget.target.soundKey;
    }
    targetNotificationTimes = List.from(widget.target.notificationTimes ?? []);

    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          targetDays = null;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    textEditingController.dispose();
    focusNode.unfocus();
  }

  void _cancel() {
    Navigator.of(context).pop();
  }

  void _save() async {
    TargetTableProvider targetTableProvider = TargetTableProvider();
    if (widget.enterType == TaskEditPageEnterType.Enter_Type_Edit) {
      //编辑目标，更新数据库
      TargetBean updateTarget = TargetBean()
        ..id = widget.target.id
        ..name = widget.target.name
        ..targetDays = targetDays
        ..targetColor = targetColor
        ..soundKey = soundKey
        ..createTime = widget.target.createTime
        ..targetStatus = widget.target.targetStatus
        ..giveUpTime = widget.target.giveUpTime
        ..notificationTimes = List.from(targetNotificationTimes ?? []);

      //首先判断目标当前状态，如果不是在进行中，就不能编辑了，因为可能用户在这个页面停留了很长时间
      updateTarget = TargetBean.generateTargetCurrentStatus(updateTarget);

      if (updateTarget.targetStatus != TargetStatus.processing) {
        //如果目标已经不是进行中，则销毁当前页面，并刷新目标详情页
        targetDetailController.updateTarget(updateTarget);
        Navigator.of(context).pop();
      } else {
        targetTableProvider.updateTarget(updateTarget).then((value) {
          //刷新首页和详情页
          targetDetailController.updateTarget(updateTarget);
          mainController.refreshTargets();
          //更新推送时间
          NotificationManager.modifyTargetNotification(updateTarget);
          Navigator.of(context).pop();
        }).catchError((error) {
          print(error);
        });
      }
    } else if (widget.enterType == TaskEditPageEnterType.Enter_Type_New) {
      if (focusNode.hasFocus) {
        focusNode.unfocus();
      }
      //新增目标
      TargetBean saveTarget = TargetBean()
        ..name = widget.target.name
        ..targetDays = targetDays
        ..targetColor = targetColor
        ..soundKey = soundKey
        ..notificationTimes = List.from(targetNotificationTimes ?? []);

      targetTableProvider.insertTarget(saveTarget).then((value) {
        saveTarget.id = value['rowid'];
        saveTarget.createTime = strToDateTime(value['createTime']);
        //创建本地通知
        NotificationManager.createTargetNotification(saveTarget);

        //刷新主页任务列表
        mainController.refreshTargets();
        print("-------value = $value---------");
        Get.until((route) {
          if (route.settings.name == Routes.MAIN) {
            return true;
          }
          return false;
        });
      }).catchError((error) {
        print(error);
      });
    }
  }

  Widget? _renderTargetDays() {
    return Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.start,
        spacing: 16.0,
        runAlignment: WrapAlignment.start,
        runSpacing: 16.0,
        children: defaultTargetDays
            .map(
              (e) => InkWell(
                  onTap: () {
                    setState(() {
                      targetDays = e;
                    });
                    if (focusNode.hasFocus) {
                      focusNode.unfocus();
                    }
                    textEditingController.text = "";
                  },
                  child: Container(
                      width: 100,
                      height: 35,
                      decoration: BoxDecoration(
                          color: targetDays == e ? targetColor : const Color.fromRGBO(240, 240, 1, 1),
                          borderRadius: const BorderRadius.all(Radius.circular(10.0))),
                      alignment: Alignment.center,
                      child: Text(e.toString(),
                          style: TextStyle(color: targetDays == 0 ? Colors.white : textBlackColor, fontSize: 16.0, fontWeight: FontWeight.w400)))),
            )
            .toList());
  }

  Widget? _renderColorSelectWidget({Function(Color color)? colorSelectCallBack}) {
    return Wrap(
      direction: Axis.horizontal,
      alignment: WrapAlignment.start,
      spacing: 16.0,
      runAlignment: WrapAlignment.start,
      runSpacing: 16.0,
      children: colors
          .map((color) => InkWell(
                onTap: () {
                  colorSelectCallBack?.call(color);
                },
                child: Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                      color: color,
                      border: color == targetColor ? Border.all(width: 3.5, color: textBlackColor) : null,
                      borderRadius: const BorderRadius.all(Radius.circular(13))),
                ),
              ))
          .toList(),
    );
  }

  //定时通知时间wrap
  Widget _renderTimeNotificationWidget(bool isDeleteMode, {Function(int index)? deleteCallBack}) {
    if (ObjectUtil.isEmptyList(targetNotificationTimes)) return const SizedBox.shrink();
    return Wrap(
      direction: Axis.horizontal,
      alignment: WrapAlignment.start,
      spacing: 16.0,
      runAlignment: WrapAlignment.start,
      runSpacing: 16.0,
      children: targetNotificationTimes!.asMap().keys.map((index) {
        TimeOfDay timeOfDay = targetNotificationTimes![index];
        return TimeNotificationWidget(timeOfDay, isDeleteMode: isDeleteMode, bgColor: targetColor, deleteCallBack: () {
          deleteCallBack?.call(index);
        });
      }).toList(),
    );
  }

  String _renderDisplaySoundName() {
    String displaySoundName = '';
    for (int i = 0; i < notificationSounds.length; i++) {
      Sound sound = notificationSounds[i];
      if (sound.soundKey == soundKey) {
        displaySoundName = sound.soundName;
        break;
      }
    }
    return displaySoundName;
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Material(
            color: Colors.transparent,
            child: Scaffold(
                backgroundColor: Colors.white.withOpacity(0.9),
                body: SafeArea(
                    child: GestureDetector(
                        onTap: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          if (isDeleteMode) {
                            setState(() {
                              isDeleteMode = false;
                            });
                          }
                        },
                        child: Container(
                            child: Stack(
                          children: [
                            Positioned(
                                left: 0,
                                right: 0,
                                top: 0,
                                child: Container(
                                  height: 60,
                                  color: Colors.transparent,
                                  child: Stack(
                                    children: [
                                      Container(
                                          alignment: Alignment.center,
                                          child: Text(widget.target.name!, style: TextStyle(fontSize: 20, color: targetColor, fontWeight: FontWeight.w500))),
                                      Positioned(
                                          left: 20,
                                          top: 17.5,
                                          child: InkWell(
                                            onTap: () {
                                              _cancel();
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(5)), color: targetColor),
                                              width: 50,
                                              height: 25,
                                              alignment: Alignment.center,
                                              child: Text('cancel'.tr, style: const TextStyle(color: Colors.white, fontSize: 14)),
                                            ),
                                          )),
                                      Positioned(
                                          right: 20,
                                          top: 17.5,
                                          child: InkWell(
                                            onTap: () {
                                              _save();
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(5)), color: targetColor),
                                              width: 50,
                                              height: 25,
                                              alignment: Alignment.center,
                                              child: Text('save'.tr, style: const TextStyle(color: Colors.white, fontSize: 14)),
                                            ),
                                          )),
                                    ],
                                  ),
                                )),
                            Positioned(
                                left: 0,
                                right: 0,
                                top: 60,
                                bottom: 0,
                                child: SingleChildScrollView(
                                    child: Column(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(left: 20, right: 20),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Offstage(
                                              offstage: widget.enterType == TaskEditPageEnterType.Enter_Type_Edit,
                                              child: Container(
                                                  height: 60,
                                                  alignment: Alignment.centerLeft,
                                                  child: Text('select_day'.tr,
                                                      style: TextStyle(color: textBlackColor, fontSize: 18.0, fontWeight: FontWeight.w500)))),
                                          Offstage(
                                            offstage: widget.enterType == TaskEditPageEnterType.Enter_Type_Edit,
                                            child: Container(
                                                width: double.infinity, margin: const EdgeInsets.only(left: 5, right: 0.0), child: _renderTargetDays()),
                                          ),
                                          Offstage(
                                              offstage: widget.enterType == TaskEditPageEnterType.Enter_Type_Edit,
                                              child: Container(
                                                margin: const EdgeInsets.only(left: 0, right: 10, top: 15, bottom: 10),
                                                child: Text("${'custom_days'.tr} < = 100 ${'days'.tr}",
                                                    style: TextStyle(color: textBlackColor, fontSize: 16.0, fontWeight: FontWeight.w400)),
                                              )),
                                          Offstage(
                                            offstage: widget.enterType == TaskEditPageEnterType.Enter_Type_Edit,
                                            child: Container(
                                              margin: const EdgeInsets.only(left: 5.0, right: 10.0),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: 90,
                                                    height: 35,
                                                    alignment: Alignment.center,
                                                    decoration: const BoxDecoration(
                                                        color: Color.fromRGBO(230, 230, 230, 1), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                    child: TextField(
                                                      focusNode: focusNode,
                                                      inputFormatters: [InputDaysFormatter()],
                                                      onChanged: (String str) {},
                                                      controller: textEditingController,
                                                      textAlign: TextAlign.center,
                                                      textAlignVertical: TextAlignVertical.center,
                                                      cursorColor: targetColor,
                                                      keyboardType: TextInputType.number,
                                                      style: TextStyle(color: targetColor, fontSize: 20.0, fontWeight: FontWeight.w500),
                                                      decoration: const InputDecoration(
                                                          contentPadding: EdgeInsets.only(left: 15, right: 15),
                                                          border: OutlineInputBorder(borderSide: BorderSide.none)),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Text(
                                                    "days".tr,
                                                    style: TextStyle(color: textBlackColor, fontSize: 16.0, fontWeight: FontWeight.w400),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(top: 20),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                    height: 60,
                                                    alignment: Alignment.centerLeft,
                                                    child: Text("select_color".tr,
                                                        style: TextStyle(color: textBlackColor, fontSize: 18.0, fontWeight: FontWeight.w500))),
                                                Container(
                                                  margin: const EdgeInsets.only(left: 10, right: 10),
                                                  child: _renderColorSelectWidget(colorSelectCallBack: (color) {
                                                    print(color);
                                                    setState(() {
                                                      targetColor = color;
                                                    });
                                                  }),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(top: 20),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                    height: 60,
                                                    alignment: Alignment.centerLeft,
                                                    child: Text("notify_sound".tr,
                                                        style: TextStyle(color: textBlackColor, fontSize: 18.0, fontWeight: FontWeight.w500))),
                                                Container(
                                                  height: 45,
                                                  margin: const EdgeInsets.only(left: 5, right: 5),
                                                  decoration: const BoxDecoration(
                                                      color: Color.fromRGBO(230, 230, 230, 1), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                  child: TextButton(
                                                    onPressed: () {
                                                      showModalBottomSheet(
                                                          backgroundColor: Colors.transparent,
                                                          context: context,
                                                          isScrollControlled: true,
                                                          enableDrag: false,
                                                          builder: (ctx) {
                                                            return SoundSelectWidget(
                                                                soundKey: soundKey,
                                                                baseColor: targetColor,
                                                                selectSoundCallBack: (sound) {
                                                                  setState(() {
                                                                    soundKey = sound.soundKey;
                                                                  });
                                                                });
                                                          });
                                                    },
                                                    style: ButtonStyle(
                                                        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)))),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          margin: const EdgeInsets.only(left: 10, right: 10),
                                                          width: 30,
                                                          height: 30,
                                                          alignment: Alignment.center,
                                                          child: SvgPicture.asset(
                                                            'assets/icons/common/sound.svg',
                                                            color: targetColor,
                                                            width: 25,
                                                            height: 25,
                                                          ),
                                                        ),
                                                        Text(
                                                          _renderDisplaySoundName(),
                                                          style: TextStyle(color: targetColor, fontSize: 18.0, fontWeight: FontWeight.w400),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  margin: const EdgeInsets.only(top: 20),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        height: 60,
                                                        alignment: Alignment.centerLeft,
                                                        child: Row(
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            Text(
                                                              "notify_time".tr,
                                                              style: TextStyle(color: textBlackColor, fontWeight: FontWeight.w500, fontSize: 18.0),
                                                            ),
                                                            !ObjectUtil.isEmptyList(targetNotificationTimes)
                                                                ? InkWell(
                                                                    onTap: () {
                                                                      setState(() {
                                                                        isDeleteMode = !isDeleteMode;
                                                                      });
                                                                    },
                                                                    child: Container(
                                                                      margin: const EdgeInsets.only(left: 8, top: 4),
                                                                      width: 30,
                                                                      height: 30,
                                                                      alignment: Alignment.center,
                                                                      child: SvgPicture.asset(
                                                                        'assets/icons/common/minus.svg',
                                                                        color: targetColor,
                                                                        width: 25,
                                                                        height: 25,
                                                                      ),
                                                                    ),
                                                                  )
                                                                : const SizedBox.shrink(),
                                                            (ObjectUtil.isEmptyList(targetNotificationTimes) ||
                                                                    targetNotificationTimes!.length < _notificationTimesMaxLimit)
                                                                ? InkWell(
                                                                    onTap: () {
                                                                      setState(() {
                                                                        isDeleteMode = (isDeleteMode ? false : isDeleteMode);
                                                                      });
                                                                      //新增时间
                                                                      showTimePickerDialog(context, bgColor: targetColor,
                                                                          selectTimeCallBack: (selectedHour, selectedMins) {
                                                                        if (selectedHour != null && selectedMins != null) {
                                                                          print("$selectedHour========$selectedMins");
                                                                          TimeOfDay addenTimeOfDay =
                                                                              TimeOfDay(hour: int.parse(selectedHour), minute: int.parse(selectedMins));
                                                                          if (!targetNotificationTimes!.contains(addenTimeOfDay)) {
                                                                            setState(() {
                                                                              targetNotificationTimes!.add(addenTimeOfDay);
                                                                              targetNotificationTimes!.sort((e1, e2) {
                                                                                return (e1.hour.compareTo(e2.hour) == 0
                                                                                    ? e1.minute.compareTo(e2.minute)
                                                                                    : e1.hour.compareTo(e2.hour));
                                                                              });
                                                                            });
                                                                          }
                                                                        }
                                                                      });
                                                                    },
                                                                    child: Container(
                                                                      margin: const EdgeInsets.only(left: 8, top: 4),
                                                                      width: 30,
                                                                      height: 30,
                                                                      alignment: Alignment.center,
                                                                      child: SvgPicture.asset(
                                                                        'assets/icons/common/plus.svg',
                                                                        color: targetColor,
                                                                        width: 25,
                                                                        height: 25,
                                                                      ),
                                                                    ),
                                                                  )
                                                                : const SizedBox.shrink()
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: const EdgeInsets.only(left: 5, right: 0),
                                                        child: _renderTimeNotificationWidget(isDeleteMode, deleteCallBack: (index) {
                                                          print(index);
                                                          //删除时间
                                                          setState(() {
                                                            targetNotificationTimes!.removeAt(index);
                                                          });
                                                        }),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                )))
                          ],
                        )))))));
  }
}

class InputDaysFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (oldValue.text.isEmpty && newValue.text == "0") return oldValue;

    if (newValue.text == "") return newValue;

    if (int.parse(newValue.text) > 100) return oldValue;

    return newValue;
  }
}

class SoundSelectWidget extends StatefulWidget {
  final String? soundKey;
  final Color? baseColor;
  final Function(Sound selectSound)? selectSoundCallBack;

  SoundSelectWidget({this.soundKey, this.baseColor = Colors.green, this.selectSoundCallBack});

  @override
  State<SoundSelectWidget> createState() => _SoundSelectWidgetState();
}

class _SoundSelectWidgetState extends State<SoundSelectWidget> {
  List<Sound> sounds = List.from(notificationSounds);

  AudioCache? audioCache;
  AudioPlayer? audioPlayer;

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    audioCache = AudioCache(prefix: '');
    audioPlayer = AudioPlayer();
    if (!ObjectUtil.isEmptyString(widget.soundKey)) {
      for (int i = 0; i < sounds.length; i++) {
        Sound sound = sounds[i];
        if (sound.soundKey == widget.soundKey) {
          _selectedIndex = i;
          break;
        }
      }
    }
  }

  @override
  void dispose() {
    if (audioCache != null) audioCache = null;
    if (audioPlayer != null) audioPlayer = null;
    super.dispose();
  }

  Widget _renderSoundView(int selectIndex, {required Function(int index) callBack, required Function(Sound sound) selectSoundCallBack}) {
    List<Widget> widgets = [];
    widgets.add(Container(
      margin: const EdgeInsets.only(top: 20, bottom: 20),
      width: double.infinity,
      child: Text(
        "select_sound".tr,
        textAlign: TextAlign.center,
        style: TextStyle(color: textBlackColor, fontWeight: FontWeight.w600, fontSize: 22),
      ),
    ));

    for (int i = 0; i < sounds.length; i++) {
      Sound sound = sounds[i];

      widgets.add(GestureDetector(
          onTap: () async {
            callBack(i);
            if (audioPlayer != null) audioPlayer!.stop();
            await audioPlayer!.play(AssetSource(sound.soundPath));
          },
          child: Container(
              margin: const EdgeInsets.only(left: 60, right: 60, top: 5, bottom: 5),
              height: 50,
              width: double.infinity,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: selectIndex == i ? widget.baseColor!.withOpacity(0.2) : Colors.white,
                  borderRadius: selectIndex == i ? const BorderRadius.all(Radius.circular(10)) : null),
              child: Text(
                sound.soundName,
                textAlign: TextAlign.center,
                style: TextStyle(color: textBlackColor, fontWeight: FontWeight.w400, fontSize: 20),
              ))));
    }

    widgets.add(GestureDetector(
      onTap: () async {
        selectSoundCallBack(sounds[_selectedIndex]);
      },
      child: Container(
        margin: const EdgeInsets.only(top: 20, bottom: 20, left: 90, right: 90),
        height: 45,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: widget.baseColor!, borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: Text("confirm".tr, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w400)),
      ),
    ));
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Stack(fit: StackFit.expand, children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
            color: Colors.transparent,
          ),
        ),
        Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration:
                  const BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)), color: Colors.white),
              child: Container(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 10.0),
                child: _renderSoundView(_selectedIndex, callBack: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                }, selectSoundCallBack: (sound) {
                  Navigator.of(context).pop();
                  widget.selectSoundCallBack?.call(sound);
                }),
              ),
            ))
      ]),
    );
  }
}

class TimeNotificationWidget extends StatefulWidget {
  final TimeOfDay timeOfDay;
  final bool isDeleteMode;
  final Color? bgColor;
  final Function? deleteCallBack;

  TimeNotificationWidget(this.timeOfDay, {this.isDeleteMode = false, this.bgColor, this.deleteCallBack});

  @override
  State<TimeNotificationWidget> createState() => _TimeNotificationWidgetState();
}

class _TimeNotificationWidgetState extends State<TimeNotificationWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 100,
        height: 35,
        decoration: BoxDecoration(color: widget.bgColor, borderRadius: const BorderRadius.all(Radius.circular(10.0))),
        child: Stack(children: [
          Container(
              alignment: Alignment.center,
              child: Text(timeOfDayToStr(widget.timeOfDay) ?? "", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 16.0))),
          widget.isDeleteMode
              ? Positioned(
                  top: 0,
                  right: 0,
                  child: InkWell(
                      onTap: () {
                        //删除这一条时间
                        widget.deleteCallBack?.call();
                      },
                      child: Container(
                          width: 30,
                          height: 30,
                          alignment: Alignment.topRight,
                          decoration: const BoxDecoration(borderRadius: BorderRadius.only(topRight: Radius.circular(10.0))),
                          child: SvgPicture.asset(
                            'assets/icons/common/minus.svg',
                            width: 20,
                            height: 20,
                            color: Colors.white,
                          ))))
              : const SizedBox.shrink()
        ]));
  }
}

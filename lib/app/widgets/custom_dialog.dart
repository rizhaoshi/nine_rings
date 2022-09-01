import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nine_rings/common/config.dart';
import 'package:nine_rings/common/extensions/string_extension.dart';

void showTimePickerDialog(BuildContext context, {Color? bgColor, Function(String? selectedHour, String? selectedMins)? selectTimeCallBack}) {
  showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return NotificationTimePicker(bgColor: bgColor, selectTimeCallBack: selectTimeCallBack);
      });
}

class NotificationTimePicker extends StatefulWidget {
  final Color? bgColor;

  final Function(String? selectedHour, String? seletedMins)? selectTimeCallBack;

  NotificationTimePicker({this.selectTimeCallBack, this.bgColor});

  @override
  State<NotificationTimePicker> createState() => _NotificationTimePickerState();
}

class _NotificationTimePickerState extends State<NotificationTimePicker> {
  String? selectedHour;
  String? selectedMinutes;
  FixedExtentScrollController? hourScrollController;
  FixedExtentScrollController? minutesScrollController;

  bool hourPickerIsScroll = false;
  bool minutesPickerIsScroll = false;

  @override
  void initState() {
    super.initState();
    selectedHour = "21";
    selectedMinutes = "30";
    hourScrollController = FixedExtentScrollController(initialItem: 21);
    minutesScrollController = FixedExtentScrollController(initialItem: 30);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Material(
          type: MaterialType.transparency,
          child: Align(
            alignment: Alignment.center,
            child: Container(
              width: 140,
              height: 70,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.white,
              ),
              alignment: Alignment.center,
              child: Container(
                width: 100,
                height: 40,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Color.fromRGBO(230, 230, 230, 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        child: NotificationListener(
                            onNotification: (scroll) {
                              if (scroll is ScrollStartNotification) {
                                hourPickerIsScroll = true;
                              } else if (scroll is ScrollEndNotification) {
                                hourPickerIsScroll = false;
                              }
                              return true;
                            },
                            child: CupertinoPicker(
                              selectionOverlay: const CupertinoPickerDefaultSelectionOverlay(
                                background: Colors.transparent,
                              ),
                              itemExtent: 40,
                              scrollController: hourScrollController,
                              onSelectedItemChanged: (index) {
                                selectedHour = hours[index];
                              },
                              children: hours
                                  .map((e) => Container(
                                        padding: const EdgeInsets.only(right: 4),
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          e.addZero(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontWeight: FontWeight.w600, color: widget.bgColor),
                                        ),
                                      ))
                                  .toList(),
                            ))),
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        ':',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18.0, color: widget.bgColor),
                      ),
                    ),
                    Expanded(
                        child: NotificationListener(
                            onNotification: (scroll) {
                              if (scroll is ScrollStartNotification) {
                                minutesPickerIsScroll = true;
                              } else if (scroll is ScrollEndNotification) {
                                minutesPickerIsScroll = false;
                              }
                              return true;
                            },
                            child: CupertinoPicker(
                              selectionOverlay: const CupertinoPickerDefaultSelectionOverlay(
                                background: Colors.transparent,
                              ),
                              itemExtent: 40,
                              scrollController: minutesScrollController,
                              onSelectedItemChanged: (index) {
                                selectedMinutes = minutes[index];
                              },
                              children: minutes
                                  .map((e) => Container(
                                        padding: const EdgeInsets.only(left: 4),
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          e.addZero(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontWeight: FontWeight.w600, color: widget.bgColor),
                                        ),
                                      ))
                                  .toList(),
                            ))),
                  ],
                ),
              ),
            ),
          ),
        ),
        onWillPop: () async {
          print('====$selectedHour====$selectedMinutes====');
          if (!hourPickerIsScroll && !minutesPickerIsScroll) widget.selectTimeCallBack?.call(selectedHour, selectedMinutes);
          return true;
        });
  }
}

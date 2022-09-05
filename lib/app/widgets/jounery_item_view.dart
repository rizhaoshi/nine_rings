import 'package:flutter/material.dart';
import '../../common/config.dart';
import '../../common/utils/date_time_util.dart';
import '../bean/jounery.dart';

class JouneryItemView extends StatefulWidget {
  final Jounery jounery;
  final bool isFirstItem;
  final bool isLastItem;
  final bool isOnlyOneItem;
  final Color baseColor;

  const JouneryItemView(
      {Key? key, required this.jounery, this.isFirstItem = false, this.isLastItem = false, this.isOnlyOneItem = false, required this.baseColor})
      : super(key: key);

  @override
  State<JouneryItemView> createState() => _JouneryItemViewState();
}

class _JouneryItemViewState extends State<JouneryItemView> {
  ValueNotifier<double?> totalheight = ValueNotifier<double?>(null);
  double circulSize = 14.0;

  @override
  void initState() {
    super.initState();
    //该Widget绘制结束后的回调，可以在这个回调里获取widget的高度
    WidgetsBinding.instance.addPostFrameCallback((_) {
      totalheight.value = context.size!.height;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: totalheight,
        builder: (context, height, child) {
          return Container(
            child: Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: circulSize,
                      height: circulSize,
                      decoration: BoxDecoration(color: widget.baseColor, borderRadius: BorderRadius.circular(circulSize / 2)),
                    ),
                    Expanded(
                        child: Container(
                      margin:const EdgeInsets.only(left: 20),
                      padding:const EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(formatTime(formatter: formatter_a, dateTime: widget.jounery.createTime) ?? "",
                              style: TextStyle(color: textBlackColor, fontSize: 14)),
                          Text("${widget.jounery.text}", style: TextStyle(color: widget.baseColor, fontSize: 16, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ))
                  ],
                ),
                height != null
                    ? widget.isOnlyOneItem == false
                        ? (widget.isFirstItem
                            ? Container()
                            : Positioned(
                                top: 0,
                                left: circulSize / 2 - 1,
                                child: Container(width: 2, height: totalheight.value! / 2 - circulSize / 2 - 8, color: widget.baseColor)))
                        : Container()
                    : Container(),
              ],
            ),
          );
        });
  }
}

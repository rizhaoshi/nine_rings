import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainPageTabView extends StatefulWidget {
  final List<String>? tabIcons;
  final Color? activeColor;
  final Color? bgColor;
  final Function(int index)? onPress;
  int selectedIndex;

  MainPageTabView(
      {Key? key,
      required this.tabIcons,
      this.activeColor,
      this.bgColor,
      this.onPress,
      this.selectedIndex = 0})
      : assert(tabIcons!.length <= 5),
        assert(selectedIndex <= tabIcons!.length - 1),
        super(key: key);

  @override
  State<MainPageTabView> createState() => _MainPageTabViewState();
}

class _MainPageTabViewState extends State<MainPageTabView> {
  List<Widget> _renderTabButtons() {
    return widget.tabIcons!.asMap().keys.map<Widget>((index) {
      String asset = widget.tabIcons![index];
      return Container(
        width: Get.width / widget.tabIcons!.length,
        height: double.infinity,
        color: widget.bgColor,
        child: IconButton(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onPressed: () {
            if (index == widget.selectedIndex) return;
            if (widget.onPress != null) {
              widget.onPress!(index);
            }
            setState(() {
              widget.selectedIndex = index;
            });
          },
          icon: SvgPicture.asset(
            asset,
            color: index == widget.selectedIndex
                ? widget.activeColor
                : Colors.grey,
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: _renderTabButtons(),
      ),
    );
  }
}

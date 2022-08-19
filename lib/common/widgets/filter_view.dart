import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nine_rings/app/modules/main/main_controller.dart';
import 'package:nine_rings/common/config.dart';
import 'package:nine_rings/app/modules/home/home_controller.dart';
import 'package:nine_rings/core/data_dao/providers/target_table_provider.dart';

class FilterView extends StatefulWidget {
  final MainController mainController;

  final Function(FilterType selectedType) callBack;

  FilterView({Key? key, required this.mainController, required this.callBack}) : super(key: key);

  @override
  State<FilterView> createState() => _FilterViewState();
}

class _FilterViewState extends State<FilterView> with SingleTickerProviderStateMixin {
  late FilterType filterType;
  late int filterIndex = 0;

  double top = -500;
  late Animation<double> animation;
  late AnimationController animationController;
  late CurvedAnimation curve;

  Widget _renderFilterView(int selectedIndex, {required Function(int index) callBack}) {
    List<FilterBean> filters = [
      FilterBean('all'.tr, "assets/icons/common/disappointed_face.svg"),
      FilterBean('progressing'.tr, "assets/icons/common/beaming_face_with_smiling_eyes.svg"),
      FilterBean('completed'.tr, "assets/icons/common/beaming_face_with_smiling_eyes.svg"),
      FilterBean('giveup'.tr, "assets/icons/common/disappointed_face.svg")
    ];
    List<Widget> widgets = [];

    for (int i = 0; i < filters.length; i++) {
      FilterBean filterBean = filters[i];
      widgets.add(GestureDetector(
        onTap: () {
          callBack(i);
        },
        child: Container(
          color: Colors.white,
          height: 50,
          child: Stack(
            fit: StackFit.expand,
            children: [
              i < filters.length
                  ? Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 1,
                        color: const Color.fromRGBO(230, 230, 230, 1),
                      ))
                  : Container(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    filterBean.icon,
                    width: 24,
                    height: 24,
                  ),
                  Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: Text(
                        filterBean.name,
                        style: TextStyle(color: textBlackColor, fontWeight: FontWeight.w400, fontSize: 18),
                      )),
                  Expanded(child: Container()),
                  i == selectedIndex
                      ? Container(
                          margin: const EdgeInsets.only(left: 10),
                          child: SvgPicture.asset(
                            'assets/icons/common/check.svg',
                            width: 25,
                            height: 25,
                            color: Colors.red,
                          ),
                        )
                      : Container(),
                ],
              ),
            ],
          ),
        ),
      ));
    }

    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(Get.context!).padding.top, left: 30, right: 30, bottom: 6),
      decoration: const BoxDecoration(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)), color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: widgets,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    HomeController homeController = Get.find<HomeController>();
    filterType = homeController.filterType;
    filterIndex = getFilterIndex(filterType);

    animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    curve = CurvedAnimation(parent: animationController, curve: Curves.fastOutSlowIn);
    animation = Tween<double>(begin: -500, end: 0).animate(curve)
      ..addListener(() {
        setState(() {
          top = animation.value;
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.dismissed) {
          widget.mainController.hideFilterView();
        }
      });
    animationController.forward();
  }

  int getFilterIndex(FilterType type) {
    int index = 0;
    switch (type) {
      case FilterType.all:
        index = 0;
        break;
      case FilterType.processing:
        index = 1;
        break;
      case FilterType.completed:
        index = 2;
        break;
      case FilterType.giveUp:
        index = 3;
        break;
    }
    return index;
  }

  FilterType getFilterType(int index) {
    FilterType type = FilterType.all;
    switch (index) {
      case 0:
        type = FilterType.all;
        break;
      case 1:
        type = FilterType.processing;
        break;
      case 2:
        type = FilterType.completed;
        break;
      case 3:
        type = FilterType.giveUp;
        break;
    }
    return type;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (animationController.isAnimating) return;
        animationController.reverse();
        widget.callBack(getFilterType(filterIndex));
      },
      child: Container(
        color: Colors.black45.withOpacity(0.3),
        child: Stack(
          children: [
            Positioned(
                top: top,
                left: 0,
                right: 0,
                child: _renderFilterView(filterIndex, callBack: (index) {
                  setState(() {
                    filterIndex = index;
                  });
                }))
          ],
        ),
      ),
    );
  }
}

class FilterBean {
  String name;
  String icon;

  FilterBean(this.name, this.icon);
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Builder(
      builder: (context) => AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark,
          child: CupertinoPageScaffold(
            child: Scaffold(
              backgroundColor: const Color.fromRGBO(244, 245, 246, 1),
              body: SafeArea(
                top: false,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: double.infinity,
                          height: 240,
                          decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), color: Colors.white),
                          margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 10, left: 10, right: 10),
                        ),
                      ),
                      Expanded(
                          child: Container(
                        width: double.infinity,
                        color: Colors.yellow,
                      ))
                    ],
                  ),
                ),
              ),
            ),
          )),
    ));
  }
}

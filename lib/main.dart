import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app.dart';

void main() {
  runApp(createApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'NineRings',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

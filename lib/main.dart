import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'app.dart';
import 'core/data_dao/providers/target_table_provider.dart';
import 'core/data_dao/providers/note_table_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  _createTables();
  runApp(createApp());
  //安卓如何不设置以下的，状态栏上会有一层灰色的蒙层
  SystemUiOverlayStyle systemUiOverlayStyle =const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, //设置为透明// Color for Android
    // statusBarBrightness: Brightness.light// Dark == white status bar -- for IOS.
  );
  SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
}

void _createTables() async {
  TargetTableProvider tableProvider = TargetTableProvider();
  NoteTableProvider noteTableProvider = NoteTableProvider();
  await tableProvider.createTable();
  await noteTableProvider.createTable();
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

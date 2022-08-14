import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app.dart';
import 'core/data_dao/providers/target_table_provider.dart';
import 'core/data_dao/providers/note_table_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  _createTables();
  runApp(createApp());
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

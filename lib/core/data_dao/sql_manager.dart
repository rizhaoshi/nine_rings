import 'package:sqflite/sqflite.dart';
import '../../common/utils/object_util.dart';

class SqlManager {
  //数据库版本
  static const _VERSION = 1;

  //数据库名
  static const _DB_NAME = 'nine_rings.db';

  //数据库对象
  static Database? _database;

  //初始化数据库对象
  static init() async {
    //数据库在本地的位置
    String dbPath = '${await getDatabasesPath()}/$_DB_NAME';
    _database = await openDatabase(dbPath, version: _VERSION, onCreate: (db, version) {});
  }

  //获取当前数据库对象,第一获取没有创建就创建
  static Future<Database> getCurrentDataBase() async {
    if (_database == null) {
      await init();
    }

    return _database!;
  }

  //判断是否存在
  static Future<bool> isTableExists(String tableName) async {
    await getCurrentDataBase();
    var res = await _database?.rawQuery("select*from sqlite_master where type= 'table' and name ='$tableName'");
    return !ObjectUtil.isEmptyList(res);
  }

  //关闭数据库
  static void close() {
    _database?.close();
    _database = null;
  }
}

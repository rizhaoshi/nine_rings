import 'package:nine_rings/core/data_dao/sql_manager.dart';
import 'package:sqflite/sqflite.dart';

abstract class BaseTableProvider {
  String tableName();

  String createTableString();

  //湖区数据库库对象
  Future<Database> getDataBase() async {
    bool isTableExist = await SqlManager.isTableExists(tableName());
    if (!isTableExist) {
      //表不存在 就创建
      Database db = await SqlManager.getCurrentDataBase();
      await db.execute(createTableString());
      return db;
    } else {
      return await SqlManager.getCurrentDataBase();
    }
  }

  //创建表
  Future<void> createTable() async {
    bool isTableExist = await SqlManager.isTableExists(tableName());
    if (!isTableExist) {
      Database db = await SqlManager.getCurrentDataBase();
      await db.execute(createTableString());
    }
  }
}

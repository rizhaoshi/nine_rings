import 'base_table_provider.dart';
import 'package:nine_rings/app/bean/target_bean.dart';
import 'package:sqflite/sqflite.dart';
import '../../../common/utils/date_time_util.dart';

enum FilterType {
  all, //所有
  processing, //进行中
  completed, //已完成
  giveUp, //放弃
}

class TargetTableProvider extends BaseTableProvider {
  final String tablename = 'target';

  //表列名
  final String columnId = 'id';
  final String columnTargetName = 't_name';
  final String columnTargetDays = 't_days';
  final String columnTargetColors = 't_colors';
  final String columnTargetSoundKey = 't_sound_key';
  final String columnTargetNotificationTimes = 't_notification_times';
  final String columnTargetCreateTime = 't_create_time';
  final String columnTargetDeleteTime = 't_delete_time';
  final String columnTargetGiveUpTime = 't_give_up_time';

  @override
  String createTableString() {
    return '''CREATE TABLE $tablename (
    $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
    $columnTargetName TEXT NOT NULL,
    $columnTargetDays INTEGER NOT NULL,
    $columnTargetColors TEXT,
    $columnTargetSoundKey TEXT NOT NULL,
    $columnTargetNotificationTimes TEXT,
    $columnTargetCreateTime TEXT NOT NULL,
    $columnTargetDeleteTime TEXT,
    $columnTargetGiveUpTime TEXT)''';
  }

  @override
  String tableName() {
    return tablename;
  }

  //新增一条目标数据
  Future insertTarget(TargetBean target) async {
    Database db = await getDataBase();
    String name = target.name!;
    int days = target.targetDays!;
    String? colors = target.targetColor == null ? null : "${target.targetColor!.red}|${target.targetColor!.green}|${target.targetColor!.blue}";
    String soundKey = target.soundKey!;
    String? notificationTimes;
    if (target.notificationTimes != null) {
      String times = "";
      for (int i = 0; i < target.notificationTimes!.length; i++) {
        times += timeOfDayToStr(target.notificationTimes![i])!;
        if (i < target.notificationTimes!.length - 1) {
          times += "|";
        }
      }
      notificationTimes = times;
    }
    String nowStr = formatTime(formatter: formatter_a, dateTime: DateTime.now())!;
    //执行插入操作 返回插入的主键id
    return await db.transaction((txn) async {
      int rowid = await txn.rawInsert(
          'INSERT INTO $tablename($columnTargetName,$columnTargetDays,$columnTargetColors,$columnTargetSoundKey,$columnTargetNotificationTimes,$columnTargetCreateTime) VALUES("$name","$days","$colors","$soundKey","$notificationTimes","$nowStr")');
      return {"rowid": rowid, "createTime": nowStr};
    });
  }

  //查询所有目标
  Future<List<TargetBean>> queryTarget({FilterType? filterType}) async {
    Database db = await getDataBase();
    String? sql;
    if (filterType != null) {
      if (filterType == FilterType.giveUp) {
        //查询已放弃目标数据
        sql = 'SELECT*FROM $tablename WHERE $columnTargetGiveUpTime IS NOT NULL ORDER BY $columnTargetCreateTime DESC';
      } else if (filterType == FilterType.completed || filterType == FilterType.processing) {
        //查询已完成或进行中目标数据
        sql = 'SELECT*FROM $tablename WHERE $columnTargetGiveUpTime IS NULL ORDER BY $columnTargetCreateTime DESC';
      } else {
        //查询所有数据
        sql = 'SELECT*FROM $tablename ORDER BY $columnTargetCreateTime DESC';
      }
    } else {
      //查询所有数据
      sql = 'SELECT*FROM $tablename ORDER BY $columnTargetCreateTime DESC';
    }
    List<Map<String, dynamic>> results = await db.rawQuery(sql);
    List<TargetBean> targets = [];
    results.forEach((element) {
      TargetBean? target = TargetBean.targetBeanFromMap(element);
      if (target != null) {
        targets.add(target);
      }
    });
    return targets;
  }

  //更新操作

  Future updateTarget(TargetBean target) async {
    Database db = await getDataBase();
    //只能更新颜色 通知时间 声音
    String? colors = target.targetColor == null ? null : "${target.targetColor!.red}|${target.targetColor!.green}|${target.targetColor!.blue}";
    String? notificationTimes;
    if (target.notificationTimes != null) {
      String times = "";
      for (int i = 0; i < target.notificationTimes!.length; i++) {
        times += timeOfDayToStr(target.notificationTimes![i])!;
        if (i < target.notificationTimes!.length - 1) {
          times += "|";
        }
      }
      notificationTimes = times;
    }
    String soundKey = target.soundKey!;

    //执行更新操作 返回插入的主键id
    return await db.transaction((txn) async {
      int count = await txn.rawUpdate(
          'UPDATE $tablename SET $columnTargetColors= ?,$columnTargetSoundKey= ?,$columnTargetNotificationTimes= ? WHERE $columnId= ?',
          [colors, soundKey, notificationTimes, target.id]);
      return count;
    });
  }

  //放弃目标
  Future giveUpTarget(TargetBean target) async {
    Database db = await getDataBase();
    String now = formatTime(dateTime: DateTime.now())!;
    return await db.transaction((txn) async {
      int count = await txn.rawUpdate('UPDATE $tablename SET $columnTargetGiveUpTime=? WHERE $columnId=', [now, target.id]);
      return count;
    });
  }
}

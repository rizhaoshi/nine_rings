import 'package:nine_rings/app/bean/note_bean.dart';
import 'package:nine_rings/common/utils/object_util.dart';
import 'package:sqflite/sqflite.dart';
import '../../../common/utils/date_time_util.dart';
import 'base_table_provider.dart';

class NoteTableProvider extends BaseTableProvider {
  final String tablename = 'note';

  //表列名
  final String columnId = 'id';
  final String columnTargetId = 'target_id';
  final String columnNote = 'note';
  final String columnCreateTime = 'n_create_time';

  @override
  String createTableString() {
    return '''CREATE TABLE $tablename (
    $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
    $columnTargetId INTEGER NOT NULL,
    $columnNote TEXT NOT NULL,
    $columnCreateTime TEXT NOT NULL)''';
  }

  @override
  String tableName() {
    return tablename;
  }

  //新增一条日记数据
  Future insertNote(NoteBean note) async {
    Database db = await getDataBase();
    int targetId = note.targetId!;
    String noteText = note.note!;
    String? createTime = formatTime(dateTime: note.createTime!);
    if (ObjectUtil.isEmptyString(createTime)) return;
    //执行插入操作 返回插入的主键id
    return await db.transaction((txn) async {
      int rowid = await txn.rawInsert('INSERT INTO $tablename($columnTargetId,$columnNote,$columnCreateTime) VALUES($targetId,"$noteText","$createTime")');
      return rowid;
    });
  }

  //查询某条目标下的所有日记
  Future<List<NoteBean>> queryNotesByTarget({required int targetId}) async {
    Database db = await getDataBase();
    String sql = 'SELECT*FROM $tablename WHERE $columnTargetId=$targetId ORDER BY $columnCreateTime';
    List<Map<String, dynamic>> results = await db.rawQuery(sql);
    List<NoteBean> notes = [];
    results.forEach((element) {
      NoteBean? note = NoteBean.noteBeanFromMap(element);
      if (note != null) {
        notes.add(note);
      }
    });

    return notes;
  }
}

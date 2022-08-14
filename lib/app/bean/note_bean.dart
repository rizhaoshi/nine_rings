import '../../common/utils/object_util.dart';
import '../../common/utils/date_time_util.dart';

class NoteBean {
  int? id;
  int? targetId;

  String? note;
  DateTime? createTime;

  NoteBean clone() {
    return NoteBean()
      ..id = id
      ..targetId = targetId
      ..note = note
      ..createTime = createTime;
  }

  static NoteBean? noteBeanFromMap(Map<String, dynamic> map) {
    if (ObjectUtil.isEmptyMap(map)) return null;

    //创建时间解析
    String crateTimeStr = map['n_create_time'];
    DateTime? crateTime = strToDateTime(crateTimeStr);

    return NoteBean()
      ..id = map['id'] as int
      ..targetId = map['target_id'] as int
      ..note = map['note'] as String
      ..createTime = crateTime;
  }
}
